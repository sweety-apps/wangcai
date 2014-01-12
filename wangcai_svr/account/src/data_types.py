# -*- coding: utf-8 -*-

class UserInfo:
    def __init__(self):
        self.userid = 0
        self.phone_num = ''
        self.nickname = ''
        self.sex = 0
        self.age = 0
        self.interest = ''
        self.invite_code = ''
        self.inviter_id = 0
        self.inviter_code = ''


class UserDevice:
    def __init__(self):
        self.device_id = ''
        self.mac = ''
        self.idfa = ''
        self.platform = ''
        self.userid = 0
        self.status = 0


class AnonymousDevice:
    def __init__(self):
        self.device_id = ''
        self.mac = ''
        self.idfa = ''
        self.platform = ''
        self.flag = 0
        self.sex = 0
        self.age = 0
        self.interest = ''

