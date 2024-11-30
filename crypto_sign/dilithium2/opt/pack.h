#ifndef PACK_H
#define PACK_H

#include <stdint.h>
#include "params.h"

#define asm_polyeta2_pack DILITHIUM_NAMESPACE(asm_polyeta2_pack)
void asm_polyeta2_pack(uint8_t *r, const int32_t a[N]);

#define asm_polyeta4_pack DILITHIUM_NAMESPACE(asm_polyeta4_pack)
void asm_polyeta4_pack(uint8_t *r, const int32_t a[N]);

#define asm_polyt1_pack_compact DILITHIUM_NAMESPACE(asm_polyt1_pack_compact)
void asm_polyt1_pack_compact(uint8_t *r,const int16_t a[N]);

#define asm_polyt1_unpack DILITHIUM_NAMESPACE(asm_polyt1_unpack)
void asm_polyt1_unpack(poly *r, const uint8_t *a);


#define asm_polyt0_pack_compact DILITHIUM_NAMESPACE(asm_polyt0_pack_compact)
void asm_polyt0_pack_compact(uint8_t *r, const int16_t a[N]);

#define asm_polyt0_unpack DILITHIUM_NAMESPACE(asm_polyt0_unpack)
void asm_polyt0_unpack(poly *r, const uint8_t *a);


#define asm_sparse_polyeta4_unpack DILITHIUM_NAMESPACE(asm_sparse_polyeta4_unpack)
void asm_sparse_polyeta4_unpack(int8_t r[2*N], const uint8_t *a) ;


#define asm_sparse_polyeta_unpack DILITHIUM_NAMESPACE(asm_sparse_polyeta_unpack)
void asm_sparse_polyeta_unpack(int8_t r[2*N], const uint8_t *a) ;
#endif
