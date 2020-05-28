import os
import luigi
import luigi.contrib.gcs
from helpers.luigi import *


class UploadJsonlines(UploadJsonlines):

    filepatterns = luigi.ListParameter(
        default=['flats_all_{date:%Y%m%d}.jsonline',
                 'flats_otodom_{date:%Y%m%d}.jsonline',
                 'flats_olx_{date:%Y%m%d}.jsonline',
                 'flats_gratka_{date:%Y%m%d}.jsonline',
                 'flats_morizon_{date:%Y%m%d}.jsonline'])


if __name__ == '__main__':
    luigi.build([UploadJsonlines(
        daysback=int(os.getenv('LUIGI_DAYSBACK', 12)),
        bucket=os.getenv('LUIGI_BUCKET', "gs://flats_jsonlines"),
        localdir=os.getenv('LUIGI_LOCALDIR', "/app/data/"))],
            local_scheduler=True)
