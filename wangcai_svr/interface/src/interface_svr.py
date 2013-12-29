#!/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import web
import utils
import req_register
import req_bind_phone
import req_account_info
import req_update_user_info
import req_update_inviter
import req_check_sms_code
import req_resend_sms_code
import req_task_list


urls = (
    '/0/register', req_register.Handler,
    '/0/account/bind_phone', req_bind_phone.Handler,
    '/0/account/info', req_account_info.Handler,
    '/0/account/update_user_info', req_update_user_info.Handler,
    '/0/account/update_inviter', req_update_inviter.Handler,
    '/0/sms/check_sms_code', req_check_sms_code.Handler,
    '/0/sms/resend_sms_code', req_resend_sms_code.Handler,
    '/0/task/list', req_task_list.Handler
)

web.config.debug = True
#web.internalerror = web.debugerror

utils.init_logger("../log/interface.log")

app = web.application(urls, globals(), autoreload=False)

if __name__ == '__main__':
    app.run()
else:
    application = app.wsgifunc()

