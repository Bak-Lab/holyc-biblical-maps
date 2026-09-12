#include "HolyGame.HC"
#include "HolyMapsDetail.HC"
#include <stdlib.h>

CDC *dc;

U0 DrawViewer(I64 map_index, I64 layer_index, I64 marker_index)
{
  const HBMMap *map = HBMMapAt(map_index);
  const HBMLayer *layer = HBMLayerAt(layer_index);
  const HBMMarker *markers;
  I64 marker_count;
  const HBMMarker *selected;
  char detail[64];

  dc->color = BLACK;
  DCFill(dc);
  dc->color = YELLOW;
  GrText(dc, 10, 10, map->name);
  dc->color = LTCYAN;
  if (layer && strcmp(layer->map_id, map->id) == 0)
    GrText(dc, 10, 31, layer->name);
  else
    GrText(dc, 10, 31, map->period);
  HBMDrawDetailedMap(dc, map, layer, 20, 60, 600, 360);

  markers = map->markers;
  marker_count = map->marker_count;
  if (layer && strcmp(layer->map_id, map->id) == 0) {
    markers = layer->markers;
    marker_count = layer->marker_count;
  }

  if (marker_count > 0) {
    selected = &markers[marker_index % marker_count];
    dc->color = WHITE;
    I64 selected_x = HBMMarkerScreenX(map, selected, 20, 600);
    I64 selected_y = HBMMarkerScreenY(map, selected, 60, 360);
    GrLine(dc, selected_x - 7, selected_y - 7,
           selected_x + 7, selected_y - 7);
    GrLine(dc, selected_x - 7, selected_y + 7,
           selected_x + 7, selected_y + 7);
    GrLine(dc, selected_x - 7, selected_y - 7,
           selected_x - 7, selected_y + 7);
    GrLine(dc, selected_x + 7, selected_y - 7,
           selected_x + 7, selected_y + 7);
    snprintf(detail, sizeof(detail), "%s  %s",
             selected->name, selected->reference);
    dc->color = BLACK;
    GrRect(dc, 0, 423, 640, 57);
    dc->color = selected->certainty == HBM_CERTAINTY_DISPUTED
                    ? LTPURPLE
                    : YELLOW;
    GrText(dc, 10, 428, detail);
  }
  dc->color = LTGRAY;
  GrText(dc, 10, 452, "LEFT RIGHT MAP  UP DOWN LAYER  ACTION PLACE");
}

U0 Main()
{
  HGInput input;
  I64 map_index = 0;
  I64 layer_index = 0;
  I64 horizontal_latch = 0;
  I64 vertical_latch = 0;
  I64 marker_index = 0;
  I64 frames = 0;
  Bool autoplay = getenv("HOLY_MAPS_AUTOPLAY") != NULL;

  dc = DCAlias;
  while (!HCQuitRequested()) {
    HGInputPoll(&input, 1);
    if (input.cancel)
      break;
    if (input.move_x != 0 && horizontal_latch == 0)
      map_index =
          (map_index + SignI64(input.move_x) + HBMMapCount()) % HBMMapCount();
    if (input.move_y != 0 && vertical_latch == 0)
      layer_index =
          (layer_index + SignI64(input.move_y) + HBMLayerCount()) %
          HBMLayerCount();
    if (input.action)
      marker_index++;
    horizontal_latch = SignI64(input.move_x);
    vertical_latch = SignI64(input.move_y);
    if (autoplay && frames > 0 && frames % 8 == 0)
      map_index = (map_index + 1) % HBMMapCount();
    DrawViewer(map_index, layer_index, marker_index);
    Sleep(16);
    if (autoplay && ++frames > 56)
      break;
  }
  DCDel(dc);
}

Main;
