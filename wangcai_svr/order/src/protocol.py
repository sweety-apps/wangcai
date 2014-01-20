
import json
from data_types import *

class Request(object):
    def __init__(self):
        pass

class Response(object):
    def __init__(self):
        self.rtn = 0

    @staticmethod
    def __json_encode(o):
        if isinstance(o, ExchangeEntry):
            return o.__dict__
        raise TypeError('type error!! ' + str(type(o)))

    def dump_json(self):
        return json.dumps(self.__dict__, ensure_ascii=False, default=Response.__json_encode)

######################################

class AlipayTransfer_Req(Request):
    def __init__(self, input):
        Request.__init__(self)
        self.userid = int(input.userid)
        self.device_id = input.device_id
        self.serial_num = input.serial_num
        self.money = int(input.money)
        self.alipay_account = input.alipay_account

class AlipayTransfer_Resp(Response):
    def __init__(self):
        Response.__init__(self)

######################################

class PhonePayment_Req(Request):
    def __init__(self, input):
        Request.__init__(self)
        self.userid = int(input.userid)
        self.device_id = input.device_id
        self.serial_num = input.serial_num
        self.money = int(input.money)
        self.phone_num = input.phone_num

class PhonePayment_Resp(Response):
    def __init__(self):
        Response.__init__(self)

######################################

class ExchangeList_Req(Request):
    def __init__(self, input):
        Request.__init__(self)

class ExchangeList_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.exchange_list = []

######################################

class ExchangeCode_Req(Request):
    def __init__(self, input):
        Request.__init__(self)
        self.userid = int(input.userid)
        self.device_id = input.device_id
        self.serial_num = input.serial_num
        self.exchange_type = int(input.exchange_type)

class ExchangeCode_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.exchange_code = ''

######################################

class OrderDetail_Req(Request):
    def __init__(self, input):
        Request.__init__(self)
        self.userid = int(input.userid)
        self.order_id = input.order_id

class OrderDetail_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.type = 0
        self.status = 0
        self.money = 0
        self.create_time = 0
        self.confirm_time = 0
        self.operate_time = 0
        self.extra = ''

