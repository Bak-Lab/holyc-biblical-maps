#include "HolyGame.HC"
#include "HolyMaps.HC"
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

  HBMDrawMap(dc, map, layer, 0, 0, 1);

  markers = map->markers;
  marker_count = map->marker_count;
  if (layer && strcmp(layer->map_id, map->id) == 0) {
    markers = layer->markers;
    marker_count = layer->marker_count;
  }

  if (marker_count > 0) {
    selected = &markers[marker_index % marker_count];
    dc->color = WHITE;
    I64 selected_x = HBMMarkerScreenX(map, selected, 0, HBM_MAP_W);
    I64 selected_y = HBMMarkerScreenY(map, selected, 0, HBM_MAP_H);
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
  }
  dc->color = BLACK;
  GrRect(dc, 0, HBM_MAP_H, 640, 120);
  dc->color = YELLOW;
  GrText(dc, 10, 366, map->name);
  dc->color = LTCYAN;
  if (layer && strcmp(layer->map_id, map->id) == 0)
    GrText(dc, 10, 389, layer->name);
  else
    GrText(dc, 10, 389, map->period);
  if (marker_count > 0) {
    dc->color = selected->certainty == HBM_CERTAINTY_DISPUTED
                    ? LTPURPLE
                    : WHITE;
    GrText(dc, 10, 412, detail);
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
  Bool redraw = TRUE;

  dc = DCAlias;
  while (!HCQuitRequested()) {
    HGInputPoll(&input, 1);
    if (input.cancel)
      break;
    if (input.move_x != 0 && horizontal_latch == 0) {
      map_index =
          (map_index + SignI64(input.move_x) + HBMMapCount()) % HBMMapCount();
      redraw = TRUE;
    }
    if (input.move_y != 0 && vertical_latch == 0) {
      layer_index =
          (layer_index + SignI64(input.move_y) + HBMLayerCount()) %
          HBMLayerCount();
      redraw = TRUE;
    }
    if (input.action) {
      marker_index++;
      redraw = TRUE;
    }
    horizontal_latch = SignI64(input.move_x);
    vertical_latch = SignI64(input.move_y);
    if (autoplay && frames > 0 && frames % 8 == 0) {
      map_index = (map_index + 1) % HBMMapCount();
      redraw = TRUE;
    }
    if (redraw) {
      DrawViewer(map_index, layer_index, marker_index);
      redraw = FALSE;
    }
    Sleep(16);
    if (autoplay && ++frames > 56)
      break;
  }
  DCDel(dc);
}

Main;
