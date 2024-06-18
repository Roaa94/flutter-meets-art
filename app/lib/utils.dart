int rgbaToArgb(int rgbaColor) {
  return ((rgbaColor & 0x000000FF) << 24) | ((rgbaColor & 0xFFFFFF00) >> 8);
}