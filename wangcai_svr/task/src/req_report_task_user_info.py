# -*- coding: utf-8 -*-
# 填写个人资料任务

import web
import logging
import protocol
import db_helper

logger = logging.getLogger()

class Handler:
    def POST(self):
        req = protocol.ReportUserInfo_Req(web.input())
        resp = protocol.ReportUserInfo_Resp()

        if req.userid == 0:
            task = TaskOfDevice()
            task.device_id = req.device_id
            task.type = TaskType.T_INFO
            task.status = TaskStatus.S_DONE
            task.money = 0
            db_helper.insert_task_of_device(task)
        else:
            task = TaskOfUser()
            task.userid = req.userid
            task.device_id = req.device_id
            task.type = TaskType.T_INFO
            task.status = TaskStatus.S_DONE
            task.money = 0
            db_helper.insert_task_of_user(task)

        return resp.dump_json()


