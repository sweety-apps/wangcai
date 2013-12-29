#!/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import web
import logging
from logging.handlers import RotatingFileHandler

import req_task_of_device
import req_task_of_user
import req_report_task_invite
import req_report_task_user_info


def init_logger(path, level=logging.NOTSET, maxBytes=50*1024*1024, backupCount=20):
    logger = logging.getLogger()
    logger.setLevel(level)
    file_handler = RotatingFileHandler(path, maxBytes=maxBytes, backupCount=backupCount)
    file_handler.setFormatter(logging.Formatter("[%(asctime)s] [%(levelname)s] %(message)s", "%Y%m%d %H:%M:%S"))
    logger.addHandler(file_handler)


urls = (
    '/list/task_of_device', req_task_of_device.Handler,
    '/list/task_of_user', req_task_of_user.Handler,
    '/report_invite', req_report_task_invite.Handler,
    '/report_user_info', req_report_task_user_info.Handler
)


init_logger("../log/task.log")

app = web.application(urls, globals(), autoreload = False)

if __name__ == '__main__':
    app.run()
else:
    application = app.wsgifunc()

