#include "HolyMaps.HC"
#include <stdio.h>
#include <stdlib.h>

U0 Require(Bool condition, const char *message)
{
  if (!condition) {
    fprintf(stderr, "map test failed: %s\n", message);
    exit(1);
  }
}

U0 Main()
{
  const HBMMap *map;
  const HBMLayer *layer;
  I64 map_index;
  I64 layer_index;
  I64 row;
  I64 marker;

  Require(HBMMapCount() == 6, "expected two world and four detailed maps");
  Require(HBMLayerCount() == 6, "expected six historical layers");
  Require(HBMFindMap("near_east"), "near east world map missing");
  Require(HBMFindMap("mediterranean"), "Mediterranean world map missing");
  Require(HBMFindMap("bethlehem"), "Bethlehem map missing");
  Require(HBMFindMap("jerusalem"), "Jerusalem map missing");
  Require(HBMFindMap("valley_elah"), "Valley of Elah map missing");
  Require(HBMFindMap("exodus_route"), "Exodus route map missing");

  for (map_index = 0; map_index < HBMMapCount(); map_index++) {
    map = HBMMapAt(map_index);
    for (row = 0; row < map->height; row++)
      Require((I64)strlen(map->tiles[row]) == map->width,
              "tile row width does not match map width");
    for (marker = 0; marker < map->marker_count; marker++)
      Require(map->markers[marker].x >= 0 &&
                  map->markers[marker].x < map->width &&
                  map->markers[marker].y >= 0 &&
                  map->markers[marker].y < map->height,
              "base marker is outside map bounds");
  }

  for (layer_index = 0; layer_index < HBMLayerCount(); layer_index++) {
    layer = HBMLayerAt(layer_index);
    map = HBMFindMap(layer->map_id);
    Require(map, "historical layer references unknown map");
    for (marker = 0; marker < layer->marker_count; marker++)
      Require(layer->markers[marker].x >= 0 &&
                  layer->markers[marker].x < map->width &&
                  layer->markers[marker].y >= 0 &&
                  layer->markers[marker].y < map->height,
              "layer marker is outside map bounds");
  }

  Require(HBMFindLayer("exodus_conquest"),
          "Exodus and conquest layer missing");
  Require(HBMFindLayer("united_monarchy"),
          "united monarchy layer missing");
  Require(HBMFindLayer("new_testament"),
          "New Testament layer missing");
  Require(HBMFindMap("exodus_route")->markers[2].certainty ==
              HBM_CERTAINTY_DISPUTED,
          "uncertain Exodus geography must be labeled");

  printf("HolyMaps tests passed: %lld maps, %lld layers\n",
         (long long)HBMMapCount(), (long long)HBMLayerCount());
}

Main;
