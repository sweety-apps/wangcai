
import json

class Request(object):
    def __init__(self, input, cookies):
        self.platform = ''
        self.app = ''
        self.network = ''
        self.ip = ''

class Response(object):
    def __init__(self):
        self.res = 0
        self.msg = ''

    def dump_json(self):
        return json.dumps(self.__dict__, ensure_ascii=False)


class RegisterReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)

class RegisterResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.session_id = ''
        self.device_id = ''
        self.userid = 0
        self.nickname = ''
        self.phone = ''

class UpdateInviterReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = input.session_id
        self.device_id = input.device_id
        self.userid = input.userid
        self.inviter = input.inviter

class UpdateInviterResp(Response):
    def __init__(self):
        Response.__init__(self)

class ResendSmsCodeReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = input.session_id
        self.device_id = input.device_id
        self.userid = int(input.userid)
        self.token = input.token
        self.code_len = int(input.code_len)

class ResendSmsCodeResp(Response):
    def __init__(self):
        Response.__init__(self)


class TaskListReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = input.session_id
        self.device_id = input.device_id
        self.userid = int(input.userid)

class TaskListResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.task_list = []

