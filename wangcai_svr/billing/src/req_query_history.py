# -*- coding: utf-8 -*-
# 查询日志

import web
import logging
import protocol
import db_helper
from data_types import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.QueryHistory_Req(web.input())
        resp = protocol.QueryHistory_Resp()

        resp.history = db_helper.query_billing_log(req.device_id, req.userid, req.offset, req.num)
        return resp.dump_json()
        
