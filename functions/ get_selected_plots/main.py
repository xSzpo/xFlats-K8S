import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import re
import os
import json
import math
import urllib.request
import sys
import datetime
import logging

logger = logging.getLogger(__name__)


def main(request):

    request_json = request.get_json()

    if request.args and 'message' in request.args:
        message = request.args.get('message')
        logger.debug(message)

    elif request_json and 'message' in request_json:
        message = request_json['message']
        logger.debug(message)

    # Use the application default credentials
    cred = credentials.ApplicationDefault()
    firebase_admin.initialize_app(cred, {
        'projectId': 'flats-272715'
        })

    db = firestore.client()

    bot_key = {
        "key": "979330766:AAHi_YVpICJ3fSdEVcl_Y2qMYtCtg7scKZQ",
        "chat_id": "-452112783"
    }

    url_ = "https://api.telegram.org/bot{bot_key}/getUpdates". \
        format(bot_key=bot_key['key'])

    with urllib.request.urlopen(url_) as response:
        updates = response.readlines()

    p_id = re.compile(">>(.*)<<")
    p_url = re.compile('(http.+)","entities"')

    ids = list()
    urls = list()

    for i, line in enumerate(updates):
        logger.debug(f"Look for offer #{i}")
        m = p_id.search(line.decode('ascii'))
        if m:
            tmp_id = json.loads(m.group(1).replace("\\", ""))['id']
            if db.collection('plots').document(tmp_id).get(['_id']).exists:
                logger.info(f"Found by id - {tmp_id}")
                ids += [tmp_id]
            else:
                m = p_url.search(line.decode('ascii'))
                if m:
                    tmp_www = m.group(1)
                    docs = db.collection('plots'). \
                        where(u'url', u'==', tmp_www).stream()
                    for doc in docs:
                        logger.info(f"Found by url - {tmp_www}")
                        ids += [doc.id]
        else:
            m = p_url.search(line.decode('ascii'))
            if m:
                tmp_www = m.group(1)
                docs = db.collection('plots').where(u'url', u'==', tmp_www). \
                    stream()
                for doc in docs:
                    logger.info(f"Found by url - {tmp_www}")
                    ids += [doc.id]

    if set(ids):
        for i, id_ in enumerate(set(ids)):
            logger.info(f"Save #{i} - {id_}")
            db.collection(u'selected_plots').document(id_). \
                set({'selected': True,
                     'download_date': datetime.datetime.utcnow()})

    logger.info(f"The end")
