#ifndef HOLY_MAPS_DETAIL_HC
#define HOLY_MAPS_DETAIL_HC

#include "HolyMaps.HC"
#include "HolyMapsRasterData.HC"

I64 HBMMarkerScreenX(const HBMMap *map, const HBMMarker *marker,
                     I64 origin_x, I64 width)
{
  return origin_x + marker->x * width / map->width;
}

I64 HBMMarkerScreenY(const HBMMap *map, const HBMMarker *marker,
                     I64 origin_y, I64 height)
{
  return origin_y + marker->y * height / map->height;
}

const U8 *HBMDRasterForMap(const HBMMap *map, I64 *data_size)
{
  if (strcmp(map->id, "near_east") == 0) {
    *data_size = sizeof(hbm_raster_near_east);
    return hbm_raster_near_east;
  }
  if (strcmp(map->id, "mediterranean") == 0) {
    *data_size = sizeof(hbm_raster_mediterranean);
    return hbm_raster_mediterranean;
  }
  if (strcmp(map->id, "bethlehem") == 0) {
    *data_size = sizeof(hbm_raster_bethlehem);
    return hbm_raster_bethlehem;
  }
  if (strcmp(map->id, "jerusalem") == 0) {
    *data_size = sizeof(hbm_raster_jerusalem);
    return hbm_raster_jerusalem;
  }
  if (strcmp(map->id, "valley_elah") == 0) {
    *data_size = sizeof(hbm_raster_valley_elah);
    return hbm_raster_valley_elah;
  }
  if (strcmp(map->id, "exodus_route") == 0) {
    *data_size = sizeof(hbm_raster_exodus_route);
    return hbm_raster_exodus_route;
  }
  *data_size = 0;
  return NULL;
}

I64 HBMDRasterPixelCount(const U8 *data, I64 data_size)
{
  I64 index;
  I64 pixels = 0;

  for (index = 0; index < data_size; index++)
    pixels += (data[index] & 15) + 1;
  return pixels;
}

U0 HBMDDrawRaster(CDC *dc, const U8 *data, I64 data_size,
                  I64 origin_x, I64 origin_y)
{
  I64 index;
  I64 pixel = 0;
  I64 run;
  I64 row;
  I64 column;
  I64 span;

  for (index = 0; index < data_size && pixel < HBM_MAP_W * HBM_MAP_H;
       index++) {
    dc->color = data[index] >> 4;
    run = (data[index] & 15) + 1;
    while (run > 0) {
      row = pixel / HBM_MAP_W;
      column = pixel % HBM_MAP_W;
      span = HBM_MAP_W - column;
      if (span > run)
        span = run;
      GrRect(dc, origin_x + column, origin_y + row, span, 1);
      pixel += span;
      run -= span;
    }
  }
}

U0 HBMDrawMarkers(CDC *dc, const HBMMarker *markers,
                  I64 marker_count, I64 origin_x,
                  I64 origin_y, I64 tile_size)
{
  I64 index;
  I64 marker_x;
  I64 marker_y;

  (void)tile_size;
  for (index = 0; index < marker_count; index++) {
    marker_x = origin_x + markers[index].x * HBM_MAP_W / 30;
    marker_y = origin_y + markers[index].y * HBM_MAP_H / 18;
    dc->color = BLACK;
    GrRect(dc, marker_x - 3, marker_y - 3, 7, 7);
    dc->color = markers[index].certainty == HBM_CERTAINTY_DISPUTED
                    ? LTPURPLE
                    : markers[index].kind == HBM_LOCATION_ROUTE
                          ? YELLOW
                          : LTRED;
    GrRect(dc, marker_x - 2, marker_y - 2, 5, 5);
  }
}

U0 HBMDrawMap(CDC *dc, const HBMMap *map, const HBMLayer *layer,
              I64 origin_x, I64 origin_y, I64 tile_size)
{
  const U8 *raster;
  I64 data_size;

  (void)tile_size;
  raster = HBMDRasterForMap(map, &data_size);
  if (!raster)
    return;
  HBMDDrawRaster(dc, raster, data_size, origin_x, origin_y);
  HBMDrawMarkers(dc, map->markers, map->marker_count,
                 origin_x, origin_y, 1);
  if (layer && strcmp(layer->map_id, map->id) == 0)
    HBMDrawMarkers(dc, layer->markers, layer->marker_count,
                   origin_x, origin_y, 1);
}

#endif
