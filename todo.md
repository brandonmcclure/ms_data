setup logins/users and document why I set them up this way. Right now everything is using SA
Setup a more consistent scheduling mechanism for the jobs. Document the tradeoffs between the quick method I just used, and why we want easier to understand and consistent scheduling.
Include a prom exporter to retrieve the persisted Blitz data
Create viz on `System Overview` dashboard showing the Size of the files, waits, batch requests and cpu utilization
Generate random passwords for all SQL Auth.
Add github CI files to build all of the docker images
Document what is needed to deploy to production. Why would it be a bad idea to jump into deploying to production now, and what the roadmap looks like to get there.