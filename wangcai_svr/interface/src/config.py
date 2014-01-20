# -*- coding: utf-8 -*-


ACCOUNT_BACKEND = '127.0.0.1:15281'
TASK_BACKEND = '127.0.0.1:15282'
BILLING_BACKEND = '127.0.0.1:15283'
ORDER_BACKEND = '127.0.0.1:15284'

MYSQL_HOST = 'localhost'
MYSQL_USER = 'root'
MYSQL_PASSWD = ''
MYSQL_DB = 'wangcai'

SESSION_MEMCACHE = ['127.0.0.1:11211']
SESSION_PREFIX = 'ss_'
SESSION_LIVETIME = 3600*8

SMS_API = 'http://106.ihuyi.com/webservice/sms.php'
SMS_USER = 'cf_ksd'
SMS_PASSWD = '1528studioihuyi'
SMS_TEMPLATE = '您的验证码是：【%s】。请不要把验证码泄露给其他人。如非本人操作，可不用理会！'
SMS_XMLNS = 'http://106.ihuyi.com/'
SMS_EXPIRES = 180   #180s


#BILLING_MQ_HOST = 'localhost'
#BILLING_MQ_PORT = 6379
#BILLING_MQ_CHANNEL = 'billing'

TASK_MQ_HOST = 'localhost'
TASK_MQ_PORT = 6379
TASK_MQ_CHANNEL = 'wangcai:task'

AES_KEY = 'cd421509726b38a2ffd2997caed6dab9'

