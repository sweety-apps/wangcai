# -*- coding: utf-8 -*-

import web
import logging
import protocol
from config import *
from utils import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        logger.debug('GET')
        req = protocol.TaskListReq(web.input(), web.cookies())
        resp = protocol.TaskListResp()

        #查设备任务
        url = 'http://' + TASK_BACKEND + '/list/task_of_device?device_id=' + req.device_id

        r = http_request(url)
        if r.has_key('rtn') and r['rtn'] == 0:
            task_map = dict([(task['id'], task) for task in r['task_list']])
        else:
            task_map = {}

        #已绑定,查帐号任务
        if req.userid != 0:
            url = 'http://' + TASK_BACKEND + '/list/task_of_user?userid=' + str(req.userid)
            r = http_request(url)
            if r.has_key('rtn') and r['rtn'] == 0:
                for task in r['task_list']:
                    if task['id'] in task_map:
                        task_map[task['id']]['status'] = task['status']
                    else:
                        task_map[task['id']] = task

        resp.task_list = task_map.values()
        return resp.dump_json()


