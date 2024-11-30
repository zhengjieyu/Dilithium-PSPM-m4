.syntax unified


//void prepare_table_asm(int8_t s[2 * N])
.global prepare_table_asm
.type prepare_table_asm,%function
.align 2
prepare_table_asm:
  ptr_s .req R0
  ptr_s2 .req R4
  pos_cnt      .req R5
  m            .req R6
  n            .req R7
  s            .req R8
  t            .req R9
  //preserve registers
  push {R4-R12, R14}
  add.w ptr_s2, ptr_s, #256
  mov.w pos_cnt, #0
  .rept 16
  ldr.w m, [ptr_s]
  ldr.w n, [ptr_s, #4]
  ldr.w s, [ptr_s, #8]
  ldr.w t, [ptr_s, #12]
  str.w m, [ptr_s2], #4
  str.w n, [ptr_s2], #4
  str.w s, [ptr_s2], #4
  str.w t, [ptr_s2], #4
  ssub8 m, pos_cnt, m
  ssub8 n, pos_cnt, n
  ssub8 s, pos_cnt, s
  ssub8 t, pos_cnt, t
  str.w m, [ptr_s], #4
  str.w n, [ptr_s], #4
  str.w s, [ptr_s], #4
  str.w t, [ptr_s], #4
  .endr
  sub.w ptr_s, #256


  pop {R4-R12, PC}


  .unreq ptr_s
  .unreq ptr_s2
  .unreq pos_cnt
  .unreq m
  .unreq n
  .unreq s
  .unreq t

.ltorg


// void sparse_polymul(int8_t ret[N], const uint8_t pos_neg_list[\tau + 1], const int8_t s[2 * N])
.global sparse_polymul
.type sparse_polymul,%function
.align 2
sparse_polymul:
  //bind aliases
  ptr_ret      .req R0
  ptr_index    .req R1
  ptr_s       .req R2
  ptr_s2       .req R3
  r_pos        .req R4
  pos_cnt      .req R5
  neg_cnt      .req R6
  pos          .req R7
  m            .req R8
  n            .req R9
  s            .req R10
  t            .req R11
  m1           .req R12
  n1           .req R14

  //preserve registers
  push {R4-R12, R14}


  ldrb pos_cnt, [ptr_index], #1
  // reverse subtraction
  rsb.w neg_cnt, pos_cnt, #49

  vmov s0, pos_cnt
  vmov s1, neg_cnt

  //处理正索引
  add.w ptr_s, #256
   .rept 10
    ldr.w ptr_s2, [ptr_ret]
    ldr.w m, [ptr_ret, #4]
    ldr.w n, [ptr_ret, #8]
    ldr.w s, [ptr_ret, #12]
    ldr.w m1, [ptr_ret, #16]
    ldr.w n1, [ptr_ret, #20]
    1:
        ldrb pos, [ptr_index], #1
        sub.w r_pos, ptr_s, pos
        ldr.w t, [r_pos], #4
        ldr.w pos, [r_pos], #4
        ldr.w neg_cnt, [r_pos], #4
        sadd8 ptr_s2, ptr_s2, t
        sadd8 m, m, pos
        sadd8 n, n, neg_cnt

        ldr.w t, [r_pos], #4
        ldr.w pos, [r_pos], #4
        ldr.w neg_cnt, [r_pos], #4
        sadd8 s, s, t
        sadd8 m1, m1, pos
        sadd8 n1, n1, neg_cnt


        subs.w pos_cnt, #1
        bne.w 1b
    stmia ptr_ret!, {ptr_s2, m, n, s, m1, n1}
    vmov pos_cnt, s0
    sub.w ptr_index, pos_cnt
    add.w ptr_s, #24
    .endr

  ldr.w ptr_s2, [ptr_ret]
  ldr.w m, [ptr_ret, #4]
  ldr.w n, [ptr_ret, #8]
  ldr.w s, [ptr_ret, #12]
  2:
      ldrb pos, [ptr_index], #1
      sub.w r_pos, ptr_s, pos
      ldr.w t, [r_pos], #4
      ldr.w pos, [r_pos], #4
      ldr.w neg_cnt, [r_pos], #4
      ldr.w m1, [r_pos], #4
      sadd8 ptr_s2, ptr_s2, t
      sadd8 m, m, pos
      sadd8 n, n, neg_cnt
      sadd8 s, s, m1
      subs.w pos_cnt, #1
      bne.w 2b

  stmia ptr_ret!, {ptr_s2, m, n, s}
  vmov pos_cnt, s0
  sub.w ptr_index, pos_cnt
  add.w ptr_s, #16

  add.w ptr_index, pos_cnt
  sub.w ptr_ret, #256
  sub.w ptr_s, #256

   vmov neg_cnt, s1

    .rept 10
      ldr.w ptr_s2, [ptr_ret]
      ldr.w m, [ptr_ret, #4]
      ldr.w n, [ptr_ret, #8]
      ldr.w s, [ptr_ret, #12]
      ldr.w m1, [ptr_ret, #16]
      ldr.w n1, [ptr_ret, #20]
      3:
          ldrb pos, [ptr_index], #1
          sub.w r_pos, ptr_s, pos
          ldr.w t, [r_pos], #4
          ldr.w pos, [r_pos], #4
          ldr.w pos_cnt, [r_pos], #4
          ssub8 ptr_s2, ptr_s2, t
          ssub8 m, m, pos
          ssub8 n, n, pos_cnt

          ldr.w t, [r_pos], #4
          ldr.w pos, [r_pos], #4
          ldr.w pos_cnt, [r_pos], #4
          ssub8 s, s, t
          ssub8 m1, m1, pos
          ssub8 n1, n1, pos_cnt


          subs.w neg_cnt, #1
          bne.w 3b
      stmia ptr_ret!, {ptr_s2, m, n, s, m1, n1}
      vmov neg_cnt, s1
      sub.w ptr_index, neg_cnt
      add.w ptr_s, #24
      .endr

    ldr.w ptr_s2, [ptr_ret]
    ldr.w m, [ptr_ret, #4]
    ldr.w n, [ptr_ret, #8]
    ldr.w s, [ptr_ret, #12]
    4:
        ldrb pos, [ptr_index], #1
        sub.w r_pos, ptr_s, pos
        ldr.w t, [r_pos], #4
        ldr.w pos, [r_pos], #4
        ldr.w pos_cnt, [r_pos], #4
        ldr.w m1, [r_pos], #4
        ssub8 ptr_s2, ptr_s2, t
        ssub8 m, m, pos
        ssub8 n, n, pos_cnt
        ssub8 s, s, m1
        subs.w neg_cnt, #1
        bne.w 4b

    stmia ptr_ret!, {ptr_s2, m, n, s}
    vmov neg_cnt, s1
    add.w ptr_s, #16



  sub.w ptr_ret, #256
  sub.w ptr_s, #512
  sub.w ptr_index, #50

  pop {R4-R12, PC}


  .unreq ptr_ret
  .unreq ptr_index
  .unreq ptr_s
  .unreq r_pos
  .unreq pos_cnt
  .unreq neg_cnt
  .unreq pos
  .unreq m
  .unreq n
  .unreq s
  .unreq t
  .unreq m1
  .unreq n1

.ltorg
