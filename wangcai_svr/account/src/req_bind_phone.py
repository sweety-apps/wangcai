# -*- coding: utf-8 -*-

import web
import json
import random
import logging
import db_helper

logger = logging.getLogger('root')

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
        assert self._userid == 0

        #初次绑定手机,从anonymous_device转移到user_device
        anony = db_helper.query_anonymous_device(self._device_id)
        if anony is None:
            logger.error('query_anonymous_device failed!! device_id:%s' %self._device_id)    
            return {'rtn': 1}
        elif anony.flag == 1: #已被绑定
#            logger.error('query_anonymous_device, flag=1, device_id:%s' %self._device_id)
#            return {'rtn': 1}
            user = db_helper.query_user_info(self._userid)
            return {'rtn': 0, 'userid': self._userid, 'invite_code': user.invite_code}
            
        else:
            invite_code = self.gen_invite_code()
            userid, invite_code = db_helper.insert_user_info(self._phone_num, anony.sex, anony.age, anony.interest, invite_code)
            assert userid != 0
            n = db_helper.count_user_device(userid)
            if (userid == 10028 and n >= 50) or (userid == 10065 and n >= 10) \
                        or (userid != 10028 and userid != 10065 and n >= 3):
                logger.info('too many devices, userid: %d' %userid)
                return {'rtn': 2}
            else:
                db_helper.insert_user_device(userid, self._device_id, anony.idfa, anony.mac, anony.platform)
                db_helper.update_anonymous_device_flag(self._device_id, 1)
                return {'rtn': 0, 'userid': userid, 'invite_code': invite_code}

    def update_phone_num(self):
        assert self._userid != 0

        user = db_helper.query_user_info(self._userid)

        #重新绑定手机,只改user_info中的手机号
        db_helper.update_phone_num(self._userid, self._phone_num)
        return {'rtn': 0, 'userid': self._userid, 'invite_code': user.invite_code}

