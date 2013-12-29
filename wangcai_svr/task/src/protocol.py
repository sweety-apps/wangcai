
import json
from data_types import Task


class Request(object):
    def __init__(self, input):
        pass

class Response(object):
    def __init__(self):
        self.rtn = 0
        self._data = {}

    def __getattr__(self, key):
        if key in self._data:
            return self._data[key]
        else:
            raise AttributeError, key
            
    def __setattr__(self, key, value):
        if key in ['rtn', '_data']:
            object.__setattr__(self, key, value)
        elif key in self._data:
            self._data[key] = value
        else:
            raise AttributeError, key

    @staticmethod
    def __json_encode(o):
        if isinstance(o, Task):
            return o.to_dict()
        return json.JSONEncoder.default(self, o)


    def dump_json(self):
        self._data['rtn'] = self.rtn
        return json.dumps(self._data, ensure_ascii=False, default=Response.__json_encode)

######################################

class ListTaskOfDevice_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.device_id = input.device_id

class ListTaskOfDevice_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self._data = {
            'task_list': []
        }

######################################

class ListTaskOfUser_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.userid = int(input.userid)

class ListTaskOfUser_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self._data = {
            'task_list': []
        }

######################################

class ReportInvite_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.userid = int(input.userid)
        self.invitee = int(input.invitee)
        self.invite_code = input.invite_code

class ReportInvite_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self._data = {
            'total_invite': 0
        }

######################################

class ReportUserInfo_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.device_id = input.device_id
        self.userid = int(input.userid)

class ReportUserInfo_Resp(Response):
    def __init__(self):
        Response.__init__(self)



