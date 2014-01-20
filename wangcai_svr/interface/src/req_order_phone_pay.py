# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol
from config import *
from utils import *
from billing_client import *

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.PhonePayReq(web.input(), web.cookies())
        resp = protocol.PhonePayResp()

        #userid不能为0
        if req.userid == 0:
            resp.res = 1
            return resp.dump_json()

        #冻结
        rtn, sn = BillingClient.instance().freeze(req.userid, req.device_id, req.amount, '兑换%d元话费' %(req.amount/100))
        if rtn != 0:
            resp.res = rtn
            return resp.dump_json()
        else:
            #提交订单
            rtn = self.create_order(req.userid, req.device_id, sn, req.discount, req.phone_num)
            if rtn != 0:
                resp.res = rtn
            else:
                resp.order_id = sn
            return resp.dump_json()

        
    def create_order(self, userid, device_id, serial_num, money, phone_num):
        params = {
            'userid': userid,
            'device_id': device_id,
            'serial_num': serial_num,
            'money': money,
            'phone_num': phone_num
        }

        url = 'http://' + ORDER_BACKEND + '/phone_payment'

        r = http_request(url, params)
        return r['rtn']
