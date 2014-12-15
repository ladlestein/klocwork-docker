USER := ladlestein

STARTCMD?=weave

jenkins-data:
	@cd jenkins-data && docker build -t $(USER)/jenkins-data .

jenkins-server:
	@cd jenkins-server && docker build -t $(USER)/jenkins-server .

jenkins-slave:
	@cd jenkins-slave && docker build -t $(USER)/jenkins-slave .

all-in-one:
	@cd all-in-one && docker build -t $(USER)/kw-all-in-one .

projects_root:
	@cd projects_root && docker build -t $(USER)/projects_root .

analysis-slave:
	@cd analysis-slave && docker build -t $(USER)/kw-analysis-slave .

start-data:
	docker run -d --name jenkins-data $(USER)/jenkins-data echo Data-only container for Jenkins

start-jenkins-server:
	weave run 192.168.10.10/24 -h master.weave.local --name master \
		-d -p 50000:50000 -p 3010:8080 \
		--volumes-from jenkins-data \
		--add-host kw1.weave.local:192.168.10.11 \
		--add-host kw1:192.168.10.11 \
		$(USER)/jenkins-server

# --hostname specified because the KW server reports the license server hostname back to kwadmin, and the internal
# hostname of the server isn't known by the outside world.
start-kw:
	weave run 192.168.10.11/24 -h kw1.weave.local --name kw1 \
		-p 3030:8080 -p 49000:22 -p 27000:27000 \
		--volumes-from=projects_root \
		$(USER)/kw-all-in-one

start-slave:
	weave run 192.168.10.12/24 -h slave.weave.local --name slave \
		-p 22 \
		--add-host master.weave.local:192.168.10.10 \
		--add-host master:192.168.10.10 \
		--add-host kw1.weave.local:192.168.10.11 \
		--add-host kw1:192.168.10.11 \
		$(USER)/kw-analysis-slave

start-seeker:
	weave run 192.168.10.13/24 -h seeker.weave.local --name seeker \
		-p 22 \
		--add-host master.weave.local:192.168.10.10 \
		--add-host master:192.168.10.10 \
		--add-host kw1.weave.local:192.168.10.11 \
		--add-host kw1:192.168.10.11 \
		-e KWSEEKER_JENKINS_SERVER_IP=master.weave.local \
		-e KWSEEKER_JENKINS_SERVER_PORT=8080 \
		-e KWSEEKER_KLOCWORK_USERNAME=klocwork \
		-e KWSEEKER_KLOCWORK_API_ENDPOINT="http://kw1.weave.local:8080/review/api" \
-i -t		$(USER)/kw-seeker /bin/bash

start-projects_root:
	docker run -d --name projects_root $(USER)/projects_root echo Data-only container for Klocwork projects_root

.PHONY: all-in-one analysis-slave projects_root jenkins-data jenkins-server jenkins-slave
#		--link master:master --link kw1:kw1 \
