top_module ?= blink

docker_img := kovagoz/icestorm
docker_run := docker run --rm -it -v $(PWD):/host -w /host
docker_cmd := $(docker_run) $(docker_img)

.PHONY: build
build: $(top_module).bin

$(top_module).bin: $(top_module).asc
	$(docker_cmd) icepack $(top_module).asc $(top_module).bin

$(top_module).asc: $(top_module).json constraints.pcf
	$(docker_cmd) nextpnr-ice40 --hx1k --package vq100 --json $(top_module).json --pcf constraints.pcf --asc $@

$(top_module).json: $(top_module).v
	$(docker_cmd) yosys -p 'synth_ice40 -top $(top_module) -json $@' $(top_module).v

constraints.pcf:
	curl https://www.nandland.com/goboard/Go_Board_Constraints.pcf > $@

.PHONY: install
install:
	$(docker_run) --device /dev/ttyUSB1 --privileged --user 0 $(docker_img) iceprog $(top_module).bin

.PHONY: clean
clean:
	rm -f $(top_module).json $(top_module).asc $(top_module).bin $(top_module).vcd $(top_module).vvp

.PHONY: test
test: $(top_module)_tb.vcd

$(top_module)_tb.vcd: $(top_module)_tb.vvp
	$(docker_run) --entrypoint vvp kovagoz/iverilog:0.5.0 $<

$(top_module)_tb.vvp: $(top_module)_tb.v
	$(docker_run) kovagoz/iverilog:0.5.0 -o $@ $<

.PHONY: shell
shell:
	$(docker_cmd) /bin/sh
