FROM alpine:3.19

RUN apk add --no-cache curl unzip ca-certificates sed && \
    XRAY_VERSION=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases/latest \
      | grep '"tag_name"' | head -1 | cut -d'"' -f4) && \
    curl -L "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-64.zip" \
      -o /tmp/xray.zip && \
    unzip /tmp/xray.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm /tmp/xray.zip && \
    apk del unzip curl

COPY config.json /etc/xray/config.template.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV PORT=8080

EXPOSE 8080

CMD ["/entrypoint.sh"]
