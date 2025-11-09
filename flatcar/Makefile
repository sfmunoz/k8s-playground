all: cl.json k3s.json

%.json: %.yaml
	docker run --rm -i quay.io/coreos/butane:latest < $< > $@

clean:
	${RM} *.json

.PHONY: all clean
