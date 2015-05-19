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

analysis-slave:
	@cd analysis-slave && docker build -t $(USER)/kw-analysis-slave .

projects_root:
	@cd projects_root && docker build -t $(USER)/projects_root .

start-data:
	docker rm -f jenkins_data
	docker run -d --name jenkins-data $(USER)/jenkins-data echo Data-only container for Jenkins

start-jenkins-server:
	-docker rm -f master
	weave run 192.168.10.10/24 -h master.weave.local --name master \
		-d -p 50000:50000 -p 3010:8080 \
		--volumes-from jenkins-data \
		--add-host kw1.weave.local:192.168.10.11 \
		--add-host kw1:192.168.10.11 \
		$(USER)/jenkins-server

# --hostname specified because the KW server reports the license server hostname back to kwadmin, and the internal
# hostname of the server isn't known by the outside world.
start-kw:
	-docker rm -f kw1
	weave run 192.168.10.11/24 -h kw1.weave.local --name kw1 \
		-p 3030:8080 -p 49000:22 -p 27000:27000 \
		--volumes-from=projects_root \
		$(USER)/kw-all-in-one

start-slave:
	-docker rm -f slave
	weave run 192.168.10.12/24 -h slave.weave.local --name slave \
		-p 22 \
		--add-host master.weave.local:192.168.10.10 \
		--add-host master:192.168.10.10 \
		--add-host kw1.weave.local:192.168.10.11 \
		--add-host kw1:192.168.10.11 \
		$(USER)/kw-analysis-slave

start-seeker:
	-docker rm -f seeker
	weave run 192.168.10.13/24 -h seeker.weave.local --name seeker \
		-p 22 \
		--add-host master.weave.local:192.168.10.10 \
		--add-host master:192.168.10.10 \
		--add-host kw1.weave.local:192.168.10.11 \
		--add-host kw1:192.168.10.11 \
		-e KWSEEKER_JENKINS_HOST=master.weave.local \
		-e KWSEEKER_JENKINS_PORT=8080 \
		-e KWSEEKER_KW_USERNAME=klocwork \
		-e KWSEEKER_KW_HOST="kw1.weave.local" \
		-e KWSEEKER_GITHUB_REPO="joyent/node" \
		-e KWSEEKER_KW_PROJECT_NAME="node.js" \
		-e KWSEEKER_BUILD_COMMAND="make" \
		-e KWSEEKER_PREBUILD_COMMAND="./configure" \
		$(USER)/kw-seeker

start-projects_root:
	docker rm -f projects_root
	docker run -d --name projects_root $(USER)/projects_root echo Data-only container for Klocwork projects_root

.PHONY: all-in-one analysis-slave projects_root jenkins-data jenkins-server jenkins-slave
#		--link master:master --link kw1:kw1 \
