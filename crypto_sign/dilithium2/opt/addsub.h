#ifndef ADDSUB_H
#define ADDSUB_H
#include "params.h"
void sub_asm(int8_t c[N], int8_t v[N]);
void add_asm(int8_t c[N], int8_t v[N]);
void preparetable_asm(int8_t v[2*N], int8_t b[N]);
#endif