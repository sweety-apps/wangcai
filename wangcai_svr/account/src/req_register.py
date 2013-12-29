# -*- coding: utf-8 -*-

import web
import json
import hashlib
import random
import logging
import db_helper


class Handler:
    def init(self):
        params = web.input()
        self._userid = 0
        self._mac = params.mac.upper()
        self._idfa = params.idfa.upper()
        self._platform = params.platform
        self._device_id = self.calc_device_id()
        self._phone_num = ''
        self._nickname = ''
        self._invite_code = ''
        self._inviter = ''

    def calc_device_id(self):
        if self._idfa == '':
            return hashlib.md5(self._mac).hexdigest()
        else:
            return hashlib.md5(self._idfa).hexdigest()

    def POST(self):
        logger = logging.getLogger('root')
        self.init()

        #先查anonymous_device
        device = db_helper.query_anonymous_device(self._device_id)
        if device is None:
            #查不到,直接插入
            self._device_id = db_helper.insert_anonymous_device(self._device_id, self._mac, self._idfa, self._platform)
        elif device.flag == 0:
            #未绑定
            pass
        else:
            #已绑定,查user_device与user_info
            device = db_helper.query_user_device(self._device_id)
            #能查到
            assert device is not None

            user = db_helper.query_user_info(self._userid)
            assert user is not None

            self._phone_num = user.phone_num
            self._invite_code = user.invite_code
            self._inviter = user.inviter



#        #先查user_device
#        device = db_helper.query_user_device(self._device_id)
#        if device is None:
#            #查不到,直接插入anonymous_device
#            self._invite_code = self.gen_invite_code()
#            db_helper.insert_anonymous_device(self._device_id, self._mac, self._idfa, self._platform, self._invite_code)
#        else:
#            #能查到,再查下user_info,获取phone_num
#            self._userid = device.userid
#            self._invite_code = device.invite_code
#            logger.debug('query_user_device succeed, userid:%d, invite_code:%s' %(self._userid, self._invite_code))
#            user = db_helper.query_user_info(self._userid)
#            if user is None:
#                logger.error('query_user_info failed!! userid:%d' %self._userid)
#                return json.dumps({'rtn': 1})
#            else:
#                self._phone_num = user.phone_num
#                self._nickname = user.nickname

        resp = {
            'rtn': 0,
            'userid': self._userid,
            'device_id': self._device_id,
            'invite_code': self._invite_code,
            'phone_num': self._phone_num,
            'inviter': self._inviter
        }

        return json.dumps(resp)

