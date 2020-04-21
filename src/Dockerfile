FROM python:3.8-slim
RUN pip install -U paramiko pyyaml
RUN apt update && apt install --no-install-recommends cron  -y
COPY . /app
WORKDIR /app
RUN touch /var/log/cron.log
CMD bash /app/run.sh && cron && tail -f /var/log/cron.log

