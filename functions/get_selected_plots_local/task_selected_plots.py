import re
import os
import json
import math
import urllib.request
import sys
import datetime
import logging

from google.cloud import firestore


logger = logging.getLogger(__name__)

logging.basicConfig(stream=sys.stdout, level=logging.INFO,
    format="'%(asctime)s - %(name)s - %(levelname)s - %(message)s'")


GCP_FIRESTORE_SECRETS_PATH = os.getenv("GCP_FIRESTORE_SECRETS_PATH",
    '/Users/xszpo/GoogleDrive/01_Projects/202003_xFlats_K8S/secrets/gcpfirestore_key.json')

TELEGRAM_KEY_PATH = os.getenv("TELEGRAM_KEY_PATH",
    '/Users/xszpo/GoogleDrive/01_Projects/202003_xFlats_K8S/secrets/telegram_key.json')


if __name__ == '__main__':

    db = firestore.Client.from_service_account_json(GCP_FIRESTORE_SECRETS_PATH)

    with open(TELEGRAM_KEY_PATH, 'r') as file:
        bot_key = json.load(file)

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
