# -*- coding: utf-8 -*-

import MySQLdb
import logging
from config import *
from data_types import *

logger = logging.getLogger('db_helper')

conn = MySQLdb.connect(host=MYSQL_HOST, user=MYSQL_USER, passwd=MYSQL_PASSWD, db=MYSQL_DB, charset='utf8')

def select_app_task():
    stmt = "SELECT * FROM task_base WHERE type = %d" %TaskType.T_APP
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        list = []
        for each in cur.fetchall():
            task = Task()
            task.id     = int(each['id'])
            task.type   = int(each['type'])
            task.status = int(each['status'])
            task.title  = each['title']
            task.icon   = each['icon']
            task.intro  = each['intro']
            task.desc   = each['descr']
            task.steps  = each['steps'].split('|')
            task.money  = each['money']
            list.append(task)
        return list


def select_builtin_task():
    stmt = "SELECT * FROM task_base WHERE type <= %d" %TaskType.T_BUILTIN
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        list = []
        for each in cur.fetchall():
            task = Task()
            task.id     = int(each['id'])
            task.type   = int(each['type'])
            task.status = int(each['status'])
            task.title  = each['title']
            task.icon   = each['icon']
            task.intro  = each['intro']
            task.desc   = each['descr']
            task.steps  = each['steps'].split('|')
            task.money  = each['money']
            list.append(task)
        return list


def select_task_of_device(device_id):
    stmt = "SELECT * FROM task_of_device WHERE device_id = '%s'" %MySQLdb.escape_string(device_id)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        list = []
        for each in cur.fetchall():
            task = TaskOfDevice()
            task.device_id = device_id
            task.task_id = int(each['task_id'])
            task.type = int(each['type'])
            task.status = int(each['status'])
            task.money = int(each['money'])
            list.append(task)
        return list

def select_task_of_user(userid):
    stmt = "SELECT * FROM task_of_user WHERE userid = %d" %userid
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return []
    else:
        list = []
        for each in cur.fetchall():
            task = TaskOfUser()
            task.userid = userid
            task.device_id = each['device_id']
            task.task_id = int(each['task_id'])
            task.type = int(each['type'])
            task.status = int(each['status'])
            task.money = int(each['money'])
            list.append(task)
        return list

def query_task_status_of_device(device_id, task_id):
    stmt = "SELECT status FROM task_of_device \
                WHERE device_id = '%s' AND task_id = %d" \
                %(MySQLdb.escape_string(device_id), task_id)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    if n == 0:
        return TaskStatus.S_NORMAL
    else:
        res = cur.fetchone()
        return int(res[0])


def insert_task_of_device(task):
    stmt = "INSERT IGNORE INTO task_of_device \
                SET userid = %d, device_id = '%s', task_id = %d, \
                type = %d, status = %d, money = %d" \
                % (task.userid,
                        MySQLdb.escape_string(task.device_id),
                        task.task_id,
                        task.type,
                        task.status,
                        task.money)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def insert_task_of_user(task):
    stmt = "INSERT IGNORE INTO task_of_user \
                SET device_id = '%s', task_id = %d, \
                type = %d, status = %d, money = %d" \
                % (MySQLdb.escape_string(task.device_id),
                        task.task_id,
                        task.type,
                        task.status,
                        task.money)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def insert_task_invite(task):
    stmt = "INSERT IGNORE INTO task_invite \
                SET userid = %d, invitee = %d, invite_code = '%s'" \
                %(task.userid, task.invitee, MySQLdb.escape_string(task.invite_code))
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def count_task_invite(userid):
    stmt = "SELECT COUNT(*) FROM task_invite WHERE userid = %d" %userid
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    res = cur.fetchone()
    return int(res[0])




