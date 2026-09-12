HOLYC_ROOT ?= ../holyc-linux
HOLYGAME_ROOT ?= ../holyc-game-engine
HOLYC := $(HOLYC_ROOT)/.holyc-build/bin/holyc
INCLUDES := -I include -I $(HOLYGAME_ROOT)/include
VIEWER := build/map-viewer

.PHONY: all run test clean

all: $(VIEWER)

$(HOLYC):
	$(MAKE) -C $(HOLYC_ROOT) compiler

$(VIEWER): examples/MapViewer.HC include/HolyMaps.HC $(HOLYC)
	mkdir -p build
	$(HOLYC) $< $(INCLUDES) -o $@

build/map-test: tests/MapTest.HC include/HolyMaps.HC $(HOLYC)
	mkdir -p build
	$(HOLYC) $< $(INCLUDES) -o $@

run: $(VIEWER)
	./$(VIEWER)

test: build/map-test $(VIEWER)
	./build/map-test
	SDL_VIDEODRIVER=dummy HOLY_MAPS_AUTOPLAY=1 ./$(VIEWER)

clean:
	rm -rf build
