# -*- coding: utf-8 -*-

import web
import json
import random
import logging
import db_helper

class Handler:
    def init(self):
        params = web.input()
        self._device_id = params.device_id
        self._userid = int(params.userid)
        self._phone_num = params.phone

    def gen_invite_code(self, code_len=5):
        selection = '23456789ABCDEFGHJKLMNPQRSTWXYZ'
        code = ''
        for each in range(0, code_len):
            code += selection[random.randint(0, len(selection)-1)]
        return code

    def POST(self):
        self.init()
        if self._userid == 0:
            resp = self.bind_phone_num()
        else:
            resp = self.update_phone_num()
        return json.dumps(resp)

        
    def bind_phone_num(self):
        logger = logging.getLogger('root')
        assert self._userid == 0

        #初次绑定手机,从anonymous_device转移到user_device
        anony = db_helper.query_anonymous_device(self._device_id)
        if anony is None:
            logger.error('query_anonymous_device failed!! device_id:%s' %self._device_id)    
            return {'rtn': 1}
        elif anony.flag == 1: #已被绑定
            logger.error('query_anonymous_device, flag=1, device_id:%s' %self._device_id)
            return {'rtn': 1}
        else:
            userid = db_helper.insert_user_info(self._phone_num, anony.sex, anony.age, anony.interest, self.gen_invite_code())
            assert userid != 0
            db_helper.insert_user_device(userid, self._device_id, anony.idfa, anony.mac, anony.platform)
            db_helper.update_anonymous_device_flag(self._device_id, 1)
            return {'rtn': 0, 'userid': userid}


    def update_phone_num(self):
        assert self._userid != 0

        #重新绑定手机,只改user_info中的手机号
        db_helper.update_phone_num(self._userid, self.phone_num)
        return {'rtn': 0, 'userid': self._userid}

