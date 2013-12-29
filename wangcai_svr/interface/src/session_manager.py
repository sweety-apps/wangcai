# -*- coding: utf-8 -*-

import memcache
import uuid
import logging
from config import *

class SessionManager:

    s_instance = None

    @classmethod
    def instance(cls):
        if cls.s_instance is None:
            cls.s_instance = cls()
        return cls.s_instance

    def __init__(self):
        self._mc = memcache.Client(SESSION_MEMCACHE, debug=0)

    def gen_session_id(self):
        return str(uuid.uuid4())

    def create_session(self, device_id, userid):
        logger = logging.getLogger('session_manager')
        #先查是否已有device->session的缓存
        session = self._mc.get(device_id)
        if session is None:
            session_id = self.gen_session_id()
            self._mc.set(SESSION_PREFIX + session_id, 
                    {
                        'device_id': device_id, 
                        'userid': userid
                    })
#            self._mc.set(device_id, )
        else:
            pass


    def check_session(self, session_id, device_id):
        device = self._mc.get(SESSION_PREFIX + session)
        if device is None or device.device_id != device_id:
            return False
        else:
            return True

    def add_session_cache(self, session_id, device):
        self._mc.set(SESSION_PREFIX + session_id, 
                    {
                        'device_id': device['device_id'],
                        'userid': device['userid']
                    })

    

