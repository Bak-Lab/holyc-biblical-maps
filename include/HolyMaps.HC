#ifndef HOLY_MAPS_HC
#define HOLY_MAPS_HC

#include <string.h>

#define HBM_LOCATION_CITY 1
#define HBM_LOCATION_REGION 2
#define HBM_LOCATION_LANDMARK 3
#define HBM_LOCATION_ROUTE 4

#define HBM_CERTAINTY_ATTESTED 1
#define HBM_CERTAINTY_APPROXIMATE 2
#define HBM_CERTAINTY_TRADITIONAL 3
#define HBM_CERTAINTY_DISPUTED 4

#define HBM_MAP_W 640
#define HBM_MAP_H 360

typedef struct {
  const char *id;
  const char *name;
  I64 x;
  I64 y;
  I64 kind;
  I64 certainty;
  const char *reference;
} HBMMarker;

typedef struct {
  const char *id;
  const char *name;
  const char *period;
  I64 width;
  I64 height;
  const char **tiles;
  const HBMMarker *markers;
  I64 marker_count;
} HBMMap;

typedef struct {
  const char *id;
  const char *name;
  const char *map_id;
  const char *period;
  const HBMMarker *markers;
  I64 marker_count;
} HBMLayer;

static const char *hbm_near_east_tiles[] = {
    "~~~~~~~~~~""~~~~~~~~~~""~~~.......",
    "~~~~~~~~~~""~~~~~~~~~~""~.........",
    "~~~~~~~~~~""~~~~~~~~~.""..........",
    "~~~~~~~~~~""~~~~~~~~..""....^^^^^^",
    "~~~~~~~~~~""~~~~~~~...""...^^^^...",
    "~~~~~~~~~~""~~~~~~....""..........",
    "~~~~~~~~~~""~~~~~.....""..........",
    "~~~~~~~~~~""~~~~......""..........",
    "~~~~~~~~~~""~~~.......""..........",
    "~~~~~~~~~~""~~........""..........",
    "~~~~~~~~~~""~.........""....::::::",
    "~~~~~~~~~~""..........""..::::::::",
    "~~~~~.....""..........""::::::::::",
    "~~~.......""..^.......""::::::::::",
    "~~..|.....""..^^......""::::::::::",
    "~...|.....""...^......""::::::::::",
    "....|.....""..........""::::::::::",
    "....|.....""..........""::::::::::",
};

static const char *hbm_mediterranean_tiles[] = {
    "..........""..........""..........",
    "..........""..........""..........",
    "....^^....""...^^^....""...^^^^...",
    "...^^.....""..^^......""..^^^^....",
    "..........""..........""..........",
    "~~~~......""..........""..........",
    "~~~~~.....""..........""..........",
    "~~~~~~....""..........""..........",
    "~~~~~~~...""..~~~.....""..........",
    "~~~~~~~~..""~~~~~~....""..........",
    "~~~~~~~~~~""~~~~~~~~..""..........",
    "~~~~~~~~~~""~~~~~~~~~.""..........",
    "~~~~~~~~~~""~~~~~~~~~~""~.........",
    "~~~~~~~~~~""~~~~~~~~~~""~~........",
    "~~~~~.....""~~~~~~~~~~""~~~.......",
    "~~~.......""..~~~~~~~~""~~~~......",
    "..........""....~~~~~~""~~~~......",
    "..........""......~~~~""~~~.......",
};

static const char *hbm_bethlehem_tiles[] = {
    "..........""..........""..........",
    "..^^^^^^^^""..........""..........",
    "..^.......""..........""....^^....",
    "..^.......""....======""======....",
    "..^.......""....=....."".....=....",
    "..........""....=..###""##...=....",
    "....~~~~..""....=..#.."".#...=....",
    "...~~~~~~.""====+==#.."".#===+====",
    "...~~~~~~.""....=..###""##...=....",
    "....~~~~..""....=....."".....=....",
    "..........""....======""======....",
    "..........""..........""..........",
    "..^^^^^^^^""^^^^......""..........",
    "..........""..^^......""..........",
    "..........""..........""....^^....",
    "....======""==========""======....",
    "..........""..........""..........",
    "..........""..........""..........",
};

static const char *hbm_jerusalem_tiles[] = {
    "^^^^^^^^^^""^^^^^^^^^^""^^^^^^^^^^",
    "^^........""..........""........^^",
    "^..#######""##########""#######..^",
    "^..#......""....#.....""......#..^",
    "^..#..####""....#..###""##....#..^",
    "^..#..#...""....#..#.."".#....#..^",
    "^..#..#...""....#..#.."".#....#..^",
    "^..#..####""....#..###""##....#..^",
    "^..#......""....#.....""......#..^",
    "^..+======""====+=====""======+..^",
    "^..#......""....#.....""......#..^",
    "^..#..####""##..#..###""##....#..^",
    "^..#..#..."".#..#..#.."".#....#..^",
    "^..#..####""##..#..###""##....#..^",
    "^..#......""....#.....""......#..^",
    "^..#######""####+#####""#######..^",
    "^^........""....=.....""........^^",
    "^^^^^^^^^^""^^^^=^^^^^""^^^^^^^^^^",
};

static const char *hbm_elah_tiles[] = {
    "^^^^^^^^^^""..........""^^^^^^^^^^",
    "^^^^^^....""..........""....^^^^^^",
    "^^^^......""..........""......^^^^",
    "^^........""..........""........^^",
    "..........""..........""..........",
    "....######""..........""######....",
    "..........""..........""..........",
    "==========""==========""==========",
    "..........""..........""..........",
    "..........""~~~~~~~~~~""..........",
    "..........""~~~~~~~~~~""..........",
    "==========""==========""==========",
    "..........""..........""..........",
    "....######""..........""######....",
    "^^........""..........""........^^",
    "^^^^......""..........""......^^^^",
    "^^^^^^....""..........""....^^^^^^",
    "^^^^^^^^^^""..........""^^^^^^^^^^",
};

static const char *hbm_exodus_tiles[] = {
    "~~~~~~~~~~""~~~~......""..........",
    "~~~~~~~~~~""~~~.......""..........",
    "~~~~~~~~~~""~~........""..........",
    "~~~~~~~~~~""~.........""..........",
    "~~~~~~....""..........""..........",
    "~~~~......""..........""..........",
    "~~..|.....""..........""..........",
    "....|=====""==========""===.......",
    "....|.....""::::::::::""::=:::::::",
    "....|.....""::::::::::""::=:::::::",
    "....|.....""::::^^^^::""::=:::::::",
    "....|....."":::^^^^^^:""::=:::::::",
    "....|....."":::^^^^^^:""::=:::::::",
    "....|.....""::::^^^^::""::=:::::::",
    "....|.....""::::::::::""::========",
    "....|.....""::::::::::""::::::::::",
    "....|.....""::::::::::""::::::::::",
    "....|.....""::::::::::""::::::::::",
};

static const HBMMarker hbm_near_east_markers[] = {
    {"egypt", "Egypt", 9, 9, HBM_LOCATION_REGION, HBM_CERTAINTY_ATTESTED, "EXO 1"},
    {"sinai", "Sinai", 11, 8, HBM_LOCATION_REGION, HBM_CERTAINTY_DISPUTED, "EXO 19"},
    {"canaan", "Canaan", 11, 6, HBM_LOCATION_REGION, HBM_CERTAINTY_APPROXIMATE, "GEN 12"},
    {"damascus", "Damascus", 12, 5, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "1KI 11"},
    {"haran", "Haran", 14, 3, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "GEN 11"},
    {"nineveh", "Nineveh", 16, 3, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "JON 1"},
    {"babylon", "Babylon", 17, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "2KI 24"},
    {"susa", "Susa", 19, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "EST 1"},
};

static const HBMMarker hbm_mediterranean_markers[] = {
    {"rome", "Rome", 12, 4, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "ACT 28"},
    {"corinth", "Corinth", 18, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "ACT 18"},
    {"ephesus", "Ephesus", 20, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "ACT 19"},
    {"antioch", "Antioch", 25, 7, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "ACT 11"},
    {"galilee", "Galilee", 25, 9, HBM_LOCATION_REGION, HBM_CERTAINTY_APPROXIMATE, "MAT 4"},
    {"jerusalem", "Jerusalem", 25, 10, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "ACT 1"},
    {"alexandria", "Alexandria", 22, 10, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "ACT 18"},
};

static const HBMMarker hbm_bethlehem_markers[] = {
    {"bethlehem", "Bethlehem", 14, 16, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "1SA 16"},
    {"fields", "Shepherd Fields", 18, 17, HBM_LOCATION_LANDMARK, HBM_CERTAINTY_TRADITIONAL, "LUK 2"},
    {"well", "Town Well", 14, 15, HBM_LOCATION_LANDMARK, HBM_CERTAINTY_APPROXIMATE, "2SA 23"},
    {"jerusalem_road", "Road to Jerusalem", 16, 8, HBM_LOCATION_ROUTE, HBM_CERTAINTY_APPROXIMATE, "JDG 19"},
};

static const HBMMarker hbm_jerusalem_markers[] = {
    {"city_of_david", "City of David", 14, 16, HBM_LOCATION_REGION, HBM_CERTAINTY_APPROXIMATE, "2SA 5"},
    {"temple_mount", "Temple Mount", 19, 8, HBM_LOCATION_LANDMARK, HBM_CERTAINTY_TRADITIONAL, "2CH 3"},
    {"gihon", "Gihon Spring", 21, 17, HBM_LOCATION_LANDMARK, HBM_CERTAINTY_ATTESTED, "1KI 1"},
    {"western_gate", "Western Gate", 10, 8, HBM_LOCATION_LANDMARK, HBM_CERTAINTY_APPROXIMATE, "2CH 23"},
};

static const HBMMarker hbm_elah_markers[] = {
    {"israel_camp", "Israelite Camp", 12, 8, HBM_LOCATION_LANDMARK, HBM_CERTAINTY_APPROXIMATE, "1SA 17"},
    {"philistine_camp", "Philistine Camp", 5, 13, HBM_LOCATION_LANDMARK, HBM_CERTAINTY_APPROXIMATE, "1SA 17"},
    {"elah_stream", "Brook of Elah", 9, 11, HBM_LOCATION_LANDMARK, HBM_CERTAINTY_APPROXIMATE, "1SA 17"},
    {"duel_ground", "Duel Ground", 10, 10, HBM_LOCATION_LANDMARK, HBM_CERTAINTY_APPROXIMATE, "1SA 17"},
};

static const HBMMarker hbm_exodus_markers[] = {
    {"goshen", "Goshen", 5, 5, HBM_LOCATION_REGION, HBM_CERTAINTY_APPROXIMATE, "EXO 8"},
    {"succoth", "Succoth", 7, 6, HBM_LOCATION_ROUTE, HBM_CERTAINTY_DISPUTED, "EXO 12"},
    {"sea_crossing", "Sea Crossing", 8, 8, HBM_LOCATION_ROUTE, HBM_CERTAINTY_DISPUTED, "EXO 14"},
    {"sinai_camp", "Sinai Camp", 13, 14, HBM_LOCATION_ROUTE, HBM_CERTAINTY_DISPUTED, "EXO 19"},
    {"kadesh", "Kadesh Barnea", 22, 5, HBM_LOCATION_ROUTE, HBM_CERTAINTY_APPROXIMATE, "NUM 13"},
    {"jericho", "Jericho", 26, 2, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "JOS 6"},
};

static const HBMMap hbm_maps[] = {
    {"near_east", "BIBLICAL NEAR EAST", "GEOGRAPHIC BASE", 30, 18,
     hbm_near_east_tiles, hbm_near_east_markers, 8},
    {"mediterranean", "EASTERN MEDITERRANEAN", "ROMAN WORLD BASE", 30, 18,
     hbm_mediterranean_tiles, hbm_mediterranean_markers, 7},
    {"bethlehem", "BETHLEHEM", "DETAILED GAME MAP", 30, 18,
     hbm_bethlehem_tiles, hbm_bethlehem_markers, 4},
    {"jerusalem", "JERUSALEM", "UNITED MONARCHY SCHEMATIC", 30, 18,
     hbm_jerusalem_tiles, hbm_jerusalem_markers, 4},
    {"valley_elah", "VALLEY OF ELAH", "1 SAMUEL 17 SCHEMATIC", 30, 18,
     hbm_elah_tiles, hbm_elah_markers, 4},
    {"exodus_route", "EGYPT AND EXODUS ROUTE", "ROUTE IS DISPUTED", 30, 18,
     hbm_exodus_tiles, hbm_exodus_markers, 6},
};

static const HBMMarker hbm_patriarch_markers[] = {
    {"ur", "Ur", 18, 7, HBM_LOCATION_CITY, HBM_CERTAINTY_APPROXIMATE, "GEN 11"},
    {"haran", "Haran", 14, 3, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "GEN 11"},
    {"shechem", "Shechem", 11, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "GEN 12"},
    {"bethel", "Bethel", 11, 7, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "GEN 12"},
    {"hebron", "Hebron", 10, 7, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "GEN 13"},
    {"beersheba", "Beersheba", 10, 8, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "GEN 21"},
};

static const HBMMarker hbm_exodus_layer_markers[] = {
    {"raamses", "Rameses", 10, 7, HBM_LOCATION_CITY, HBM_CERTAINTY_APPROXIMATE, "EXO 12"},
    {"sea_crossing", "Sea Crossing", 11, 8, HBM_LOCATION_ROUTE, HBM_CERTAINTY_DISPUTED, "EXO 14"},
    {"sinai", "Mount Sinai", 11, 9, HBM_LOCATION_LANDMARK, HBM_CERTAINTY_DISPUTED, "EXO 19"},
    {"kadesh", "Kadesh Barnea", 10, 8, HBM_LOCATION_ROUTE, HBM_CERTAINTY_APPROXIMATE, "NUM 13"},
    {"jericho", "Jericho", 11, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "JOS 6"},
    {"shiloh", "Shiloh", 11, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_APPROXIMATE, "JOS 18"},
};

static const HBMMarker hbm_monarchy_markers[] = {
    {"jerusalem", "Jerusalem", 11, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "2SA 5"},
    {"bethlehem", "Bethlehem", 11, 7, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "1SA 16"},
    {"hebron", "Hebron", 10, 7, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "2SA 2"},
    {"elah", "Valley of Elah", 10, 7, HBM_LOCATION_LANDMARK, HBM_CERTAINTY_ATTESTED, "1SA 17"},
    {"gath", "Gath", 10, 7, HBM_LOCATION_CITY, HBM_CERTAINTY_APPROXIMATE, "1SA 17"},
    {"dan", "Dan", 11, 4, HBM_LOCATION_CITY, HBM_CERTAINTY_APPROXIMATE, "JDG 18"},
};

static const HBMMarker hbm_kingdom_markers[] = {
    {"samaria", "Samaria", 11, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "1KI 16"},
    {"jerusalem", "Jerusalem", 11, 7, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "1KI 12"},
    {"damascus", "Damascus", 12, 5, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "1KI 15"},
    {"nineveh", "Nineveh", 16, 3, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "2KI 19"},
    {"lachish", "Lachish", 10, 7, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "2KI 18"},
};

static const HBMMarker hbm_exile_markers[] = {
    {"jerusalem", "Jerusalem", 11, 7, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "2KI 25"},
    {"babylon", "Babylon", 17, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "2KI 24"},
    {"susa", "Susa", 19, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "EST 1"},
    {"return_route", "Return Route", 15, 5, HBM_LOCATION_ROUTE, HBM_CERTAINTY_APPROXIMATE, "EZR 1"},
};

static const HBMMarker hbm_nt_markers[] = {
    {"jerusalem", "Jerusalem", 25, 10, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "ACT 1"},
    {"nazareth", "Nazareth", 25, 9, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "LUK 1"},
    {"capernaum", "Capernaum", 25, 8, HBM_LOCATION_CITY, HBM_CERTAINTY_APPROXIMATE, "MAT 4"},
    {"antioch", "Antioch", 25, 7, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "ACT 11"},
    {"ephesus", "Ephesus", 20, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "ACT 19"},
    {"corinth", "Corinth", 18, 6, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "ACT 18"},
    {"rome", "Rome", 12, 4, HBM_LOCATION_CITY, HBM_CERTAINTY_ATTESTED, "ACT 28"},
};

static const HBMLayer hbm_layers[] = {
    {"patriarchs", "PATRIARCHS", "near_east", "GENESIS",
     hbm_patriarch_markers, 6},
    {"exodus_conquest", "EXODUS AND CONQUEST", "near_east", "EXODUS TO JOSHUA",
     hbm_exodus_layer_markers, 6},
    {"united_monarchy", "UNITED MONARCHY", "near_east", "SAUL DAVID SOLOMON",
     hbm_monarchy_markers, 6},
    {"divided_kingdoms", "DIVIDED KINGDOMS", "near_east", "ISRAEL AND JUDAH",
     hbm_kingdom_markers, 5},
    {"exile_return", "EXILE AND RETURN", "near_east", "BABYLON TO JERUSALEM",
     hbm_exile_markers, 4},
    {"new_testament", "NEW TESTAMENT", "mediterranean", "ROMAN WORLD",
     hbm_nt_markers, 7},
};

I64 HBMMapCount()
{
  return sizeof(hbm_maps) / sizeof(hbm_maps[0]);
}

I64 HBMLayerCount()
{
  return sizeof(hbm_layers) / sizeof(hbm_layers[0]);
}

const HBMMap *HBMMapAt(I64 index)
{
  if (index < 0 || index >= HBMMapCount())
    return NULL;
  return &hbm_maps[index];
}

const HBMLayer *HBMLayerAt(I64 index)
{
  if (index < 0 || index >= HBMLayerCount())
    return NULL;
  return &hbm_layers[index];
}

const HBMMap *HBMFindMap(const char *id)
{
  I64 index;

  if (!id)
    return NULL;
  for (index = 0; index < HBMMapCount(); index++)
    if (strcmp(hbm_maps[index].id, id) == 0)
      return &hbm_maps[index];
  return NULL;
}

const HBMLayer *HBMFindLayer(const char *id)
{
  I64 index;

  if (!id)
    return NULL;
  for (index = 0; index < HBMLayerCount(); index++)
    if (strcmp(hbm_layers[index].id, id) == 0)
      return &hbm_layers[index];
  return NULL;
}

I64 HBMTileColor(char tile)
{
  if (tile == '~')
    return BLUE;
  if (tile == '^')
    return BROWN;
  if (tile == ':')
    return YELLOW;
  if (tile == '#')
    return DKGRAY;
  if (tile == '=')
    return LTGRAY;
  if (tile == '|')
    return CYAN;
  if (tile == '+')
    return WHITE;
  return GREEN;
}

#include "HolyMapsDetail.HC"

#endif
