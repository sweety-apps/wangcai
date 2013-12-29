# -*- coding: utf-8 -*-

import web
import json
import logging
from config import *
from utils import *
from sms_center import *

class Handler:
    def POST(self):
        logger = logging.getLogger('root')
        params = web.input()
#        device_id = params.device_id
        userid = int(params.userid)
        phone_num = params.phone

        data = {
            'userid': int(params.userid),
            'device_id': params.device_id,
            'phone': params.phone
        }

        logger.debug(dir(params))
        logger.debug('userid: ' + params.userid )
        logger.debug('device_id: ' + params.device_id)
        logger.debug('phone: ' + params.phone)

        sms = SMSCenter.instance()

        #创建短信任务,写数据库
        token, code = sms.create_sms_task(phone_num, SMSAction.BIND_PHONE, json.dumps(data))
        
        #发送短信
        ret = sms.send_sms(phone_num, code)
        if ret:
            sms.update_status(token, SMSStatus.SMS_SUCC)
            resp = {'res': 0, 'msg': '', 'token': token}
        else:
            sms.update_status(token, SMSStatus.SMS_FAIL)
            resp = {'res': 1, 'msg': 'error'}

        return json.dumps(resp)

