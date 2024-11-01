# FROM python:3.12.0b3-alpine3.18
# COPY . /application
# WORKDIR /application
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt
# EXPOSE 5000
# CMD ["python", "app.py"]
FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get update && apt-get install -y curl
RUN echo "hello world" | grep "world" | wc -l
CMD ["echo", "Hello, world!"]
