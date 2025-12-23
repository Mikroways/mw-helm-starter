CT_EXISTS := $(shell command -v ct 2> /dev/null)


.PHONY: test

test: clean
	helm create -p $(PWD)/single-container test/single
	helm create -p $(PWD)/multiple-containers test/multiple
ifeq ($(CT_EXISTS),)
	@echo "--- Using ct inside docker ---"
	docker run -it --workdir=/data --volume $(PWD):/data quay.io/helmpack/chart-testing:v3.14.0 ct lint --all --config ct.yaml
else
	@echo "--- 'Using ct binary ---"
	ct lint --all --config ct.yaml
endif

clean:
	rm -fr test/
