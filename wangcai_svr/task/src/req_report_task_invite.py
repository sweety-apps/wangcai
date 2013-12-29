# -*- coding: utf-8 -*-
# 邀请任务

import web
import logging
import protocol
import db_helper
from data_types import *

logger = logging.getLogger()

class Handler:
    def POST(self):
        req = protocol.ReportInvite_Req(web.input())
        resp = protocol.ReportInvite_Resp()

        task = TaskInvite()
        task.userid = req.userid
        task.invitee = req.invitee
        task.invite_code = req.invite_code

        db_helper.insert_task_invite(task)

        resp.total_invite = db_helper.count_task_invite(req.userid)

        return resp.dump_json()


        

