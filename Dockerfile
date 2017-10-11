FROM jenkins
LABEL maintainer="Michel Behlok"
USER jenkins:jenkins
RUN cd /var/jenkins_home/
RUN curl "https://sdk.cloud.google.com" >> installer.sh
RUN chmod +x installer.sh
RUN ./installer.sh --disable-prompts
USER root:root
RUN ln -s /var/jenkins_home/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
RUN ln -s /var/jenkins_home/google-cloud-sdk/bin/gsutil /usr/local/bin/gsutil
RUN chown -R jenkins /usr/share/jenkins
RUN groupadd docker \
    && usermod -aG docker,staff jenkins
USER jenkins
