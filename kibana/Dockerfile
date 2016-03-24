FROM kibana:latest

RUN apt-get update

COPY wait-for-it.sh /tmp/wait-for-it.sh
RUN chmod +x /tmp/wait-for-it.sh

RUN kibana plugin --install elastic/sense
