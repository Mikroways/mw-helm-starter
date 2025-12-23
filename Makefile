.PHONY: test

test: clean
	helm create -p $(PWD)/single-container test/single
	helm create -p $(PWD)/multiple-containers test/multiple
	docker run -it --workdir=/data --volume $(PWD):/data quay.io/helmpack/chart-testing:v3.14.0 ct lint --all --config ct.yaml

clean:
	rm -fr test/
