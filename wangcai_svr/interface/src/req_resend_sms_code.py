
import web
import json
import logging
import protocol
from sms_center import *

logger = logging.getLogger()

class Handler:
    def POST(self):
        req = protocol.ResendSmsCodeReq(web.input(), web.cookies())
        resp = protocol.ResendSmsCodeResp()

        sms = SMSCenter.instance()

        item = sms.find_item(req.token)
        if item is None:
            resp.res = 1
            resp.msg = 'error'
            return resp.dump_json()
            
        sms_code = sms.gen_sms_code(req.code_len)
        logger.debug('new sms code: %s' %sms_code)

        sms.update_sms_code(self, req.token, sms_code)

        ret = sms.send_sms(item['phone_num'], sms_code)
        if ret:
            sms.update_status(req.token, SMSStatus.SMS_SUCC)
        else:
            sms.update_status(req.token, SMSStatus.SMS_FAIL)
            resp.res = 1
            resp.msg = 'error'

        return resp.dump_json()
