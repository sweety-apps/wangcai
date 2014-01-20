# -*- coding: utf-8 -*-

import web 
import re
import json
import urllib
import logging
import memcache
from config import *
from utils import *
from session_manager import SessionManager

logger = logging.getLogger('root')

class Handler:
    def __init__(self):
        self.re_idfa = re.compile('[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$')
        self.re_mac = re.compile('[0-9A-F]{12}$')

    def POST(self):
        params = web.input()
        idfa = params.get('idfa', '').upper()
        mac = params.get('mac', '').upper()

        if not self.re_idfa.match(idfa) or not self.re_mac.match(mac):
            resp = { 'res': 1, 'msg': '参数错误' }
            return json.dumps(resp)

        cookies = web.cookies()
        logger.debug('cookies: platform=%s, version=%s%s, network=%s' \
                %(cookies.get('p', ''), 
                    cookies.get('app', ''),
                    cookies.get('ver', ''),
                    cookies.get('net', '')))
        logger.debug('client ip: %s' %web.ctx.ip)

        data = {
            'idfa': idfa,
            'mac': mac,
            'platform': cookies.get('p', ''),
            'version': cookies.get('app', '')+cookies.get('ver', ''),
            'network': cookies.get('net', ''),
            'ip': web.ctx.ip,
        }

        url = 'http://' + ACCOUNT_BACKEND + '/register'

        r = http_request(url, data)
        if r['rtn'] != 0:
            resp = { 'res': 1, 'msg': 'error' }
            return json.dumps(resp)

        userid = r['userid']
        device_id = r['device_id']

        #创建session缓存
        session_id = SessionManager.instance().create_session(device_id, userid)
#        session_id = generate_session_id()
        resp = {
            'res': 0,
            'msg': '',
            'session_id': session_id,
            'device_id': device_id,
            'invite_code': r['invite_code'],
            'userid': userid,
            'inviter': r['inviter'],
            'phone': r['phone_num'],
            'balance': 0,
            'income': 0,
            'outgo': 0,
            'recent_income': 0,
            'shared_income': 0,
            'force_update': 0
        }

        if r['new_device']:
            logger.info('new device, idfa:%s, mac:%s' %(params.idfa, params.mac))

        data = {
            'userid': userid,
            'device_id': device_id
        }

        url = 'http://' + BILLING_BACKEND + '/query_balance?' + urllib.urlencode(data)

        r = http_request(url)
        if r['rtn'] == 0:
            resp['balance'] = r['balance']
            resp['income'] = r['income']
            resp['outgo'] = r['outgo']
            resp['shared_income'] = r['shared_income']
            resp['task_list'] = self.query_task_list(userid, device_id)
#            resp['recent_income'] = 
        return json.dumps(resp, ensure_ascii=False, indent=2)

    def query_task_list(self, userid, device_id):
        #查设备任务
        url = 'http://' + TASK_BACKEND + '/list/task_of_device?device_id=' + device_id
        r = http_request(url)
        if r['rtn'] == 0:
            task_map = dict([(task['id'], task) for task in r['task_list']])
        else:
            task_map = {}
            
        #已绑定,查帐号任务
        if userid != 0:
            url = 'http://' + TASK_BACKEND + '/list/task_of_user?userid=' + str(userid)
            r = http_request(url)
            if r['rtn'] == 0:
                for task in r['task_list']:
                    if task['id'] in task_map:
                        if task_map[task['id']]['status'] != 0:
                            status = task_map[task['id']]['status']
                        elif task['status'] != 0:
                            status = task['status']
                        else:
                            status = 0
                        #相同id的任务进行合并
                        task_map[task['id']]['status'] = status
                    else:
                        task_map[task['id']] = task

        version = web.cookies().get('ver', '')

        #为苹果审核屏蔽
        if version == '1.1':
            if 5 in task_map:
                del task_map[5]
            if 6 in task_map:
                del task_map[6]

        return sorted(task_map.values(), key=lambda x: x['id'])

