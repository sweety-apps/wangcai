# -*- coding: utf-8 -*-

import web
import logging
import protocol
import db_helper
from data_types import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        req = protocol.ListTaskOfUser_Req(web.input())
        resp = protocol.ListTaskOfUser_Resp()

        task_list = db_helper.select_builtin_task()
        if task_list is None or len(task_list) == 0:
            return resp.dump_json()

        task_map = dict([(task.id, task) for task in task_list])

        #处理用户信息等任务状态
        for each in db_helper.select_task_of_user(req.userid):
            if each.task_id in task_map:
                task_map[each.task_id].status = each.status

        #处理邀请任务状态


        #处理签到任务状态


        
        resp.task_list = task_map.values()
        return resp.dump_json()

