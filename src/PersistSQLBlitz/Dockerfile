FROM bmcclure89/fc_powershell:main

RUN echo 'cd /src;     Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted; Install-Module dbatools' >> /opt/microsoft/powershell/7-lts/profile.ps1
COPY Invoke-PersistSQLBlitz.ps1 /src/Invoke-PersistSQLBlitz.ps1

WORKDIR /src
VOLUME /mnt/prom