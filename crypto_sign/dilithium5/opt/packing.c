#include "params.h"
#include "packing.h"
#include "polyvec.h"
#include "poly.h"

/*************************************************
* Name:        pack_pk
*
* Description: Bit-pack public key pk = (rho, t1).
*
* Arguments:   - uint8_t pk[]: output byte array
*              - const uint8_t rho[]: byte array containing rho
*              - const polyveck *t1: pointer to vector t1
**************************************************/
void pack_pk(uint8_t pk[CRYPTO_PUBLICKEYBYTES],
             const uint8_t rho[SEEDBYTES],
             const polyveck *t1)
{
  unsigned int i;

  for(i = 0; i < SEEDBYTES; ++i)
    pk[i] = rho[i];
  pk += SEEDBYTES;

  for(i = 0; i < K; ++i)
    polyt1_pack(pk + i*POLYT1_PACKEDBYTES, &t1->vec[i]);
}

/*************************************************
* Name:        pack_pk_rho
*
* Description: Bit-pack only rho in public key pk = (rho, t1).
*
* Arguments:   - unsigned char pk[]: output byte array
*              - const unsigned char rho[]: byte array containing rho
**************************************************/
void pack_pk_rho(unsigned char pk[CRYPTO_PUBLICKEYBYTES],
                 const unsigned char rho[SEEDBYTES]) {
    for (unsigned int i = 0; i < SEEDBYTES; ++i) {
        pk[i] = rho[i];
    }
}

/*************************************************
* Name:        pack_pk_t1
*
* Description: Bit-pack only the t1 elem at idx in public key pk = (rho, t1).
*
* Arguments:   - unsigned char pk[]: output byte array
*              - const polyveck *t1: pointer to vector t1
*              - const unsigned int idx: index to the elem to pack
**************************************************/
void pack_pk_t1(unsigned char pk[CRYPTO_PUBLICKEYBYTES],
             const poly *t1,
             const unsigned int idx) {
    pk += SEEDBYTES;
    polyt1_pack(pk + idx * POLYT1_PACKEDBYTES, t1);
}
void pack_pk_t1_compact(unsigned char pk[CRYPTO_PUBLICKEYBYTES],
             const int16_t t1[N],
             const unsigned int idx) {
    pk += SEEDBYTES;
    polyt1_pack_compact(pk + idx * POLYT1_PACKEDBYTES, t1);
}
/*************************************************
* Name:        unpack_pk
*
* Description: Unpack public key pk = (rho, t1).
*
* Arguments:   - const uint8_t rho[]: output byte array for rho
*              - const polyveck *t1: pointer to output vector t1
*              - uint8_t pk[]: byte array containing bit-packed pk
**************************************************/
void unpack_pk(uint8_t rho[SEEDBYTES],
               polyveck *t1,
               const uint8_t pk[CRYPTO_PUBLICKEYBYTES])
{
  unsigned int i;

  for(i = 0; i < SEEDBYTES; ++i)
    rho[i] = pk[i];
  pk += SEEDBYTES;

  for(i = 0; i < K; ++i)
    polyt1_unpack(&t1->vec[i], pk + i*POLYT1_PACKEDBYTES);
}

/*************************************************
* Name:        pack_sk
*
* Description: Bit-pack secret key sk = (rho, tr, key, t0, s1, s2).
*
* Arguments:   - uint8_t sk[]: output byte array
*              - const uint8_t rho[]: byte array containing rho
*              - const uint8_t tr[]: byte array containing tr
*              - const uint8_t key[]: byte array containing key
*              - const polyveck *t0: pointer to vector t0
*              - const polyvecl *s1: pointer to vector s1
*              - const polyveck *s2: pointer to vector s2
**************************************************/
void pack_sk(uint8_t sk[CRYPTO_SECRETKEYBYTES],
             const uint8_t rho[SEEDBYTES],
             const uint8_t tr[SEEDBYTES],
             const uint8_t key[SEEDBYTES],
             const polyveck *t0,
             const polyvecl *s1,
             const polyveck *s2)
{
  unsigned int i;

  for(i = 0; i < SEEDBYTES; ++i)
    sk[i] = rho[i];
  sk += SEEDBYTES;

  for(i = 0; i < SEEDBYTES; ++i)
    sk[i] = key[i];
  sk += SEEDBYTES;

  for(i = 0; i < SEEDBYTES; ++i)
    sk[i] = tr[i];
  sk += SEEDBYTES;

  for(i = 0; i < L; ++i)
    polyeta_pack(sk + i*POLYETA_PACKEDBYTES, &s1->vec[i]);
  sk += L*POLYETA_PACKEDBYTES;

  for(i = 0; i < K; ++i)
    polyeta_pack(sk + i*POLYETA_PACKEDBYTES, &s2->vec[i]);
  sk += K*POLYETA_PACKEDBYTES;

  for(i = 0; i < K; ++i)
    polyt0_pack(sk + i*POLYT0_PACKEDBYTES, &t0->vec[i]);
}

/*************************************************
* Name:        pack_sk_s1
*
* Description: Bit-pack only some element of s1 in secret key sk = (rho, key, tr, s1, s2, t0).
*
* Arguments:   - unsigned char sk[]: output byte array
*              - const poly *s1_elem: pointer to vector element idx in s1
*              - const unisgned int idx: index to the element of s1 that should be packed
**************************************************/
void pack_sk_s1(unsigned char sk[CRYPTO_SECRETKEYBYTES],
                const poly *s1_elem,
                const unsigned int idx) {
    sk += 3 * SEEDBYTES;
    polyeta_pack(sk + idx * POLYETA_PACKEDBYTES, s1_elem);
}

/*************************************************
* Name:        pack_sk_s2
*
* Description: Bit-pack only some element of s2 in secret key sk = (rho, key, tr, s1, s2, t0).
*
* Arguments:   - unsigned char sk[]: output byte array
*              - const poly *s2_elem: pointer to vector element idx in s2
*              - const unsigned int idx: index to the element of s1 that should be packed
**************************************************/
void pack_sk_s2(unsigned char sk[CRYPTO_SECRETKEYBYTES],
                const poly *s2_elem,
                const unsigned int idx) {
    sk += 3 * SEEDBYTES + L * POLYETA_PACKEDBYTES;
    polyeta_pack(sk + idx * POLYETA_PACKEDBYTES, s2_elem);
}

/*************************************************
* Name:        pack_sk_t0
*
* Description: Bit-pack only some element of t0 in secret key sk = (rho, key, tr, s1, s2, t0).
*
* Arguments:   - unsigned char sk[]: output byte array
*              - const poly *t0_elem: pointer to vector element idx in s2
*              - const unsigned int idx: index to the element of s1 that should be packed
**************************************************/
void pack_sk_t0(unsigned char sk[CRYPTO_SECRETKEYBYTES],
                const poly *t0_elem,
                const unsigned int idx) {
    sk += 3 * SEEDBYTES + L * POLYETA_PACKEDBYTES + K * POLYETA_PACKEDBYTES;
    polyt0_pack(sk + idx * POLYT0_PACKEDBYTES, t0_elem);
}
void pack_sk_t0_compact(unsigned char sk[CRYPTO_SECRETKEYBYTES],
                const int16_t t0_elem[N],
                const unsigned int idx) {
    sk += 3 * SEEDBYTES + L * POLYETA_PACKEDBYTES + K * POLYETA_PACKEDBYTES;
    polyt0_pack_compact(sk + idx * POLYT0_PACKEDBYTES, t0_elem);
}
/*************************************************
* Name:        pack_sk_rho
*
* Description: Bit-pack only rho in secret key sk = (rho, key, tr, s1, s2, t0).
*
* Arguments:   - unsigned char sk[]: output byte array
*              - const unsigned char rho[]: byte array containing rho
**************************************************/
void pack_sk_rho(unsigned char sk[CRYPTO_SECRETKEYBYTES],
                 const unsigned char rho[SEEDBYTES]) {
  for (unsigned int i = 0; i < SEEDBYTES; ++i) {
    sk[i] = rho[i];
  }
}

/*************************************************
* Name:        pack_sk_key
*
* Description: Bit-pack only key in secret key sk = (rho, key, tr, s1, s2, t0).
*
* Arguments:   - unsigned char sk[]: output byte array
*              - const unsigned char key[]: byte array containing key
**************************************************/
void pack_sk_key(unsigned char sk[CRYPTO_SECRETKEYBYTES],
                 const unsigned char key[SEEDBYTES]) {
    sk += SEEDBYTES;
    for (unsigned int i = 0; i < SEEDBYTES; ++i) {
      sk[i] = key[i];
    }
}

/*************************************************
* Name:        pack_sk_tr
*
* Description: Bit-pack only tr in secret key sk = (rho, key, tr, s1, s2, t0).
*
* Arguments:   - unsigned char sk[]: output byte array
*              - const unsigned char tr[]: byte array containing tr
**************************************************/
void pack_sk_tr(unsigned char sk[CRYPTO_SECRETKEYBYTES],
                const unsigned char tr[SEEDBYTES]) {
    sk += 2*SEEDBYTES;
    for (unsigned int i = 0; i < SEEDBYTES; ++i) {
        sk[i] = tr[i];
    }
}

/*************************************************
* Name:        unpack_sk
*
* Description: Unpack secret key sk = (rho, tr, key, t0, s1, s2).
*
* Arguments:   - const uint8_t rho[]: output byte array for rho
*              - const uint8_t tr[]: output byte array for tr
*              - const uint8_t key[]: output byte array for key
*              - const polyveck *t0: pointer to output vector t0
*              - const polyvecl *s1: pointer to output vector s1
*              - const polyveck *s2: pointer to output vector s2
*              - uint8_t sk[]: byte array containing bit-packed sk
**************************************************/
void unpack_sk(uint8_t rho[SEEDBYTES],
               uint8_t tr[SEEDBYTES],
               uint8_t key[SEEDBYTES],
               polyveck *t0,
               smallpoly s1[L],
               smallpoly s2[K],
               const uint8_t sk[CRYPTO_SECRETKEYBYTES])
{
  unsigned int i;

  for(i = 0; i < SEEDBYTES; ++i)
    rho[i] = sk[i];
  sk += SEEDBYTES;

  for(i = 0; i < SEEDBYTES; ++i)
    key[i] = sk[i];
  sk += SEEDBYTES;

  for(i = 0; i < SEEDBYTES; ++i)
    tr[i] = sk[i];
  sk += SEEDBYTES;

  for(i=0; i < L; ++i)
    small_polyeta_unpack(&s1[i], sk + i*POLYETA_PACKEDBYTES);
  sk += L*POLYETA_PACKEDBYTES;

  for(i=0; i < K; ++i)
    small_polyeta_unpack(&s2[i], sk + i*POLYETA_PACKEDBYTES);
  sk += K*POLYETA_PACKEDBYTES;

  for(i=0; i < K; ++i)
    polyt0_unpack(&t0->vec[i], sk + i*POLYT0_PACKEDBYTES);
}
void unpack_sk_sparse(uint8_t rho[SEEDBYTES],
               uint8_t tr[SEEDBYTES],
               uint8_t key[SEEDBYTES],
               polyveck *t0,
               int8_t s1[L][2*N],
               int8_t s2[K][2*N],
               const uint8_t sk[CRYPTO_SECRETKEYBYTES])
{
  unsigned int i;

  for(i = 0; i < SEEDBYTES; ++i)
    rho[i] = sk[i];
  sk += SEEDBYTES;

  for(i = 0; i < SEEDBYTES; ++i)
    key[i] = sk[i];
  sk += SEEDBYTES;

  for(i = 0; i < SEEDBYTES; ++i)
    tr[i] = sk[i];
  sk += SEEDBYTES;

  for(i=0; i < L; ++i)
    sparse_polyeta_unpack(s1[i], sk + i*POLYETA_PACKEDBYTES);
  sk += L*POLYETA_PACKEDBYTES;

  for(i=0; i < K; ++i)
    sparse_polyeta_unpack(s2[i], sk + i*POLYETA_PACKEDBYTES);
  sk += K*POLYETA_PACKEDBYTES;

  for(i=0; i < K; ++i)
    polyt0_unpack(&t0->vec[i], sk + i*POLYT0_PACKEDBYTES);
}

/*************************************************
* Name:        pack_sig
*
* Description: Bit-pack signature sig = (c, z, h).
*
* Arguments:   - uint8_t sig[]: output byte array
*              - const uint8_t *c: pointer to challenge hash length SEEDBYTES
*              - const polyvecl *z: pointer to vector z
*              - const polyveck *h: pointer to hint vector h
**************************************************/
void pack_sig(uint8_t sig[CRYPTO_BYTES],
              const uint8_t c[SEEDBYTES],
              const polyvecl *z,
              const polyveck *h)
{
  unsigned int i, j, k;

  for(i=0; i < SEEDBYTES; ++i)
    sig[i] = c[i];
  sig += SEEDBYTES;

  for(i = 0; i < L; ++i)
    polyz_pack(sig + i*POLYZ_PACKEDBYTES, &z->vec[i]);
  sig += L*POLYZ_PACKEDBYTES;

  /* Encode h */
  for(i = 0; i < OMEGA + K; ++i)
    sig[i] = 0;

  k = 0;
  for(i = 0; i < K; ++i) {
    for(j = 0; j < N; ++j)
      if(h->vec[i].coeffs[j] != 0)
        sig[k++] = j;

    sig[OMEGA + i] = k;
  }
}

void pack_sig_c(uint8_t sig[CRYPTO_BYTES],
              const uint8_t c[SEEDBYTES])
{
  unsigned int i;

  for(i=0; i < SEEDBYTES; ++i)
    sig[i] = c[i];
  sig += SEEDBYTES;
}

void pack_sig_z(uint8_t sig[CRYPTO_BYTES],
              const polyvecl *z)
{
  unsigned int i;
  sig += SEEDBYTES;
  for(i = 0; i < L; ++i)
    polyz_pack(sig + i*POLYZ_PACKEDBYTES, &z->vec[i]);
}


void pack_sig_h(unsigned char sig[CRYPTO_BYTES],
                const poly *h_elem,
                const unsigned int idx,
                unsigned int *hints_written)
{
  sig += SEEDBYTES;
  sig += L*POLYZ_PACKEDBYTES;

  // Encode h
  for (unsigned int j = 0; j < N; j++) {
      if (h_elem->coeffs[j] != 0) {
          sig[*hints_written] = (uint8_t)j;
          (*hints_written)++;
      }
  }
  sig[OMEGA + idx] = (uint8_t)*hints_written;
}

void pack_sig_h_zero(unsigned char sig[CRYPTO_BYTES],
                unsigned int *hints_written) {
    sig += SEEDBYTES;
    sig += L * POLYZ_PACKEDBYTES;
    while (*hints_written < OMEGA) {
        sig[*hints_written] = 0;
        (*hints_written)++;
    }
}

/*************************************************
* Name:        unpack_sig
*
* Description: Unpack signature sig = (c, z, h).
*
* Arguments:   - uint8_t *c: pointer to output challenge hash
*              - polyvecl *z: pointer to output vector z
*              - polyveck *h: pointer to output hint vector h
*              - const uint8_t sig[]: byte array containing
*                bit-packed signature
*
* Returns 1 in case of malformed signature; otherwise 0.
**************************************************/
int unpack_sig(uint8_t c[SEEDBYTES],
               polyvecl *z,
               polyveck *h,
               const uint8_t sig[CRYPTO_BYTES])
{
  unsigned int i, j, k;

  for(i = 0; i < SEEDBYTES; ++i)
    c[i] = sig[i];
  sig += SEEDBYTES;

  for(i = 0; i < L; ++i)
    polyz_unpack(&z->vec[i], sig + i*POLYZ_PACKEDBYTES);
  sig += L*POLYZ_PACKEDBYTES;

  /* Decode h */
  k = 0;
  for(i = 0; i < K; ++i) {
    for(j = 0; j < N; ++j)
      h->vec[i].coeffs[j] = 0;

    if(sig[OMEGA + i] < k || sig[OMEGA + i] > OMEGA)
      return 1;

    for(j = k; j < sig[OMEGA + i]; ++j) {
      /* Coefficients are ordered for strong unforgeability */
      if(j > k && sig[j] <= sig[j-1]) return 1;
      h->vec[i].coeffs[sig[j]] = 1;
    }

    k = sig[OMEGA + i];
  }

  /* Extra indices are zero for strong unforgeability */
  for(j = k; j < OMEGA; ++j)
    if(sig[j])
      return 1;

  return 0;
}
int unpack_sig_compact(uint8_t c[SEEDBYTES],
               polyvecl *z, uint8_t *h, 
               const uint8_t sig[CRYPTO_BYTES])
{
  unsigned int i,j,k;

  for(i = 0; i < SEEDBYTES; ++i)
    c[i] = sig[i];
  sig += SEEDBYTES;

  for(i = 0; i < L; ++i)
    polyz_unpack(&z->vec[i], sig + i*POLYZ_PACKEDBYTES);
  sig += L*POLYZ_PACKEDBYTES;

  /* Decode h */
  k = 0;
  for(i = 0; i < K; ++i) {
    // for(j = 0; j < N; ++j)
    //   h->vec[i].coeffs[j] = 0;
    if(sig[OMEGA + i] < k || sig[OMEGA + i] > OMEGA)
      return 1;

    for(j = k; j < sig[OMEGA + i]; ++j) {
      /* Coefficients are ordered for strong unforgeability */
      if(j > k && sig[j] <= sig[j-1]) return 1;
      h[32*i + (sig[j] >> 3)] |=  (1 << (sig[j] & 0x7));
      // h->vec[i].coeffs[sig[j]] = 1;
      // h[i][sig[j]]=1;
    }

    k = sig[OMEGA + i];
  }

  /* Extra indices are zero for strong unforgeability */
  for(j = k; j < OMEGA; ++j)
    if(sig[j])
      return 1;

  return 0;
}
