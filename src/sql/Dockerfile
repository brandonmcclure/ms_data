ARG IMAGE=mcr.microsoft.com/mssql/server:2022-CU10-ubuntu-22.04
FROM $IMAGE
USER 0:0
ARG CD_SA_PASSWORD=We@kP@ssword

LABEL maintainer="brandonmcclure89@gmail.com" Description="A base SQL Server image" 

 # Install Unzip
RUN apt-get update \
    && apt-get install unzip -y
# Install SQLPackage for Linux and make it executable
RUN wget -progress=bar:force -q -O sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2134311 \
    && unzip -qq sqlpackage.zip -d /opt/sqlpackage \
    && chmod +x /opt/sqlpackage/sqlpackage

# pwsh
RUN apt-get install -y wget apt-transport-https \
&& . /etc/os-release \
$$ echo $VERSION_ID \
&& wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb \
&& dpkg -i packages-microsoft-prod.deb \
&& apt-get update \
&& apt-get install -y powershell

# create directory within SQL container for database files
RUN /bin/mkdir -p /var/opt/mssql/backup \
&& /bin/mkdir -p /var/opt/mssql/dbfiles

RUN wget -P /usr/bin/ https://raw.githubusercontent.com/brandonmcclure/SQL-Server-First-Responder-Kit/abaea1c3479db6d899ade4ea5199e868d26a2208/Install-All-Scripts.sql
RUN wget -P /usr/bin/ https://raw.githubusercontent.com/olahallengren/sql-server-maintenance-solution/499c42bec571f5e214a64c01a4cb5c012bf3a6e8/MaintenanceSolution.sql

USER 10001:0

COPY --chown=10001:0 entrypoint.sh /usr/bin
COPY --chown=10001:0 init.sh /usr/bin
COPY --chown=10001:0 CreateDBs.sql /usr/bin

ENV MSSQL_SA_PASSWORD=$CD_SA_PASSWORD
ENV ACCEPT_EULA=TRUE
 
 EXPOSE 1433
HEALTHCHECK --interval=10s --timeout=3s --start-period=10s --retries=10 \
   CMD /opt/mssql-tools/bin/sqlcmd -S localhost -d master -V16 -U sa -P $MSSQL_SA_PASSWORD -Q "SELECT 1" || exit 1


CMD /bin/bash /usr/bin/entrypoint.sh