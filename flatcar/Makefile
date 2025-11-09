define bu_to_ign
	docker run --rm -i quay.io/coreos/butane:latest < $< > $@
endef

define bu_to_ign_dec
	sops decrypt --input-type yaml --output-type yaml $< | docker run --rm -i quay.io/coreos/butane:latest > $@
endef

all: cl.json k3s.json

%.json: %.enc.yaml
	$(bu_to_ign_dec)

%.ign: %.enc.bu
	$(bu_to_ign_dec)

%.json: %.yaml
	$(bu_to_ign)

%.ign: %.bu
	$(bu_to_ign)

clean:
	${RM} *.json *.ign

.PHONY: all clean
