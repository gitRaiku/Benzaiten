#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Usage ./printram <file>\n"); exit(1);
  }

  int32_t fd = open(argv[1], O_RDONLY);
  if (fd < 1) {
    fprintf(stderr, "Could not open %s! %m\n", argv[1]); exit(1);
  }
  uint8_t cres[1024];
  uint32_t ci = 0;
  ssize_t readl;
  do {
    readl = read(fd, cres, sizeof(cres));
    int32_t i;
    for(i = 0; i < readl / 4; ++i) {
      fprintf(stdout, "ops[%u] <= 32'h%08x;\n", ci++, 
          (uint32_t)(cres[i * 4 + 0] << 0) + 
          (uint32_t)(cres[i * 4 + 1] << 8) + 
          (uint32_t)(cres[i * 4 + 2] <<16) + 
          (uint32_t)(cres[i * 4 + 3] <<24));
    }
  } while (readl == sizeof(cres));
  
  return 0;
}

