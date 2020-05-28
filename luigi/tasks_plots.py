import os
import luigi
import luigi.contrib.gcs
from helpers.luigi import *


class UploadJsonlines(UploadJsonlines):

    filepatterns = luigi.ListParameter(
        default=['plots_all_{date:%Y%m%d}.jsonline'])


if __name__ == '__main__':
    luigi.build([UploadJsonlines(
        daysback=int(os.getenv('LUIGI_DAYSBACK', 12)),
        bucket=os.getenv('LUIGI_BUCKET_PLOTS', "gs://flats_jsonlines"),
        localdir=os.getenv('LUIGI_LOCALDIR_PLOTS', "/app/data/"))],
            local_scheduler=True)
