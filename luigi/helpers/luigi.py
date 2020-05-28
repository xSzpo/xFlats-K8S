import luigi
import luigi.contrib.gcs
import os
import datetime
import time

# PYTHONPATH='.' python tasks.py --local-scheduler HelloWorld


class Copy2GCS(luigi.Task):

    filename = luigi.Parameter(default="test.txt")
    source_dir = luigi.Parameter(default=".")
    bucket = luigi.Parameter(default="gs://flats_jsonlines")

    def requires(self):
        return None

    def output(self):
        return luigi.contrib.gcs.GCSTarget(
            os.path.join(self.bucket, self.filename))

    def run(self):
        client = luigi.contrib.gcs.GCSClient()
        client.put(os.path.join(self.source_dir, self.filename),
                   self.output().path)
        self.done = True


class UploadJsonlines(luigi.Task):

    date = luigi.DateSecondParameter(default=datetime.datetime.now())
    daysback = luigi.parameter.IntParameter(default=7)
    bucket = luigi.Parameter(default="gs://flats_jsonlines")
    localdir = luigi.Parameter(default="/app/data/")
    filepatterns = luigi.ListParameter(
        default=['flats_all_{date:%Y%m%d}.jsonline',
                 'flats_otodom_{date:%Y%m%d}.jsonline',
                 'flats_olx_{date:%Y%m%d}.jsonline',
                 'flats_gratka_{date:%Y%m%d}.jsonline',
                 'flats_morizon_{date:%Y%m%d}.jsonline'])

    @staticmethod
    def dateminusday(days):
        return datetime.date.today()-datetime.timedelta(days=days)

    def generate_filenames(self):
        filenames = list()
        # skip today - file is still in use
        days = [self.dateminusday(i) for i in range(1, self.daysback+1)]
        for pattern in self.filepatterns:
            for day in days:
                filenames += [pattern.format(date=day)]
        return filenames

    def select_if_exists(self, filenames):

        exists = list()
        for file in filenames:
            if os.path.exists(os.path.join(self.localdir, file)):
                exists += [file]
        return exists

    def requires(self):
        client = luigi.contrib.gcs.GCSClient()
        bucket_list = client.listdir(self.bucket)
        filenames = self.select_if_exists(self.generate_filenames())

        return [Copy2GCS(filename=file, source_dir=self.localdir,
                         bucket=self.bucket) for file in filenames]

    def output(self):
        return luigi.LocalTarget(
            os.path.join(self.localdir,
                'logs/luigi_UploadJsonlines_{date:%Y-%m-%d%H%M}.txt'.format(
                    date=self.date)))

    def run(self):
        with self.output().open('w') as outfile:
            for input in self.input():
                outfile.write('%s %s\n' % (input.path, input.exists()))


class All(luigi.WrapperTask):

    daysback = luigi.parameter.IntParameter(default=7)
    bucket = luigi.Parameter(default="gs://flats_jsonlines")
    localdir = luigi.Parameter(default="/app/data/")

    def requires(self):
        yield UploadJsonlines(daysback=self.daysback, bucket=self.bucket,
                              localdir=self.localdir)
