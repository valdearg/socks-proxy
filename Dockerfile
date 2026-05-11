FROM alpine:3.20

RUN apk add --no-cache autossh openssh-client bash

COPY ssh-entrypoint.sh /usr/local/bin/ssh-entrypoint.sh
RUN chmod +x /usr/local/bin/ssh-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/ssh-entrypoint.sh"]