USER := ladlestein

all-in-one:
	@cd all-in-one && docker build -t $(USER)/kw-all-in-one .

projects_root:
	@cd projects_root && docker build -t $(USER)/projects_root .

analysis-slave:
	@cd analysis-slave && docker build -t $(USER)/kw-analysis-slave .

# --hostname specified because the KW server reports the license server hostname back to kwadmin, and the internal
# hostname of the server isn't known by the outside world.
start-kw:
	docker run --name="kw1" --hostname="kw1" -p 3030:8080 -p 49000:22 -p 27000:27000 --volumes-from=projects_root $(USER)/kw-all-in-one

start-slave:
	docker run --name "slave" --link master:master --link kw1:kw1 $(USER)/kw-analysis-slave

start-projects_root:
	docker run -d --name projects_root $(USER)/projects_root echo Data-only container for Klocwork projects_root

.PHONY: all-in-one analysis-slave projects_root
