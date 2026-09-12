# HolyC Biblical Maps

HolyC Biblical Maps is a reusable 16-color map pack for games built with
[HolyC Linux](https://github.com/Bak-Lab/holyc-linux) and
[HolyC Game Engine](https://github.com/Bak-Lab/holyc-game-engine).

The maps combine compact gameplay tile grids with pixel-art conversions of
public-domain cartography, structured markers, scripture references, period
metadata, and explicit certainty labels. They are intended for games and
educational exploration rather than modern navigation or archaeological
analysis.

The viewer targets the full TempleOS-style 640×480 display. Regional maps use
public-domain Natural Earth geography, while detailed maps use plates from
Jesse Lyman Hurlbut's public-domain 1910 *Bible Atlas*. Each source is cropped
and reduced directly to the TempleOS 16-color palette at 640×360.
`HBMDrawMap` is the canonical one-pixel-resolution renderer; its `tile_size`
argument is retained for source compatibility but ignored.
The 30×18 grids remain available as lightweight gameplay and collision data;
they are no longer enlarged into visible 20×20 blocks.

## Included maps

### World-scale maps

- Biblical Near East, from Egypt through Canaan to Mesopotamia
- Eastern Mediterranean and Roman world

### Historical layers

- Patriarchs
- Exodus and conquest
- United monarchy
- Divided kingdoms
- Exile and return
- New Testament and Roman world

### Detailed maps

- Bethlehem
- Jerusalem
- Valley of Elah
- Egypt and the Exodus route

## Data model

`include/HolyMaps.HC` provides:

- `HBMMap` tile maps
- `HBMMarker` cities, regions, landmarks, and routes
- `HBMLayer` period-specific overlays
- `HBMDrawMap` canonical 640×360 one-pixel-resolution renderer
- Run-length encoded, dependency-free 16-color raster assets
- Attested, approximate, traditional, and disputed certainty levels
- Lookup and iteration functions
- A framebuffer renderer using the standard 16-color palette

```c
#include "HolyMaps.HC"

const HBMMap *world = HBMFindMap("near_east");
const HBMLayer *period = HBMFindLayer("united_monarchy");

HBMDrawMap(dc, world, period, 0, 0, 1);
```

## Build the viewer

Clone the repositories beside one another:

```sh
git clone https://github.com/Bak-Lab/holyc-linux.git
git clone https://github.com/Bak-Lab/holyc-game-engine.git
git clone https://github.com/Bak-Lab/holyc-biblical-maps.git
cd holyc-linux
make compiler
cd ../holyc-biblical-maps
make
make run
```

Use arrow keys, WASD, a D-pad, or the left analog stick to switch maps and
historical layers. Escape, B / Circle, or Back exits.

The map pack requires HolyC Linux commit `7226999` or newer and HolyC Game
Engine commit `325910c` or newer.

## Regenerate the map assets

The generated maps and their run-length encoded HolyC data are committed, so
normal builds do not download anything. To reproduce them from the original
public-domain sources, install ImageMagick, Poppler, curl, unzip, and a C17
compiler, then run:

```sh
make raster-assets
```

The script verifies both source archives against pinned SHA-256 checksums
before creating the six PNG previews and `include/HolyMapsRasterData.HC`.

## Historical scope

These are intentionally schematic game maps. Coastlines, distances, city
footprints, roads, and political boundaries are detailed for a 640×480 game
display but are not survey-grade geography. A marker's certainty field
distinguishes:

- **Attested** locations with strong textual and geographic identification
- **Approximate** placement simplified for the map scale
- **Traditional** sites based on longstanding identification
- **Disputed** locations or routes without scholarly consensus

The Exodus route and Mount Sinai location are explicitly marked disputed.
The project does not claim that one proposed route is historically certain.

See [`assets/README.md`](assets/README.md) for source URLs, checksums, atlas
pages, rights status, and reproduction instructions.

## License

MIT
