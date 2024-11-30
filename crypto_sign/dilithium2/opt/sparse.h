#ifndef SPARSE_H
#define SPARSE_H
#include "params.h"
void sparse_polymul(int8_t ret[N], const uint8_t pos_neg_list[TAU + 1], const int8_t s[2 * N]);
void prepare_table_asm(int8_t s[2 * N]);

#endif