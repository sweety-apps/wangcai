# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol
from config import *
from utils import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.ExchangeListReq(web.input(), web.cookies())
        resp = protocol.ExchangeListResp()

        url = 'http://' + ORDER_BACKEND + '/exchange_list'
        r = http_request(url)
        if r['rtn'] == 0:
            resp.exchange_list = r['exchange_list']
        else:
            resp.res = r['rtn']

        return resp.dump_json()

        resp.exchange_list = [
            {
                'name': '50元京东礼品卡',
                'type': 1,
                'icon': 'http://getwangcai.com/images/jingdong.png',
                'price': 3000,
                'remain': 10
            },

            {
                'name': '迅雷白金会员月卡',
                'type': 2,
                'icon': 'http://getwangcai.com/images/xlvip.png',
                'price': 800,
                'remain': 100
            }
        ]

        return resp.dump_json()
