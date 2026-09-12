HOLYC_ROOT ?= ../holyc-linux
HOLYGAME_ROOT ?= ../holyc-game-engine
HOLYC := $(HOLYC_ROOT)/.holyc-build/bin/holyc
INCLUDES := -I include -I $(HOLYGAME_ROOT)/include
VIEWER := build/map-viewer

.PHONY: all run test clean raster-assets

all: $(VIEWER)

$(HOLYC):
	$(MAKE) -C $(HOLYC_ROOT) compiler

MAP_HEADERS := include/HolyMaps.HC include/HolyMapsDetail.HC \
	include/HolyMapsRasterData.HC

$(VIEWER): examples/MapViewer.HC $(MAP_HEADERS) $(HOLYC)
	mkdir -p build
	$(HOLYC) $< $(INCLUDES) -o $@

build/map-test: tests/MapTest.HC $(MAP_HEADERS) $(HOLYC)
	mkdir -p build
	$(HOLYC) $< $(INCLUDES) -o $@

run: $(VIEWER)
	./$(VIEWER)

test: build/map-test $(VIEWER)
	./build/map-test
	SDL_VIDEODRIVER=dummy HOLY_MAPS_AUTOPLAY=1 ./$(VIEWER)

clean:
	rm -rf build

raster-assets:
	./tools/rasterize_maps.sh
