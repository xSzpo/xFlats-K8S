#docker build -t xszpo/flats_mlflow:0.0.0 .
#docker run -it --rm --expose 5000 -p 5000:5000 -v /Users/xszpo/GoogleDrive/01_Projects/202003_xFlats_K8S/mlflow/:/app python:3.7-slim /bin/bash
#docker run -it --rm -p 5000:5000 -v /Users/xszpo/GoogleDrive/01_Projects/202003_xFlats_K8S/mlflow/model:/app/model xszpo/flats_mlflow:0.0.0 /bin/bash

#continuumio/miniconda3:4.8.2
FROM python:3.7-slim

LABEL mainteriner=daniel.szponar@gmail.com

ENV PYTHONPATH /app
ENV TZ=Europe/Warsaw
ENV LANG=C.UTF-8
ENV PYTHON_VERSION=3.7.7

EXPOSE 8777

COPY . /app
WORKDIR /app

ENV PATH=/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion libgomp1 && \
    apt-get clean

RUN pip install --trusted-host pypi.python.org -r /app/requirements.txt

ENTRYPOINT ["mlflow server -h 0.0.0.0 -p 8777"]
