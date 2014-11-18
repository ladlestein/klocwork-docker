USER := ladlestein

all-in-one:
	@cd all-in-one && docker build -t $(USER)/kw-all-in-one .

analysis-slave: 
	@cd analysis-slave && docker build -t $(USER)/kw-analysis-slave .

startall:
	docker run --name="kw1" -p 3030:8080 $(USER)/kw-all-in-one

.PHONY: all-in-one analysis-slave startall
