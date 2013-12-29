# -*- coding: utf-8 -*-

import json

class TaskType:
    '''任务类型定义,10000以内为预制任务
       1 - 安装旺财
       2 - 填写个人资料
       3 - 邀请好友
       4 - 每日签到
       10000 - 积分墙应用安装任务
    '''
    T_INSTALL = 1
    T_INFO    = 2
    T_INVITE  = 3
    T_SIGN_IN = 4
    T_BUILTIN = 9999
    T_APP = 10000

class TaskStatus:
    S_NORMAL = 0
    S_DONE = 1
    S_CANCEL = 100


class Task:
    ID_INSTALL = 1
    ID_INFO    = 2
    ID_INVITE  = 3
    ID_SIGN_IN = 4

    def __init__(self):
        self.id     = 0
        self.type   = 0
        self.status = 0
        self.title  = ''
        self.icon   = ''
        self.intro  = ''
        self.desc   = ''
        self.steps  = None
        self.money  = 0
        self.timestamp = 0

    def to_dict(self):
        return self.__dict__


class TaskOfDevice:
    def __init__(self):
        self.device_id = ''
        self.task_id = 0
        self.type = 0
        self.status = 0
        self.money = 0


class TaskOfUser:
    def __init__(self):
        self.userid = 0
        self.device_id = ''
        self.task_id = 0
        self.type = 0
        self.status = 0
        self.money = 0


class TaskInvite:
    def __init__(self):
        self.userid = 0
        self.invitee = 0
        self.invite_code = ''

class TaskUserInfo:
    def __init__(self):
        self.device_id = ''
        self.userid = 0
        self.task_id = 0
