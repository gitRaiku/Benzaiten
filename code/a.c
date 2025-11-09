int _start(void) {
  int *gpio = 0xFFFFFFFF;
  int a = 0;
  while (1) {
    a += 1;
    *gpio = a;
  }
}

