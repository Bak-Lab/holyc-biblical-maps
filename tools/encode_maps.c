#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const uint8_t palette[16][3] = {
    {0x00, 0x00, 0x00}, {0x00, 0x00, 0xaa}, {0x00, 0xaa, 0x00},
    {0x00, 0xaa, 0xaa}, {0xaa, 0x00, 0x00}, {0xaa, 0x00, 0xaa},
    {0xaa, 0x55, 0x00}, {0xaa, 0xaa, 0xaa}, {0x55, 0x55, 0x55},
    {0x55, 0x55, 0xff}, {0x55, 0xff, 0x55}, {0x55, 0xff, 0xff},
    {0xff, 0x55, 0x55}, {0xff, 0x55, 0xff}, {0xff, 0xff, 0x55},
    {0xff, 0xff, 0xff},
};

static int read_number(FILE *input)
{
  int character;
  int value = 0;

  do {
    character = fgetc(input);
    if (character == '#')
      while (character != '\n' && character != EOF)
        character = fgetc(input);
  } while (isspace(character));

  while (isdigit(character)) {
    value = value * 10 + character - '0';
    character = fgetc(input);
  }
  return value;
}

static uint8_t nearest_color(const uint8_t *pixel)
{
  int color;
  int best_color = 0;
  int best_distance = 1000000;

  for (color = 0; color < 16; color++) {
    int red = (int)pixel[0] - palette[color][0];
    int green = (int)pixel[1] - palette[color][1];
    int blue = (int)pixel[2] - palette[color][2];
    int distance = red * red + green * green + blue * blue;
    if (distance < best_distance) {
      best_distance = distance;
      best_color = color;
    }
  }
  return (uint8_t)best_color;
}

static void emit_map(FILE *output, const char *name, const char *path)
{
  FILE *input = fopen(path, "rb");
  uint8_t *pixels;
  uint8_t *colors;
  size_t pixel_count;
  size_t index;
  size_t output_count = 0;
  int width;
  int height;
  int maximum;

  if (!input) {
    perror(path);
    exit(1);
  }
  if (fgetc(input) != 'P' || fgetc(input) != '6') {
    fprintf(stderr, "%s is not a binary PPM file\n", path);
    exit(1);
  }
  width = read_number(input);
  height = read_number(input);
  maximum = read_number(input);
  if (width != 640 || height != 360 || maximum != 255) {
    fprintf(stderr, "%s must be a 640x360, 8-bit PPM file\n", path);
    exit(1);
  }

  pixel_count = (size_t)width * (size_t)height;
  pixels = malloc(pixel_count * 3);
  colors = malloc(pixel_count);
  if (!pixels || !colors || fread(pixels, 3, pixel_count, input) != pixel_count) {
    fprintf(stderr, "failed to read pixels from %s\n", path);
    exit(1);
  }
  fclose(input);

  for (index = 0; index < pixel_count; index++)
    colors[index] = nearest_color(&pixels[index * 3]);

  fprintf(output, "static const U8 hbm_raster_%s[] = {\n  ", name);
  index = 0;
  while (index < pixel_count) {
    size_t run = 1;
    while (run < 16 && index + run < pixel_count &&
           colors[index + run] == colors[index])
      run++;
    if (output_count > 0 && output_count % 16 == 0)
      fprintf(output, "\n  ");
    fprintf(output, "0x%02x,",
            (unsigned int)((colors[index] << 4) | (run - 1)));
    output_count++;
    index += run;
  }
  fprintf(output, "\n};\n\n");

  free(colors);
  free(pixels);
}

int main(int argc, char **argv)
{
  FILE *output;
  int argument;

  if (argc < 3) {
    fprintf(stderr, "usage: %s OUTPUT NAME=IMAGE.ppm...\n", argv[0]);
    return 2;
  }
  output = fopen(argv[1], "wb");
  if (!output) {
    perror(argv[1]);
    return 1;
  }

  fprintf(output, "#ifndef HOLY_MAPS_RASTER_DATA_HC\n");
  fprintf(output, "#define HOLY_MAPS_RASTER_DATA_HC\n\n");
  for (argument = 2; argument < argc; argument++) {
    char *separator = strchr(argv[argument], '=');
    if (!separator) {
      fprintf(stderr, "expected NAME=IMAGE.ppm: %s\n", argv[argument]);
      return 2;
    }
    *separator = '\0';
    emit_map(output, argv[argument], separator + 1);
  }
  fprintf(output, "#endif\n");
  fclose(output);
  return 0;
}
