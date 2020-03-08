FROM fedora:27
RUN dnf -y install openldap-servers openldap-clients
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker
EXPOSE 389 636
ENTRYPOINT [ "/opt/docker/startup.sh" ]
CMD "start" 
