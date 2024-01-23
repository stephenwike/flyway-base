FROM flyway/flyway:latest

WORKDIR /scripts

USER root

RUN apt-get update && apt-get install  -y \
	locales curl apt-transport-https debconf-utils wget \
    && rm -rf /var/lib/apt/lists/*

# RUN locale-gen en_US.UTF-8
# RUN update-locale LANG=en_US.UTF-8

# Add necessary packages for adding Microsoft keys

RUN apt-get update && apt-get install -y gnupg2 libcurl3

# adding custom MS repository, using wget instead of curl due to libcurl3 vs libcurl4 problem
# mssql-tools need libcurl3
# curl needs libcurl4, and you cannot have both running
RUN wget -q -O microsoft.asc https://packages.microsoft.com/keys/microsoft.asc
RUN apt-key add microsoft.asc
RUN wget -q -O prod.list https://packages.microsoft.com/config/ubuntu/16.04/prod.list 
RUN cat prod.list > /etc/apt/sources.list.d/mssql-release.list

# Add MS-Tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# Add PostgreSQL Client
RUN apt-get update && \
    apt-get install -y postgresql-client

# RUN /opt/mssql-tools/bin/sqlcmd -?
COPY ./src/scripts /scripts
RUN chmod +x /scripts/**.sh

USER flyway
ENTRYPOINT ["/scripts/run.sh"]
