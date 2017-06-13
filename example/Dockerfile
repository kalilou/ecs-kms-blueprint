FROM openjdk:alpine

ENV BUCKET_NAME 'tingcore-central-docker-secrets'
ENV BUCKET_KEY 'config-server'
ENV KMS_KEY_ALIAS 'Docker'


# YOUR BLOCK 

RUN apk --no-cache add curl unzip ruby ruby-dev ruby-rdoc ruby-irb
RUN gem install --force rdoc aws-sdk

COPY decrypt-var.sh /decrypt-var.sh
COPY export.sh /export.sh

RUN chmod +x /decrypt-var.sh && \
    chmod +x /export.sh && \ 


CMD ["/export.sh", "your_startup_script"]