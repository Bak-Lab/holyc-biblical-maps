#ifndef HOLY_MAPS_DETAIL_HC
#define HOLY_MAPS_DETAIL_HC

#include "HolyMaps.HC"

#define HBMD_COORD_MAX 1000
#define HBMD_MAX_INTERSECTIONS 32

typedef struct {
  I64 x;
  I64 y;
} HBMDPoint;

I64 HBMMarkerScreenX(const HBMMap *map, const HBMMarker *marker,
                     I64 origin_x, I64 width)
{
  return origin_x + marker->x * width / map->width + width / map->width / 2;
}

I64 HBMMarkerScreenY(const HBMMap *map, const HBMMarker *marker,
                     I64 origin_y, I64 height)
{
  return origin_y + marker->y * height / map->height + height / map->height / 2;
}

I64 HBMDScaleX(I64 x, I64 origin_x, I64 width)
{
  return origin_x + x * width / HBMD_COORD_MAX;
}

I64 HBMDScaleY(I64 y, I64 origin_y, I64 height)
{
  return origin_y + y * height / HBMD_COORD_MAX;
}

U0 HBMDFillPolygon(CDC *dc, const HBMDPoint *points, I64 point_count,
                   I64 color, I64 origin_x, I64 origin_y,
                   I64 width, I64 height)
{
  I64 intersections[HBMD_MAX_INTERSECTIONS];
  I64 edge;
  I64 count;
  I64 index;
  I64 scan_y;
  I64 map_y;
  I64 x;
  I64 swap;
  const HBMDPoint *first;
  const HBMDPoint *second;

  dc->color = color;
  for (scan_y = 0; scan_y < height; scan_y++) {
    map_y = scan_y * HBMD_COORD_MAX / height;
    count = 0;
    for (edge = 0; edge < point_count; edge++) {
      first = &points[edge];
      second = &points[(edge + 1) % point_count];
      if (((first->y <= map_y && second->y > map_y) ||
           (second->y <= map_y && first->y > map_y)) &&
          count < HBMD_MAX_INTERSECTIONS) {
        x = first->x + (map_y - first->y) *
                         (second->x - first->x) /
                         (second->y - first->y);
        intersections[count++] = x;
      }
    }
    for (index = 1; index < count; index++) {
      edge = index;
      while (edge > 0 && intersections[edge - 1] > intersections[edge]) {
        swap = intersections[edge - 1];
        intersections[edge - 1] = intersections[edge];
        intersections[edge] = swap;
        edge--;
      }
    }
    for (index = 0; index + 1 < count; index += 2)
      GrLine(dc, HBMDScaleX(intersections[index], origin_x, width),
             origin_y + scan_y,
             HBMDScaleX(intersections[index + 1], origin_x, width),
             origin_y + scan_y);
  }
}

U0 HBMDOutlinePolygon(CDC *dc, const HBMDPoint *points, I64 point_count,
                      I64 color, I64 origin_x, I64 origin_y,
                      I64 width, I64 height)
{
  I64 index;

  dc->color = color;
  for (index = 0; index < point_count; index++)
    GrLine(dc,
           HBMDScaleX(points[index].x, origin_x, width),
           HBMDScaleY(points[index].y, origin_y, height),
           HBMDScaleX(points[(index + 1) % point_count].x, origin_x, width),
           HBMDScaleY(points[(index + 1) % point_count].y, origin_y, height));
}

U0 HBMDDrawPolygon(CDC *dc, const HBMDPoint *points, I64 point_count,
                   I64 fill_color, I64 edge_color,
                   I64 origin_x, I64 origin_y, I64 width, I64 height)
{
  HBMDFillPolygon(dc, points, point_count, fill_color,
                  origin_x, origin_y, width, height);
  HBMDOutlinePolygon(dc, points, point_count, edge_color,
                     origin_x, origin_y, width, height);
}

U0 HBMDDrawPath(CDC *dc, const HBMDPoint *points, I64 point_count,
                I64 color, I64 thickness, I64 origin_x, I64 origin_y,
                I64 width, I64 height)
{
  I64 index;
  I64 offset;
  I64 half = thickness / 2;

  dc->color = color;
  for (index = 0; index + 1 < point_count; index++)
    for (offset = -half; offset <= half; offset++) {
      GrLine(dc, HBMDScaleX(points[index].x, origin_x, width) + offset,
             HBMDScaleY(points[index].y, origin_y, height),
             HBMDScaleX(points[index + 1].x, origin_x, width) + offset,
             HBMDScaleY(points[index + 1].y, origin_y, height));
      GrLine(dc, HBMDScaleX(points[index].x, origin_x, width),
             HBMDScaleY(points[index].y, origin_y, height) + offset,
             HBMDScaleX(points[index + 1].x, origin_x, width),
             HBMDScaleY(points[index + 1].y, origin_y, height) + offset);
    }
}

U0 HBMDTerrainMarks(CDC *dc, I64 color, I64 spacing, I64 seed,
                    I64 origin_x, I64 origin_y, I64 width, I64 height)
{
  I64 x;
  I64 y;
  I64 jitter;

  dc->color = color;
  for (y = spacing; y < height; y += spacing)
    for (x = spacing; x < width; x += spacing) {
      jitter = (x * 17 + y * 31 + seed * 13) % (spacing - 2);
      if ((x + y + seed) % 3 == 0)
        GrPlot(dc, origin_x + x + jitter / 2,
              origin_y + y + jitter / 3);
    }
}

static const HBMDPoint hbmd_near_land[] = {
    {120, 0}, {100, 75}, {126, 132}, {151, 185}, {143, 247},
    {171, 310}, {165, 382}, {189, 446}, {176, 515}, {193, 590},
    {168, 668}, {117, 734}, {82, 807}, {61, 891}, {43, 1000},
    {1000, 1000}, {1000, 0}};
static const HBMDPoint hbmd_near_desert[] = {
    {179, 511}, {290, 459}, {425, 477}, {519, 534}, {638, 548},
    {761, 610}, {1000, 637}, {1000, 1000}, {44, 1000},
    {63, 891}, {88, 803}, {127, 731}, {168, 666}, {192, 590}};
static const HBMDPoint hbmd_near_delta[] = {
    {38, 760}, {105, 705}, {189, 724}, {247, 791}, {217, 861},
    {99, 845}};
static const HBMDPoint hbmd_near_levant[] = {
    {174, 349}, {214, 317}, {251, 327}, {273, 402}, {256, 493},
    {231, 579}, {190, 595}, {178, 519}, {194, 444}};
static const HBMDPoint hbmd_near_taurus[] = {
    {251, 198}, {337, 145}, {444, 161}, {519, 206}, {430, 245},
    {324, 231}};
static const HBMDPoint hbmd_near_zagros[] = {
    {633, 249}, {691, 279}, {737, 360}, {778, 446}, {825, 527},
    {858, 624}, {816, 595}, {764, 510}, {716, 421}, {671, 333}};
static const HBMDPoint hbmd_nile[] = {
    {110, 1000}, {111, 915}, {118, 846}, {139, 788}, {170, 749}};
static const HBMDPoint hbmd_euphrates[] = {
    {527, 173}, {548, 246}, {572, 318}, {613, 388}, {646, 469},
    {676, 559}, {704, 655}, {743, 739}};
static const HBMDPoint hbmd_tigris[] = {
    {620, 182}, {635, 267}, {657, 355}, {679, 443}, {708, 532},
    {730, 625}, {747, 738}};

static const HBMDPoint hbmd_med_europe[] = {
    {0, 0}, {1000, 0}, {1000, 262}, {935, 247}, {879, 278},
    {809, 254}, {744, 292}, {686, 278}, {622, 316}, {557, 300},
    {504, 336}, {453, 308}, {393, 335}, {346, 291}, {285, 312},
    {232, 274}, {175, 290}, {124, 251}, {68, 271}, {0, 233}};
static const HBMDPoint hbmd_med_africa[] = {
    {0, 725}, {96, 690}, {198, 708}, {294, 684}, {386, 719},
    {485, 691}, {582, 730}, {676, 704}, {775, 735}, {868, 711},
    {1000, 753}, {1000, 1000}, {0, 1000}};
static const HBMDPoint hbmd_med_anatolia[] = {
    {551, 345}, {625, 323}, {712, 335}, {787, 313}, {869, 347},
    {928, 390}, {888, 430}, {793, 421}, {716, 447}, {626, 429},
    {565, 391}};
static const HBMDPoint hbmd_med_levant[] = {
    {912, 425}, {1000, 419}, {1000, 750}, {929, 728}, {901, 635},
    {922, 543}};
static const HBMDPoint hbmd_med_italy[] = {
    {264, 275}, {301, 314}, {320, 374}, {355, 422}, {376, 489},
    {415, 531}, {393, 565}, {352, 530}, {339, 471}, {306, 432},
    {286, 367}, {249, 326}};
static const HBMDPoint hbmd_med_sicily[] = {
    {349, 574}, {407, 557}, {444, 579}, {397, 612}};
static const HBMDPoint hbmd_med_greece[] = {
    {465, 330}, {502, 373}, {496, 430}, {526, 472}, {505, 533},
    {474, 493}, {482, 439}, {447, 399}};
static const HBMDPoint hbmd_med_crete[] = {
    {486, 594}, {578, 582}, {633, 601}, {555, 619}};
static const HBMDPoint hbmd_med_cyprus[] = {
    {756, 529}, {815, 512}, {856, 529}, {806, 551}};

static const HBMDPoint hbmd_beth_hills[] = {
    {0, 0}, {1000, 0}, {1000, 184}, {881, 154}, {754, 201},
    {633, 155}, {519, 212}, {397, 169}, {269, 221}, {136, 172},
    {0, 216}};
static const HBMDPoint hbmd_beth_town[] = {
    {365, 260}, {655, 249}, {777, 356}, {757, 628}, {626, 738},
    {354, 712}, {251, 578}, {270, 371}};
static const HBMDPoint hbmd_beth_road_ns[] = {
    {507, 0}, {514, 198}, {493, 334}, {515, 489}, {497, 676},
    {520, 1000}};
static const HBMDPoint hbmd_beth_road_ew[] = {
    {0, 535}, {210, 526}, {389, 548}, {582, 523}, {787, 548},
    {1000, 514}};
static const HBMDPoint hbmd_beth_stream[] = {
    {0, 814}, {120, 796}, {232, 822}, {342, 803}, {454, 827}};

static const HBMDPoint hbmd_jer_hills[] = {
    {0, 0}, {1000, 0}, {1000, 1000}, {0, 1000}};
static const HBMDPoint hbmd_jer_city[] = {
    {183, 139}, {795, 125}, {881, 256}, {862, 781}, {732, 875},
    {252, 852}, {135, 724}, {128, 273}};
static const HBMDPoint hbmd_jer_temple[] = {
    {551, 194}, {782, 203}, {800, 411}, {559, 419}};
static const HBMDPoint hbmd_jer_david[] = {
    {338, 501}, {530, 483}, {558, 809}, {382, 825}, {307, 688}};
static const HBMDPoint hbmd_jer_valley[] = {
    {881, 0}, {899, 153}, {884, 301}, {918, 462}, {897, 631},
    {935, 791}, {918, 1000}};
static const HBMDPoint hbmd_jer_road_ns[] = {
    {459, 139}, {451, 319}, {475, 496}, {453, 690}, {470, 855}};
static const HBMDPoint hbmd_jer_road_ew[] = {
    {137, 466}, {318, 451}, {494, 475}, {681, 448}, {865, 469}};

static const HBMDPoint hbmd_elah_north[] = {
    {0, 0}, {1000, 0}, {1000, 261}, {870, 224}, {751, 279},
    {631, 238}, {514, 292}, {389, 245}, {259, 291}, {128, 237},
    {0, 281}};
static const HBMDPoint hbmd_elah_south[] = {
    {0, 747}, {139, 701}, {264, 756}, {392, 709}, {519, 762},
    {643, 716}, {770, 768}, {879, 722}, {1000, 755}, {1000, 1000},
    {0, 1000}};
static const HBMDPoint hbmd_elah_stream[] = {
    {0, 602}, {126, 578}, {244, 606}, {366, 571}, {489, 598},
    {610, 565}, {733, 590}, {856, 554}, {1000, 579}};
static const HBMDPoint hbmd_elah_road[] = {
    {0, 472}, {171, 450}, {337, 468}, {500, 443}, {666, 462},
    {835, 437}, {1000, 451}};

static const HBMDPoint hbmd_exodus_med[] = {
    {0, 0}, {573, 0}, {531, 81}, {422, 115}, {301, 104},
    {204, 138}, {96, 112}, {0, 144}};
static const HBMDPoint hbmd_exodus_red_west[] = {
    {0, 457}, {90, 472}, {142, 542}, {182, 654}, {225, 779},
    {254, 1000}, {0, 1000}};
static const HBMDPoint hbmd_exodus_red_east[] = {
    {489, 566}, {538, 628}, {568, 722}, {600, 825}, {620, 1000},
    {486, 1000}, {475, 849}, {453, 729}, {448, 636}};
static const HBMDPoint hbmd_exodus_delta[] = {
    {71, 143}, {187, 112}, {301, 143}, {347, 238}, {259, 318},
    {126, 294}, {57, 229}};
static const HBMDPoint hbmd_exodus_sinai[] = {
    {182, 330}, {424, 310}, {486, 556}, {449, 747}, {354, 924},
    {249, 781}, {184, 617}};
static const HBMDPoint hbmd_exodus_route[] = {
    {174, 248}, {244, 294}, {304, 380}, {348, 503}, {370, 641},
    {414, 759}, {527, 703}, {648, 628}, {760, 548}, {882, 475}};
static const HBMDPoint hbmd_exodus_nile[] = {
    {147, 1000}, {149, 833}, {157, 661}, {169, 500}, {194, 332},
    {225, 207}};

U0 HBMDDrawNearEast(CDC *dc, I64 x, I64 y, I64 width, I64 height)
{
  dc->color = BLUE;
  GrRect(dc, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_near_land, 17, GREEN, LTGREEN, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_near_desert, 14, YELLOW, BROWN, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_near_delta, 6, LTGREEN, GREEN, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_near_levant, 9, GREEN, LTGREEN, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_near_taurus, 6, BROWN, DKGRAY, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_near_zagros, 10, BROWN, DKGRAY, x, y, width, height);
  HBMDDrawPath(dc, hbmd_nile, 5, CYAN, 3, x, y, width, height);
  HBMDDrawPath(dc, hbmd_euphrates, 8, CYAN, 2, x, y, width, height);
  HBMDDrawPath(dc, hbmd_tigris, 7, CYAN, 2, x, y, width, height);
  HBMDTerrainMarks(dc, BROWN, 19, 3, x, y, width, height);
}

U0 HBMDDrawMediterranean(CDC *dc, I64 x, I64 y, I64 width, I64 height)
{
  dc->color = BLUE;
  GrRect(dc, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_med_europe, 20, GREEN, LTGREEN, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_med_africa, 13, YELLOW, BROWN, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_med_anatolia, 11, GREEN, BROWN, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_med_levant, 6, YELLOW, BROWN, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_med_italy, 12, GREEN, WHITE, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_med_sicily, 4, GREEN, WHITE, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_med_greece, 8, GREEN, WHITE, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_med_crete, 4, GREEN, WHITE, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_med_cyprus, 4, GREEN, WHITE, x, y, width, height);
  HBMDTerrainMarks(dc, LTBLUE, 17, 7, x, y, width, height);
}

U0 HBMDDrawBethlehem(CDC *dc, I64 x, I64 y, I64 width, I64 height)
{
  I64 row;
  I64 column;
  I64 block_x;
  I64 block_y;

  dc->color = GREEN;
  GrRect(dc, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_beth_hills, 11, BROWN, DKGRAY, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_beth_town, 8, YELLOW, BROWN, x, y, width, height);
  HBMDDrawPath(dc, hbmd_beth_road_ns, 6, LTGRAY, 7, x, y, width, height);
  HBMDDrawPath(dc, hbmd_beth_road_ew, 6, LTGRAY, 7, x, y, width, height);
  HBMDDrawPath(dc, hbmd_beth_stream, 5, CYAN, 2, x, y, width, height);
  for (row = 0; row < 4; row++)
    for (column = 0; column < 5; column++) {
      block_x = x + width * (310 + column * 93 + (row % 2) * 18) / 1000;
      block_y = y + height * (320 + row * 96) / 1000;
      dc->color = (row + column) % 2 == 0 ? DKGRAY : BROWN;
      GrRect(dc, block_x, block_y, width * 48 / 1000, height * 45 / 1000);
      dc->color = WHITE;
      GrLine(dc, block_x, block_y,
             block_x + width * 48 / 1000, block_y);
    }
  HBMDTerrainMarks(dc, LTGREEN, 16, 11, x, y, width, height);
}

U0 HBMDDrawJerusalem(CDC *dc, I64 x, I64 y, I64 width, I64 height)
{
  I64 index;

  HBMDDrawPolygon(dc, hbmd_jer_hills, 4, BROWN, DKGRAY, x, y, width, height);
  HBMDDrawPath(dc, hbmd_jer_valley, 7, GREEN, 11, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_jer_city, 8, LTGRAY, WHITE, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_jer_temple, 4, WHITE, YELLOW, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_jer_david, 5, DKGRAY, BLACK, x, y, width, height);
  HBMDDrawPath(dc, hbmd_jer_road_ns, 5, BROWN, 5, x, y, width, height);
  HBMDDrawPath(dc, hbmd_jer_road_ew, 5, BROWN, 5, x, y, width, height);
  dc->color = DKGRAY;
  for (index = 0; index < 8; index++) {
    GrRect(dc, x + width * (215 + (index % 4) * 145) / 1000,
           y + height * (280 + (index / 4) * 330) / 1000,
           width * 72 / 1000, height * 76 / 1000);
  }
}

U0 HBMDDrawElah(CDC *dc, I64 x, I64 y, I64 width, I64 height)
{
  I64 index;

  dc->color = GREEN;
  GrRect(dc, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_elah_north, 11, BROWN, DKGRAY, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_elah_south, 11, BROWN, DKGRAY, x, y, width, height);
  HBMDDrawPath(dc, hbmd_elah_stream, 9, CYAN, 3, x, y, width, height);
  HBMDDrawPath(dc, hbmd_elah_road, 7, LTGRAY, 4, x, y, width, height);
  dc->color = WHITE;
  for (index = 0; index < 7; index++) {
    GrLine(dc, x + width * (120 + index * 32) / 1000,
           y + height * 329 / 1000,
           x + width * (137 + index * 32) / 1000,
           y + height * 286 / 1000);
    GrLine(dc, x + width * (730 + index * 30) / 1000,
           y + height * 686 / 1000,
           x + width * (746 + index * 30) / 1000,
           y + height * 731 / 1000);
  }
  HBMDTerrainMarks(dc, LTGREEN, 15, 17, x, y, width, height);
}

U0 HBMDDrawExodus(CDC *dc, I64 x, I64 y, I64 width, I64 height)
{
  I64 index;

  dc->color = YELLOW;
  GrRect(dc, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_exodus_med, 8, BLUE, LTBLUE, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_exodus_red_west, 7, BLUE, LTBLUE, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_exodus_red_east, 9, BLUE, LTBLUE, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_exodus_delta, 7, GREEN, LTGREEN, x, y, width, height);
  HBMDDrawPolygon(dc, hbmd_exodus_sinai, 7, BROWN, DKGRAY, x, y, width, height);
  HBMDDrawPath(dc, hbmd_exodus_nile, 6, CYAN, 4, x, y, width, height);
  for (index = 0; index + 1 < 10; index += 2)
    HBMDDrawPath(dc, &hbmd_exodus_route[index], 2, LTRED, 3,
                 x, y, width, height);
  HBMDTerrainMarks(dc, BROWN, 17, 23, x, y, width, height);
}

U0 HBMDSelectRenderer(CDC *dc, const HBMMap *map,
                      I64 origin_x, I64 origin_y, I64 width, I64 height)
{
  if (strcmp(map->id, "near_east") == 0)
    HBMDDrawNearEast(dc, origin_x, origin_y, width, height);
  else if (strcmp(map->id, "mediterranean") == 0)
    HBMDDrawMediterranean(dc, origin_x, origin_y, width, height);
  else if (strcmp(map->id, "bethlehem") == 0)
    HBMDDrawBethlehem(dc, origin_x, origin_y, width, height);
  else if (strcmp(map->id, "jerusalem") == 0)
    HBMDDrawJerusalem(dc, origin_x, origin_y, width, height);
  else if (strcmp(map->id, "valley_elah") == 0)
    HBMDDrawElah(dc, origin_x, origin_y, width, height);
  else
    HBMDDrawExodus(dc, origin_x, origin_y, width, height);
}

U0 HBMDDrawMarkers(CDC *dc, const HBMMap *map,
                    const HBMMarker *markers, I64 marker_count,
                    I64 origin_x, I64 origin_y, I64 width, I64 height)
{
  I64 index;
  I64 marker_x;
  I64 marker_y;

  for (index = 0; index < marker_count; index++) {
    marker_x = HBMMarkerScreenX(map, &markers[index], origin_x, width);
    marker_y = HBMMarkerScreenY(map, &markers[index], origin_y, height);
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

U0 HBMDrawDetailedMap(CDC *dc, const HBMMap *map, const HBMLayer *layer,
                      I64 origin_x, I64 origin_y, I64 width, I64 height)
{
  HBMDSelectRenderer(dc, map, origin_x, origin_y, width, height);
  HBMDDrawMarkers(dc, map, map->markers, map->marker_count,
                  origin_x, origin_y, width, height);
  if (layer && strcmp(layer->map_id, map->id) == 0)
    HBMDDrawMarkers(dc, map, layer->markers, layer->marker_count,
                    origin_x, origin_y, width, height);
}

#endif
