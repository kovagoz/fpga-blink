docker_img := kovagoz/icestorm
docker_run := docker run --rm -it -v $(PWD):/host -w /host
docker_cmd := $(docker_run) $(docker_img)

.PHONY: build
build: blink.bin

blink.bin: blink.asc
	$(docker_cmd) icepack blink.asc blink.bin

blink.asc: blink.json constraints.pcf
	$(docker_cmd) nextpnr-ice40 --hx1k --package vq100 --json blink.json --pcf constraints.pcf --asc $@

blink.json: blink.v
	$(docker_cmd) yosys -p 'synth_ice40 -top blink -json $@' blink.v

constraints.pcf:
	curl https://www.nandland.com/goboard/Go_Board_Constraints.pcf > $@

.PHONY: install
install:
	$(docker_run) --device /dev/ttyUSB1 --privileged --user 0 $(docker_img) iceprog blink.bin

.PHONY: clean
clean:
	rm -f blink.json blink.asc blink.bin blink_tb.vcd blink_tb.vvp

.PHONY: test
test: blink_tb.vcd

blink_tb.vcd: blink_tb.vvp
	$(docker_run) --entrypoint vvp kovagoz/iverilog:0.5.0 $<

blink_tb.vvp: blink_tb.v
	$(docker_run) kovagoz/iverilog:0.5.0 -o $@ $<

.PHONY: shell
shell:
	$(docker_cmd) /bin/sh
