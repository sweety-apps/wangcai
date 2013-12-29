# -*- coding: utf-8 -*-

import web
import logging
import protocol
from config import *
from utils import *


logger = logging.getLogger()

class Handler:
    def POST(self):
        req = protocol.UpdateInviterReq(web.input(), web.cookies())
        resp = protocol.UpdateInviterResp()

        url = 'http://' + ACCOUNT_BACKEND + '/update_inviter'
        data = {
            'device_id': req.device_id,
            'userid': req.userid,
            'invite_code': req.inviter
        }

        r = http_request(url, data)
        if not r.has_key('rtn') or r['rtn'] != 0:
            resp.res = 1
            resp.msg = 'error'
            return resp.dump_json()
            
        inviter_id = int(r['inviter'])
        #在任务系统进行记录
        url = 'http://' + TASK_BACKEND + '/report_inviter'
        data = {
            'userid': inviter_id,
            'invite_code': req.inviter,
            'invitee': req.userid
        }

        r = http_request(url, data)
        if r.has_key('rtn') and r['rtn'] == 0:
            return resp.dump_json()
        else:
            resp.res = 1
            resp.msg = 'error'
            return resp.dump_json



