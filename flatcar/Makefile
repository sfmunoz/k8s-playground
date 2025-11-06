all: ignition.json

ignition.json: cl.yaml
	docker run --rm -i quay.io/coreos/butane:latest < cl.yaml > ignition.json

clean:
	${RM} ignition.json

.PHONY: all
