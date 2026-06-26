.PHONY: help up down deploy convert validate attack clean

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

up: ## create the kind cluster
	./scripts/setup.sh

down: ## delete the cluster
	./scripts/teardown.sh

deploy: ## install falco + falcosidekick + sample workload
	@echo "TODO: helm install falco, falcosidekick, then apply cluster/workload"

convert: ## sigma -> falco rules
	./pipeline/convert.sh

validate: ## run attack sims, assert each rule fired
	./pipeline/validate.sh

attack: ## point the offensive driver at the sample workload
	@echo "TODO: run an atomic test or vectorforge against sample-workload"

clean: down ## tear down and remove generated artifacts
	rm -rf detections/falco/generated
