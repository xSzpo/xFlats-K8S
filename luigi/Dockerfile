#docker build -t xszpo/flats_luigi:0.0.2 .
#docker push xszpo/flats_luigi:0.0.2

FROM spotify/luigi:2.7.2

LABEL mainteriner=daniel.szponar@gmail.com

EXPOSE 8082

ENV GOOGLE_APPLICATION_CREDENTIALS "/etc/gcs/gcs_key.json"
ENV PYTHONPATH /app
ENV TZ=Europe/Warsaw
ENV LANG=C.UTF-8
ENV PYTHON_VERSION=3.6.4

# ENV moved to manifest
ENV LUIGI_DAYSBACK=12
ENV LUIGI_BUCKET=gs://flats_jsonlines
ENV LUIGI_LOCALDIR=/app/data/

COPY . /app

RUN mkdir -p /app/data/logs \
    && pip install --upgrade pip \
    && pip install --trusted-host pypi.python.org -r /app/requirements.txt
# Run the cron every hour

RUN echo "30  *  *  *  *  python /app/tasks_flats.py" | crontab -
RUN echo "35  *  *  *  *  python /app/tasks_plots.py" | crontab -

# mask previouse entrypoint
CMD ["/bin/sh"]

# run script in crontab in foreground
ENTRYPOINT crond -f -d 6 -c /etc/crontabs
