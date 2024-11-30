#include <stdint.h>
#include "params.h"
#include "sign.h"
#include "packing.h"
#include "polyvec.h"
#include "poly.h"
#include "randombytes.h"
#include "symmetric.h"
#include "smallpoly.h"
#include "sparse.h"
#include <string.h>
/*************************************************
* Name:        crypto_sign_keypair
*
* Description: Generates public and private key.
*
* Arguments:   - uint8_t *pk: pointer to output public key (allocated
*                             array of CRYPTO_PUBLICKEYBYTES bytes)
*              - uint8_t *sk: pointer to output private key (allocated
*                             array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 (success)
**************************************************/

int crypto_sign_keypair(uint8_t *pk, uint8_t *sk) {
  unsigned int i, j;
  uint8_t seedbuf[2*SEEDBYTES + CRHBYTES];
  uint8_t tr[SEEDBYTES];
  const uint8_t *rho, *rhoprime, *key;
  uint16_t nonce = 0;
  polyvecl s1;
  poly s2, t1;

  /* Get randomness for rho, rhoprime and key */
  randombytes(seedbuf, SEEDBYTES);
  shake256(seedbuf, 2*SEEDBYTES + CRHBYTES, seedbuf, SEEDBYTES);
  rho = seedbuf;
  rhoprime = rho + SEEDBYTES;
  key = rhoprime + CRHBYTES;

  pack_sk_rho(sk, rho);
  pack_sk_key(sk, key);
  pack_pk_rho(pk, rho);

  /* Sample short vector s1 and immediately store its time-domain version */
  for (i = 0; i < L; i++)
  {
    poly_uniform_eta(&s1.vec[i], rhoprime, nonce++);
    pack_sk_s1(sk, &s1.vec[i], i);
    /* Move s1 to NTT domain */
    new_ntt(s1.vec[i].coeffs);
  }

  /* Matrix-vector multiplication */
  for (i = 0; i < K; i++)
  {
    {
      /* expand part of the matrix */
      poly_uniform(&s2, rho, (i << 8) + 0);
      /* partial matrix-vector multiplication */
      poly_pointwise_montgomery(&t1, &s2, &s1.vec[0]);
      for(j = 1; j < L; j++)
      {
        poly_uniform(&s2, rho, (i << 8) + j);
        poly_pointwise_acc_montgomery(&t1, &s2, &s1.vec[j]);
      }
    }
    poly_reduce(&t1);
    poly_invntt_tomont(&t1);


    /* Add error vector s2 */
    {
      // poly s2;
      /* Sample short vector s2 */
      poly_uniform_eta(&s2, rhoprime, L+i);
      pack_sk_s2(sk, &s2, i);
      poly_add(&t1, &t1, &s2);
    }

    /* Compute t{0,1} */
    {
      // poly t1, t0;
      int16_t t1_compact[N], t0_compact[N];
      poly_caddq(&t1);
      // poly_power2round(&t1, &s2, &t1);
      poly_power2round_compact(t1_compact, t0_compact, &t1);
      // pack_sk_t0(sk, &s2, i);
      // pack_pk_t1(pk, &t1, i);
      pack_sk_t0_compact(sk, t0_compact, i);
      pack_pk_t1_compact(pk, t1_compact, i);
    }
  }

  /* Compute H(rho, t1) and write secret key */
  shake256(tr, SEEDBYTES, pk, CRYPTO_PUBLICKEYBYTES);
  pack_sk_tr(sk, tr);

  return 0;
}

/*************************************************
* Name:        crypto_sign_signature
*
* Description: Computes signature.
*
* Arguments:   - uint8_t *sig:   pointer to output signature (of length CRYPTO_BYTES)
*              - size_t *siglen: pointer to output length of signature
*              - uint8_t *m:     pointer to message to be signed
*              - size_t mlen:    length of message
*              - uint8_t *sk:    pointer to bit-packed secret key
*
* Returns 0 (success)
**************************************************/

int crypto_sign_signature(uint8_t *sig,
                          size_t *siglen,
                          const uint8_t *m,
                          size_t mlen,
                          const uint8_t *sk)
{
  uint8_t seedbuf[3*SEEDBYTES + 2*CRHBYTES];
  uint8_t *rho, *tr, *key, *mu, *rhoprime;
  uint16_t nonce = 0;
  polyvecl mat[K], y, z;
  polyveck t0, w1, w0;
  poly cp;
  shake256incctx state;
  int i, j;
  int8_t s1_sparse[L][2*N] = {0};
  int8_t s2_sparse[K][2*N] = {0};
  
  int8_t cs[N] = {0};

  rho = seedbuf;
  tr = rho + SEEDBYTES;
  key = tr + SEEDBYTES;
  mu = key + SEEDBYTES;
  rhoprime = mu + CRHBYTES;
  unpack_sk_sparse(rho, tr, key, &t0, s1_sparse, s2_sparse, sk);
  for(i = 0; i < L; i ++)
  {
    prepare_table_asm(s1_sparse[i]);
  }
  for(i = 0; i < K; i ++)
  {
    prepare_table_asm(s2_sparse[i]);
  }
  /* Compute CRH(tr, msg) */
  shake256_inc_init(&state);
  shake256_inc_absorb(&state, tr, SEEDBYTES);
  shake256_inc_absorb(&state, m, mlen);
  shake256_inc_finalize(&state);
  shake256_inc_squeeze(mu, CRHBYTES, &state);

#ifdef DILITHIUM_RANDOMIZED_SIGNING
  randombytes(rhoprime, CRHBYTES);
#else
  shake256(rhoprime, CRHBYTES, key, SEEDBYTES + CRHBYTES);
#endif

  /* Expand matrix and transform vectors */
  polyvec_matrix_expand(mat, rho);

  polyveck_ntt(&t0);

rej:
  /* Sample intermediate vector y */
  polyvecl_uniform_gamma1(&y, rhoprime, nonce++);

  /* Matrix-vector multiplication */
  z = y;
  polyvecl_ntt(&z);
  polyvec_matrix_pointwise_montgomery(&w1, mat, &z);
  polyveck_reduce(&w1);
  polyveck_invntt_tomont(&w1);

  /* Decompose w and call the random oracle */
  polyveck_caddq(&w1);
  polyveck_decompose(&w1, &w0, &w1);
  polyveck_pack_w1(sig, &w1);

  shake256_inc_init(&state);
  shake256_inc_absorb(&state, mu, CRHBYTES);
  shake256_inc_absorb(&state, sig, K*POLYW1_PACKEDBYTES);
  shake256_inc_finalize(&state);
  shake256_inc_squeeze(sig, SEEDBYTES, &state);
  poly_challenge(&cp, sig);
  //encode cp
  uint8_t pos_neg_list[TAU+1];
  int pos_ptr = 1, neg_ptr = TAU;
  for(i = 0; i < N; i ++)
  {
    if(cp.coeffs[i]==1)
    {
      pos_neg_list[pos_ptr++] = i;
    }
    if(cp.coeffs[i]==-1)
    {
      pos_neg_list[neg_ptr--] = i;
    }
  }
  pos_neg_list[0] = pos_ptr-1;
  //ntt(cp) for ct0
  poly_ntt(&cp);

  /* Compute z, reject if it reveals secret */
  
  
  unsigned int hint_n = 0;
  unsigned int hints_written = 0;
  /* Check that subtracting cs2 does not change high bits of w and low bits
   * do not reveal secret information */
  //check r0
  for(i = 0; i < K; ++i) {
    memset(cs, 0, sizeof(cs));
    sparse_polymul(cs, pos_neg_list, s2_sparse[i]);
    for(j = 0; j < N; j ++)
    {
      w0.vec[i].coeffs[j] = w0.vec[i].coeffs[j] - cs[j];
      if(w0.vec[i].coeffs[j]>= GAMMA2 - BETA || w0.vec[i].coeffs[j]<= BETA - GAMMA2)
      {
        goto rej;
      }
    }
    poly *tmp = &z.vec[0];
    /* Compute hints for w1 */
    poly_pointwise_montgomery(tmp, &cp, &t0.vec[i]);

    poly_invntt_tomont(tmp);
    poly_reduce(tmp);

    if(poly_chknorm(tmp, GAMMA2))
      goto rej;
    poly_add(&w0.vec[i], &w0.vec[i], tmp);
    hint_n += poly_make_hint(tmp, &w0.vec[i], &w1.vec[i]);
    if (hint_n > OMEGA) {
      goto rej;
    }
    pack_sig_h(sig, tmp, i, &hints_written);
  }
  //check z
  for(i = 0; i < L; i ++)
  {
    memset(cs, 0, sizeof(cs));
    //cs1
    sparse_polymul(cs, pos_neg_list, s1_sparse[i]);
    for(j = 0; j < N; j ++)
    {
      //z = y + cs1
      z.vec[i].coeffs[j] = cs[j] + y.vec[i].coeffs[j];
      if(z.vec[i].coeffs[j]>=GAMMA1 - BETA || z.vec[i].coeffs[j]<= BETA - GAMMA1)
      {
        goto rej;
      }
    }
  }
  /* Write signature */
  pack_sig_z(sig, &z);
  pack_sig_h_zero(sig, &hints_written);
  *siglen = CRYPTO_BYTES;
  return 0;
}

int crypto_sign_signature_compact(uint8_t *sig,
                          size_t *siglen,
                          const uint8_t *m,
                          size_t mlen,
                          const uint8_t *sk)
{
  uint8_t seedbuf[3*SEEDBYTES + 2*CRHBYTES];
  uint8_t *rho, *tr, *key, *mu, *rhoprime;
  uint16_t nonce = 0;
  polyvecl mat[K], y, z;
  polyveck t0, w0;
  poly cp;
  shake256incctx state;
  int i, j;
  int8_t s1_sparse[L][2*N] = {0};
  int8_t s2_sparse[K][2*N] = {0};
  
  int8_t cs[N] = {0};

  poly polytemp1;
  uint8_t flag[N*K];

  rho = seedbuf;
  tr = rho + SEEDBYTES;
  key = tr + SEEDBYTES;
  mu = key + SEEDBYTES;
  rhoprime = mu + CRHBYTES;
  unpack_sk_sparse(rho, tr, key, &t0, s1_sparse, s2_sparse, sk);
  for(i = 0; i < L; i ++)
  {
    prepare_table_asm(s1_sparse[i]);
  }
  for(i = 0; i < K; i ++)
  {
    prepare_table_asm(s2_sparse[i]);
  }
  /* Compute CRH(tr, msg) */
  shake256_inc_init(&state);
  shake256_inc_absorb(&state, tr, SEEDBYTES);
  shake256_inc_absorb(&state, m, mlen);
  shake256_inc_finalize(&state);
  shake256_inc_squeeze(mu, CRHBYTES, &state);

#ifdef DILITHIUM_RANDOMIZED_SIGNING
  randombytes(rhoprime, CRHBYTES);
#else
  shake256(rhoprime, CRHBYTES, key, SEEDBYTES + CRHBYTES);
#endif

  /* Expand matrix and transform vectors */
  polyvec_matrix_expand(mat, rho);

  polyveck_ntt(&t0);

rej:


  /* Sample intermediate vector y */
  for(i = 0; i < L; ++i)
    poly_uniform_gamma1(y.vec + i, rhoprime, L*nonce + i);
  nonce++;
  /* Matrix-vector multiplication */
  z = y;
  polyvecl_ntt(&z);
  uint8_t *buf = sig;
  for(i = 0; i < K; ++i) {
    polyvecl_pointwise_acc_montgomery(&cp, &mat[i], &z);
    poly_reduce(&cp);
    poly_invntt_tomont(&cp);
    poly_caddq(&cp);
    poly_decompose_flag(&polytemp1, w0.vec + i, flag + i*N, &cp);
    polyw1_pack(buf + i*POLYW1_PACKEDBYTES, &polytemp1);
  }



  shake256_inc_init(&state);
  shake256_inc_absorb(&state, mu, CRHBYTES);
  shake256_inc_absorb(&state, sig, K*POLYW1_PACKEDBYTES);
  shake256_inc_finalize(&state);
  shake256_inc_squeeze(sig, SEEDBYTES, &state);
  poly_challenge(&cp, sig);
  //encode cp
  uint8_t pos_neg_list[TAU+1];
  int pos_ptr = 1, neg_ptr = TAU;
  for(i = 0; i < N; i ++)
  {
    if(cp.coeffs[i]==1)
    {
      pos_neg_list[pos_ptr++] = i;
    }
    if(cp.coeffs[i]==-1)
    {
      pos_neg_list[neg_ptr--] = i;
    }
  }
  pos_neg_list[0] = pos_ptr-1;
  //ntt(cp) for ct0
  poly_ntt(&cp);

  /* Compute z, reject if it reveals secret */
  
  
  unsigned int hint_n = 0;
  unsigned int hints_written = 0;
  /* Check that subtracting cs2 does not change high bits of w and low bits
   * do not reveal secret information */
  //check r0
  for(i = 0; i < K; ++i) {
    memset(cs, 0, sizeof(cs));
    sparse_polymul(cs, pos_neg_list, s2_sparse[i]);
    for(j = 0; j < N; j ++)
    {
      w0.vec[i].coeffs[j] = w0.vec[i].coeffs[j] - cs[j];
      if(w0.vec[i].coeffs[j]>= GAMMA2 - BETA || w0.vec[i].coeffs[j]<= BETA - GAMMA2)
      {
        goto rej;
      }
    }
    poly *tmp = &z.vec[0];
    /* Compute hints for w1 */
    poly_pointwise_montgomery(tmp, &cp, &t0.vec[i]);

    poly_invntt_tomont(tmp);
    poly_reduce(tmp);

    if(poly_chknorm(tmp, GAMMA2))
      goto rej;
    poly_add(&w0.vec[i], &w0.vec[i], tmp);
    // hint_n += poly_make_hint(tmp, &w0.vec[i], &w1.vec[i]);
     hint_n += poly_make_hint_flag(tmp, &w0.vec[i], flag + N * i);
    if (hint_n > OMEGA) {
      goto rej;
    }
    pack_sig_h(sig, tmp, i, &hints_written);
  }
  //check z
  for(i = 0; i < L; i ++)
  {
    memset(cs, 0, sizeof(cs));
    //cs1
    sparse_polymul(cs, pos_neg_list, s1_sparse[i]);
    for(j = 0; j < N; j ++)
    {
      //z = y + cs1
      z.vec[i].coeffs[j] = cs[j] + y.vec[i].coeffs[j];
      if(z.vec[i].coeffs[j]>=GAMMA1 - BETA || z.vec[i].coeffs[j]<= BETA - GAMMA1)
      {
        goto rej;
      }
    }
  }
  /* Write signature */
  pack_sig_z(sig, &z);
  pack_sig_h_zero(sig, &hints_written);
  *siglen = CRYPTO_BYTES;
  return 0;
}



/*************************************************
* Name:        crypto_sign
*
* Description: Compute signed message.
*
* Arguments:   - uint8_t *sm: pointer to output signed message (allocated
*                             array with CRYPTO_BYTES + mlen bytes),
*                             can be equal to m
*              - size_t *smlen: pointer to output length of signed
*                               message
*              - const uint8_t *m: pointer to message to be signed
*              - size_t mlen: length of message
*              - const uint8_t *sk: pointer to bit-packed secret key
*
* Returns 0 (success)
**************************************************/
int crypto_sign(uint8_t *sm,
                size_t *smlen,
                const uint8_t *m,
                size_t mlen,
                const uint8_t *sk)
{
  size_t i;

  for(i = 0; i < mlen; ++i)
    sm[CRYPTO_BYTES + mlen - 1 - i] = m[mlen - 1 - i];
  crypto_sign_signature(sm, smlen, sm + CRYPTO_BYTES, mlen, sk);
  *smlen += mlen;
  return 0;
}
int crypto_sign_compact(uint8_t *sm,
                size_t *smlen,
                const uint8_t *m,
                size_t mlen,
                const uint8_t *sk)
{
  size_t i;

  for(i = 0; i < mlen; ++i)
    sm[CRYPTO_BYTES + mlen - 1 - i] = m[mlen - 1 - i];
  crypto_sign_signature_compact(sm, smlen, sm + CRYPTO_BYTES, mlen, sk);
  *smlen += mlen;
  return 0;
}

/*************************************************
* Name:        crypto_sign_verify
*
* Description: Verifies signature.
*
* Arguments:   - uint8_t *m: pointer to input signature
*              - size_t siglen: length of signature
*              - const uint8_t *m: pointer to message
*              - size_t mlen: length of message
*              - const uint8_t *pk: pointer to bit-packed public key
*
* Returns 0 if signature could be verified correctly and -1 otherwise
**************************************************/
int crypto_sign_verify(const uint8_t *sig,
                       size_t siglen,
                       const uint8_t *m,
                       size_t mlen,
                       const uint8_t *pk)
{
  unsigned int i;
  uint8_t buf[K*POLYW1_PACKEDBYTES];
  uint8_t rho[SEEDBYTES];
  uint8_t mu[CRHBYTES];
  uint8_t c[SEEDBYTES];
  uint8_t c2[SEEDBYTES];
  poly cp;
  polyvecl mat[K], z;
  polyveck t1, w1, h;
  shake256incctx state;

  if(siglen != CRYPTO_BYTES)
    return -1;

  unpack_pk(rho, &t1, pk);
  if(unpack_sig(c, &z, &h, sig))
    return -1;
  if(polyvecl_chknorm(&z, GAMMA1 - BETA))
    return -1;

  /* Compute CRH(h(rho, t1), msg) */
  shake256(mu, SEEDBYTES, pk, CRYPTO_PUBLICKEYBYTES);
  shake256_inc_init(&state);
  shake256_inc_absorb(&state, mu, SEEDBYTES);
  shake256_inc_absorb(&state, m, mlen);
  shake256_inc_finalize(&state);
  shake256_inc_squeeze(mu, CRHBYTES, &state);

  /* Matrix-vector multiplication; compute Az - c2^dt1 */
  poly_challenge(&cp, c);
  polyvec_matrix_expand(mat, rho);

  polyvecl_ntt(&z);
  polyvec_matrix_pointwise_montgomery(&w1, mat, &z);

  new_ntt(cp.coeffs);
  polyveck_shiftl(&t1);
  polyveck_ntt(&t1);
  polyveck_pointwise_poly_montgomery(&t1, &cp, &t1);

  polyveck_sub(&w1, &w1, &t1);
  polyveck_reduce(&w1);
  polyveck_invntt_tomont(&w1);

  /* Reconstruct w1 */
  polyveck_caddq(&w1);
  polyveck_use_hint(&w1, &w1, &h);
  polyveck_pack_w1(buf, &w1);

  /* Call random oracle and verify challenge */
  shake256_inc_init(&state);
  shake256_inc_absorb(&state, mu, CRHBYTES);
  shake256_inc_absorb(&state, buf, K*POLYW1_PACKEDBYTES);
  shake256_inc_finalize(&state);
  shake256_inc_squeeze(c2, SEEDBYTES, &state);
  for(i = 0; i < SEEDBYTES; ++i)
    if(c[i] != c2[i])
      return -1;

  return 0;
}
int crypto_sign_verify_compact(const uint8_t *sig,
                       size_t siglen,
                       const uint8_t *m,
                       size_t mlen,
                       const uint8_t *pk)
{
  unsigned int i,j;
  uint8_t buf[K*POLYW1_PACKEDBYTES]={0};//768B
  uint8_t mu[CRHBYTES];
  uint8_t c[SEEDBYTES];
  uint8_t *tmp;
  
  polyvecl z;
  poly cp, mat, w1;
  shake256incctx state;

  if(siglen != CRYPTO_BYTES)
    return -1;
  tmp = buf + K*POLYW1_PACKEDBYTES - K*32;
  if(unpack_sig_compact(c, &z, tmp, sig))//z
    return -1;
  if(polyvecl_chknorm(&z, GAMMA1 - BETA))
    return -1;
  
  poly_challenge(&cp, c);
  new_ntt(cp.coeffs);
  polyvecl_ntt(&z);
  for(i = 0; i < K; ++i){
    poly_uniform(&mat, pk, (i << 8) + 0);
    poly_pointwise_montgomery(&w1, &mat, &z.vec[0]);
    for(j = 1; j < L; j++){
      poly_uniform(&mat, pk, (i << 8) + j);
      poly_pointwise_acc_montgomery(&w1, &mat, &z.vec[j]);
    }
    polyt1_unpack(&mat, pk + SEEDBYTES + i*POLYT1_PACKEDBYTES);
    poly_shiftl(&mat);
    poly_ntt(&mat);
    poly_pointwise_montgomery(&mat, &cp, &mat);
    poly_sub(&w1, &w1, &mat);
    poly_reduce(&w1);
    poly_invntt_tomont(&w1);
    poly_caddq(&w1);
    poly_use_hint_compact(&w1, &w1, tmp + 32 * i);
    polyw1_pack(buf + i*POLYW1_PACKEDBYTES, &w1);
  }


  /* Compute CRH(h(rho, t1), msg) */
  shake256(mu, SEEDBYTES, pk, CRYPTO_PUBLICKEYBYTES);
  shake256_inc_init(&state);
  shake256_inc_absorb(&state, mu, SEEDBYTES);
  shake256_inc_absorb(&state, m, mlen);
  shake256_inc_finalize(&state);
  shake256_inc_squeeze(mu, CRHBYTES, &state);

  /* Call random oracle and verify challenge */
  shake256_inc_init(&state);
  shake256_inc_absorb(&state, mu, CRHBYTES);
  shake256_inc_absorb(&state, buf, K*POLYW1_PACKEDBYTES);
  shake256_inc_finalize(&state);
  shake256_inc_squeeze(buf, SEEDBYTES, &state);
  for(i = 0; i < SEEDBYTES; ++i)
    if(c[i] != buf[i])
      return -1;

  return 0;
}

/*************************************************
* Name:        crypto_sign_open
*
* Description: Verify signed message.
*
* Arguments:   - uint8_t *m: pointer to output message (allocated
*                            array with smlen bytes), can be equal to sm
*              - size_t *mlen: pointer to output length of message
*              - const uint8_t *sm: pointer to signed message
*              - size_t smlen: length of signed message
*              - const uint8_t *pk: pointer to bit-packed public key
*
* Returns 0 if signed message could be verified correctly and -1 otherwise
**************************************************/
int crypto_sign_open(uint8_t *m,
                     size_t *mlen,
                     const uint8_t *sm,
                     size_t smlen,
                     const uint8_t *pk)
{
  size_t i;

  if(smlen < CRYPTO_BYTES)
    goto badsig;

  *mlen = smlen - CRYPTO_BYTES;
  if(crypto_sign_verify(sm, CRYPTO_BYTES, sm + CRYPTO_BYTES, *mlen, pk))
    goto badsig;
  else {
    /* All good, copy msg, return 0 */
    for(i = 0; i < *mlen; ++i)
      m[i] = sm[CRYPTO_BYTES + i];
    return 0;
  }

badsig:
  /* Signature verification failed */
  *mlen = -1;
  for(i = 0; i < smlen; ++i)
    m[i] = 0;

  return -1;
}
int crypto_sign_open_compact(uint8_t *m,
                     size_t *mlen,
                     const uint8_t *sm,
                     size_t smlen,
                     const uint8_t *pk)
{
  size_t i;

  if(smlen < CRYPTO_BYTES)
    goto badsig;

  *mlen = smlen - CRYPTO_BYTES;
  if(crypto_sign_verify_compact(sm, CRYPTO_BYTES, sm + CRYPTO_BYTES, *mlen, pk))
    goto badsig;
  else {
    /* All good, copy msg, return 0 */
    for(i = 0; i < *mlen; ++i)
      m[i] = sm[CRYPTO_BYTES + i];
    return 0;
  }

badsig:
  /* Signature verification failed */
  *mlen = -1;
  for(i = 0; i < smlen; ++i)
    m[i] = 0;

  return -1;
}