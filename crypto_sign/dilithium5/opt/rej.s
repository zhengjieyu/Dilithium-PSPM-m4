.syntax unified
.cpu cortex-m4
.thumb


// asm_rej_eta_4(int32_t *a, unsigned int len, const unsigned char *buf, unsigned int buflen);
.global pqcrystals_dilithium_asm_rej_eta_4
.type pqcrystals_dilithium_asm_rej_eta_4, %function
.align 2
pqcrystals_dilithium_asm_rej_eta_4:
    push.w {r4-r8}
    push.w {r1}

    mov r8, #8

    add.w r6, r0, r1, lsl #2
    add.w r3, r2, r3
    sub.w r3, r3, #3

1:
    cmp.w r3, r2
    bls.w end1

    ldr r5, [r2], #4
    .rept 8
        ubfx r7, r5, #0, #4
        lsr r5, r5, #4

        cmp.w r7, r8
        itt le
        rsble r7, r7, #4
        strle r7, [r0], #4
        cmp.w r0, r6
        bge.w end1
    .endr
    b.n 1b

end1:
    pop.w {r5}
    sub.w r0, r6, r0
    sub.w r0, r5, r0, lsr #2
    pop.w {r4-r8}

    bx lr


.size pqcrystals_dilithium_asm_rej_eta_4, .-pqcrystals_dilithium_asm_rej_eta_4

// asm_rej_eta_2(int32_t *a, unsigned int len, const unsigned char *buf, unsigned int buflen);
.global pqcrystals_dilithium_asm_rej_eta_2
.type pqcrystals_dilithium_asm_rej_eta_2, %function
.align 2
pqcrystals_dilithium_asm_rej_eta_2:
    push.w {r4-r12}
    push.w {r1}

    mov r10, #205
    mov r11, #5
    mov r12, #14

    add.w r6, r0, r1, lsl #2
    add.w r3, r2, r3
    sub.w r3, r3, #3

1:
    cmp.w r3, r2
    bls.w end2

    ldr r5, [r2], #4
    .rept 8
        ubfx r7, r5, #0, #4
        lsr r5, r5, #4

        mul r8, r7, r10
        lsr r8, r8, #10
        mul r8, r11
        sub r9, r7, r8

        cmp.n r7, r12
        itt le

        rsble r9, r9, #2
        strle r9, [r0], #4
        cmp.w r0, r6
        bge.w end2
    .endr
    b.n 1b

end2:
    pop.w {r5}

    sub.w r0, r6, r0
    sub.w r0, r5, r0, lsr #2
    pop.w {r4-r12}
    bx lr


.global pqcrystals_dilithium_asm_polyz_unpack_1
.type pqcrystals_dilithium_asm_polyz_unpack_1, %function
.align 2
pqcrystals_dilithium_asm_polyz_unpack_1:
    push.w {r4-r8}

     movw r8, #0x0000
     movt r8, #0x2
     .rept 64
     ldr r4, [r1], #4
     ldr r5, [r1], #4
     ldr r6, [r1], #1

     ubfx r7, r4, #0, #18
     sub  r7, r8, r7
     str.w r7, [r0], #4

     ubfx r7, r4, #18, #14
     bfi r7, r5, #14, #4
     sub  r7, r8, r7
     str.w r7, [r0], #4

     ubfx r7, r5, #4, #18
     sub  r7, r8, r7
     str.w r7, [r0], #4

     ubfx r7, r5, #22, #10
     bfi r7, r6, #10, #8
     sub  r7, r8, r7
     str.w r7, [r0], #4
     .endr


    pop.w {r4-r8}
    bx lr

// asm_polyz_unpack_2(int32_t *r->coeffs, const uint8_t *a);
.global pqcrystals_dilithium_asm_polyz_unpack_2
.type pqcrystals_dilithium_asm_polyz_unpack_2, %function
.align 2
pqcrystals_dilithium_asm_polyz_unpack_2:
    push.w {r4-r8}

    movw r8, #0x0
    movt r8, #0x8

    .rept 128
        ldr r4, [r1], #4
        ldr r5, [r1], #1

        ubfx r7, r4, #0, #20
        sub  r7, r8, r7
        str.w r7, [r0], #4

        ubfx r7, r4, #20, #12
        bfi r7, r5, #12, #8
        sub  r7, r8, r7
        str.w r7, [r0], #4
    .endr

    pop.w {r4-r8}
    bx lr



