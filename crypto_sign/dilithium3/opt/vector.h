#ifndef VECTOR_H
#define VECTOR_H

#include <stdint.h>
#include "params.h"
#define asm_poly_add DILITHIUM_NAMESPACE(asm_poly_add)
void asm_poly_add(int32_t c[N], const int32_t a[N], const int32_t b[N]);
#define asm_poly_sub DILITHIUM_NAMESPACE(asm_poly_sub)
void asm_poly_sub(int32_t c[N], const int32_t a[N], const int32_t b[N]);

#define asm_poly_power2round DILITHIUM_NAMESPACE(asm_poly_power2round)
void asm_poly_power2round(int32_t a[N], int32_t b[N], const int32_t c[N]);


#define asm_poly_power2round_compact DILITHIUM_NAMESPACE(asm_poly_power2round_compact)
void asm_poly_power2round_compact(int16_t a[N], int16_t b[N], const int32_t c[N]);

#define asm_poly_decompose DILITHIUM_NAMESPACE(asm_poly_decompose)
void asm_poly_decompose(int32_t a[N], int32_t b[N], const int32_t c[N]);

#define asm_poly_shiftl DILITHIUM_NAMESPACE(asm_poly_shiftl)
void asm_poly_shiftl(int32_t a[N]);


#define asm_reduce32 DILITHIUM_NAMESPACE(asm_reduce32)
void asm_reduce32(int32_t a[N]);
#define small_asm_reduce32_central DILITHIUM_NAMESPACE(small_asm_reduce32_central)
void small_asm_reduce32_central(int32_t a[N]);
#define asm_caddq DILITHIUM_NAMESPACE(asm_caddq)
void asm_caddq(int32_t a[N]);
#define asm_freeze DILITHIUM_NAMESPACE(asm_freeze)
void asm_freeze(int32_t a[N]);
#define asm_rej_uniform DILITHIUM_NAMESPACE(asm_rej_uniform)
unsigned int asm_rej_uniform(int32_t *a,
                         unsigned int len,
                         const unsigned char *buf,
                         unsigned int buflen);

#endif
