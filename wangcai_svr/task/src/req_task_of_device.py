# -*- coding: utf-8 -*-

import web
import logging
import protocol
import db_helper
from data_types import *


logger = logging.getLogger()

class Handler:
    def GET(self):
        req = protocol.ListTaskOfDevice_Req(web.input())
        resp = protocol.ListTaskOfDevice_Resp()

        #检查签到任务状态


        #检查积分墙任务
        #1.获取线上厂商应用列表
        #2.分别检查是否已完成
        #3.返回结果数据
        task_list = db_helper.select_app_task()
        if task_list is None or len(task_list) == 0:
            pass
        else:
            for each in task_list:
                each.status = db_helper.query_task_status_of_device(req.device_id, each.id)
                resp.task_list.append(each)
                
        return resp.dump_json()

