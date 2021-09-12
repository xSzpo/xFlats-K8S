#docker build -t xszpo/flat_scraper:1.0.21 .
#docker push xszpo/flat_scraper:1.0.21

FROM python:3.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --upgrade pip && pip install --trusted-host pypi.python.org -r requirements.txt

# run
ENTRYPOINT ["python", "-u","/app/app.py"]
