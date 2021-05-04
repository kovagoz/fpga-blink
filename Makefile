docker_img := kovagoz/icestorm
docker_run := docker run --rm -it -v $(PWD):/host -w /host
docker_cmd := $(docker_run) $(docker_img)

blink.bin: blink.asc
	$(docker_cmd) icepack blink.asc blink.bin

blink.asc: blink.json constraints.pcf
	$(docker_cmd) nextpnr-ice40 --hx1k --package vq100 --json blink.json --pcf constraints.pcf --asc $@

blink.json: blink.v
	$(docker_cmd) yosys -p 'synth_ice40 -top main -json $@' blink.v

constraints.pcf:
	curl https://www.nandland.com/goboard/Go_Board_Constraints.pcf > $@

.PHONY: install
install:
	$(docker_run) --device /dev/ttyUSB1 --privileged --user 0 $(docker_img) iceprog blink.bin

.PHONY: clean
clean:
	rm -f blink.json blink.asc blink.bin

.PHONY: shell
shell:
	$(docker_cmd) /bin/sh
