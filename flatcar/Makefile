define butane_to_ignition
	docker run --rm -i quay.io/coreos/butane:latest < $< > $@
endef

define butane_to_ignition_dec
	sops decrypt --input-type yaml --output-type yaml $< | docker run --rm -i quay.io/coreos/butane:latest > $@
endef

all: cl.json k3s.json

%.json: %.enc.yaml
	$(butane_to_ignition_dec)

%.ign: %.enc.bu
	$(butane_to_ignition_dec)

%.json: %.yaml
	$(butane_to_ignition)

%.ign: %.bu
	$(butane_to_ignition)

clean:
	${RM} *.json *.ign

.PHONY: all clean
