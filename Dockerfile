FROM jenkins
LABEL maintainer="Michel Behlok"
USER root:root
RUN chown -R jenkins /usr/share/jenkins
RUN curl "https://sdk.cloud.google.com" >> installer.sh
RUN chmod +x installer.sh
RUN ./installer.sh --disable-prompts
RUN apt-get update && apt-get install -y php php7.0-mbstring php7.0-zip php7.0-xml php-curl docker libltdl7
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir=bin --filename=composer
RUN php -r "unlink('composer-setup.php');"
RUN cd /etc && rm localtime && ln -s /usr/share/zoneinfo/America/Bogota localtime
RUN ln -s /var/jenkins_home/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
RUN ln -s /var/jenkins_home/google-cloud-sdk/bin/gsutil /usr/local/bin/gsutil
RUN groupadd docker \
    && usermod -aG docker,staff jenkins
USER jenkins
