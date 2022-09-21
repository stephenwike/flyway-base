# THIS 'FROM bct-flyway-base' IS FOR THIS EXAMPLE ONLY! USE THIS INSTEAD:
#FROM tbctdevops-docker-local-poc.jfrog.io/bct-flyway-base:latest
FROM flyway-base

# This overwrites the default bct-flyway-base CreateDb.sql script
COPY ./test/init-scripts/CreateDb.sql /scripts/SQLServer/CreateDb.sql

# This add the test action scripts that can now be called by the docker entry-point run script.
COPY ./test/test-scripts /scripts

# This adds the version controlled migrations scripts flyway uses the update the database to the latest version.
COPY ./test/migration-scripts /flyway/sql

# Permissions open for build pipeline
USER root
RUN chmod 777 -R /scripts 
