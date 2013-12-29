
import web 
import json
import logging
import memcache
from config import *
from utils import *

class Handler:
    def POST(self):
        logger = logging.getLogger('root')
        params = web.input()
        data = {
            'idfa': params.idfa.lower(), 
            'mac': params.mac.lower(), 
#            'phone': params.phone,
            'platform': web.cookies().get('p')
        }

        url = 'http://' + ACCOUNT_BACKEND + '/register'

        r = http_request(url, data)
        if r.has_key('rtn') and r['rtn'] == 0:
            session_id = generate_session_id()
            resp = {
                'res': 0,
                'msg': '',
                'session_id': session_id,
                'device_id': r['device_id'],
                'invite_code': r['invite_code'],
                'userid': r['userid'],
                'inviter': r['inviter'],
                'phone': ''
            }
        else:
            resp = {
                'res': 1,
                'msg': 'error',
            }

        return json.dumps(resp)

