# HolyC Biblical Maps

HolyC Biblical Maps is a reusable 16-color map pack for games built with
[HolyC Linux](https://github.com/Bak-Lab/holyc-linux) and
[HolyC Game Engine](https://github.com/Bak-Lab/holyc-game-engine).

The maps combine compact gameplay tile grids with full-resolution vector
geometry, structured markers, scripture references, period metadata, and
explicit certainty labels. They are intended for games and educational
exploration rather than modern navigation or archaeological analysis.

The viewer targets the full TempleOS-style 640×480 display. Maps are
rasterized from normalized coastlines, terrain regions, rivers, roads,
buildings, walls, islands, and routes directly into a 600×360 viewport.
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
- `HBMDrawDetailedMap` full-resolution vector map renderer
- Attested, approximate, traditional, and disputed certainty levels
- Lookup and iteration functions
- A framebuffer renderer using the standard 16-color palette

```c
#include "HolyMapsDetail.HC"

const HBMMap *world = HBMFindMap("near_east");
const HBMLayer *period = HBMFindLayer("united_monarchy");

HBMDrawDetailedMap(dc, world, period, 20, 60, 600, 360);
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

No third-party map tiles or copyrighted cartography are included.

## License

MIT
