.syntax unified
.thumb
.macro redq a, tmp, q
    add     \tmp, \a,  #4194304
    asrs    \tmp, \tmp, #23
    mls     \a, \tmp, \q, \a
.endm

// void asm_poly_add(int32_t c[N], int32_t a[N], int32_t b[N]);
.global pqcrystals_dilithium_asm_poly_add
.type pqcrystals_dilithium_asm_poly_add, %function
.align 2
pqcrystals_dilithium_asm_poly_add:
    push {r4-r11}

    movw r11, #64
    1:
        ldr.w r4, [r1, #1*4]
        ldr.w r5, [r1, #2*4]
        ldr.w r6, [r1, #3*4]
        ldr.w r3, [r1], #4*4
        
        ldr.w r8, [r2, #1*4]
        ldr.w r9, [r2, #2*4]
        ldr.w r10, [r2, #3*4]
        ldr.w r7, [r2], #4*4

        add.w r3, r7
        add.w r4, r8
        add.w r5, r9
        add.w r6, r10

        str.w r4, [r0, #1*4]
        str.w r5, [r0, #2*4]
        str.w r6, [r0, #3*4]
        str r3, [r0], #4*4
        subs r11, #1
        bne.w 1b

    pop {r4-r11}
    bx lr
.size pqcrystals_dilithium_asm_poly_add, .-pqcrystals_dilithium_asm_poly_add


// void asm_poly_sub(int32_t c[N], int32_t a[N], int32_t b[N]);
.global pqcrystals_dilithium_asm_poly_sub
.type pqcrystals_dilithium_asm_poly_sub, %function
.align 2
pqcrystals_dilithium_asm_poly_sub:
    push {r4-r11}

    movw r11, #64
    1:
        ldr.w r4, [r1, #1*4]
        ldr.w r5, [r1, #2*4]
        ldr.w r6, [r1, #3*4]
        ldr.w r3, [r1], #4*4
        
        ldr.w r8, [r2, #1*4]
        ldr.w r9, [r2, #2*4]
        ldr.w r10, [r2, #3*4]
        ldr.w r7, [r2], #4*4

        sub.w r3, r3, r7
        sub.w r4, r4, r8
        sub.w r5, r5, r9
        sub.w r6, r6, r10

        str.w r4, [r0, #1*4]
        str.w r5, [r0, #2*4]
        str.w r6, [r0, #3*4]
        str r3, [r0], #4*4
        subs r11, #1
        bne.w 1b

    pop {r4-r11}
    bx lr
.size pqcrystals_dilithium_asm_poly_sub, .-pqcrystals_dilithium_asm_poly_sub

//a1,a0,a
.macro power2round a, b, c
    //a+4095
    add     \a, \c, #4095
    //(a+4095)>>13
    asrs    \a, \a, #13
    //a0 = a-a1<<13
    sub.w   \b, \c, \a, lsl #13  
.endm

// void asm_poly_power2round(poly *a1, poly *a0, const poly *a);
.global pqcrystals_dilithium_asm_poly_power2round
.type pqcrystals_dilithium_asm_poly_power2round, %function
.align 2
pqcrystals_dilithium_asm_poly_power2round:
    push {r4-r12}
    movw r11, #64
    1:
        ldr.w r4, [r2, #1*4]
        ldr.w r5, [r2, #2*4]
        ldr.w r6, [r2, #3*4]
        ldr.w r3, [r2], #4*4
        //a1,a0,a
        power2round r12,r7,r3
        power2round r3,r8,r4
        power2round r4,r9,r5
        power2round r5,r10,r6

        
        str.w r3, [r0, #1*4]
        str.w r4, [r0, #2*4]
        str.w r5, [r0, #3*4]
        str r12, [r0], #4*4

        str.w r8, [r1, #1*4]
        str.w r9, [r1, #2*4]
        str.w r10, [r1, #3*4]
        str r7, [r1], #4*4
        subs r11, #1
        bne.w 1b

    pop {r4-r12}
    bx lr
.size pqcrystals_dilithium_asm_poly_power2round, .-pqcrystals_dilithium_asm_poly_power2round



//a1,a0,a
.macro power2round_compact cl, ch, al, ah, bl, bh, a, b
    //a+4095
    add     \al, \cl, #4095
    //(a+4095)>>13
    asrs    \al, \al, #13
    //a0 = a-a1<<13
    sub.w   \bl, \cl, \al, lsl #13  
    //a+4095
    add     \ah, \ch, #4095
    //(a+4095)>>13
    asrs    \ah, \ah, #13
    //a0 = a-a1<<13
    sub.w   \bh, \ch, \ah, lsl #13 
    //pack
    pkhbt   \a, \al, \ah, lsl#16
    pkhbt   \b, \bl, \bh, lsl#16
.endm

// void asm_poly_power2round(poly *a1, poly *a0, const poly *a);
.global pqcrystals_dilithium_asm_poly_power2round_compact
.type pqcrystals_dilithium_asm_poly_power2round_compact, %function
.align 2
pqcrystals_dilithium_asm_poly_power2round_compact:
    push {r4-r12}
    movw r11, #64
    1:
        ldr.w r4, [r2, #1*4]
        ldr.w r5, [r2, #2*4]
        ldr.w r6, [r2, #3*4]
        ldr.w r3, [r2], #4*4
        //a1,a0,a
        
        power2round_compact r3, r4, r7, r8, r9, r10, r3, r4
        power2round_compact r5, r6, r7, r8, r9, r10, r5, r6
        
        str.w r5, [r0, #1*4]
        str r3, [r0], #2*4

        str.w r6, [r1, #1*4]
        str r4, [r1], #2*4

        subs r11, #1
        bne.w 1b

    pop {r4-r12}
    bx lr
.size pqcrystals_dilithium_asm_poly_power2round_compact, .-pqcrystals_dilithium_asm_poly_power2round_compact


//a1,a0,a for dilithium2
.macro decompose a, b, c       
    //a1=a+127
    add     \a, \c, #127
    //a1=(a + 127) >> 7
    asrs    \a, \a, #7
    //a1 = a1*11275 + 8388608
    //load 1<<23
    mov \b, #8388608
    mov r12, #11275 
    //a1 = a1*11275 + 8388608
    mla.w    \a, \a, r12, \b
    //a1 >> 24
    asrs    \a, \a, #24
    //43-a1
    movw \b, #43
    sub.w \b, \b, \a
    //(43-a1)>>31
    asrs  \b, \b, #31
    //(43-a1)>>31 & a1
    and  \b, \b, \a
    //a1 ^= ((43 - a1) >> 31) & a1
    eor  \a, \b, \a
    //a0  = a - a1*2*GAMMA2
    // load 2*GAMMA2
    mov \b, #190464
    //a1*2*GAMMA2
    mul.w \b, \b, \a
    //a0  = a - a1*2*GAMMA2
    sub.w \b, \c, \a
    mov \c, #8388608
    sub.w \c, \c, #8192
    asrs \c, \c, #1
    sub.w \c, \c, \b
    asrs \c, \c, #31
    mov r12, #8388608
    sub.w r12, r12, #8192
    add.w r12, r12, #1
    and \c, \c, r12
    sub.w \b, \b, \c
    
.endm
// void asm_poly_decompose(poly *a1, poly *a0, const poly *a);
.global pqcrystals_dilithium_asm_poly_decompose
.type pqcrystals_dilithium_asm_poly_decompose, %function
.align 2
pqcrystals_dilithium_asm_poly_decompose:
    push {r4-r12}
    movw r11, #64
    1:
        ldr.w r4, [r2, #1*4]
        ldr.w r5, [r2, #2*4]
        ldr.w r6, [r2, #3*4]
        ldr.w r3, [r2], #4*4
        //a1,a0,a
        decompose r12,r7,r3
        decompose r3,r8,r4
        decompose r4,r9,r5
        decompose r5,r10,r6

        str.w r3, [r0, #1*4]
        str.w r4, [r0, #2*4]
        str.w r5, [r0, #3*4]
        str r12, [r0], #4*4

        str.w r8, [r1, #1*4]
        str.w r9, [r1, #2*4]
        str.w r10, [r1, #3*4]
        str r7, [r1], #4*4
        subs r11, #1
        bne.w 1b

    pop {r4-r12}
    bx lr
.size pqcrystals_dilithium_asm_poly_decompose, .-pqcrystals_dilithium_asm_poly_decompose


// void asm_reduce32(int32_t a[N]);
.global pqcrystals_dilithium_asm_reduce32
.type pqcrystals_dilithium_asm_reduce32, %function
.align 2
pqcrystals_dilithium_asm_reduce32:
    push {r4-r10}

    movw r12,#:lower16:8380417
    movt r12,#:upper16:8380417
    movw r10, #32
    1:
        ldr.w r1, [r0]
        ldr.w r2, [r0, #1*4]
        ldr.w r3, [r0, #2*4]
        ldr.w r4, [r0, #3*4]
        ldr.w r5, [r0, #4*4]
        ldr.w r6, [r0, #5*4]
        ldr.w r7, [r0, #6*4]
        ldr.w r8, [r0, #7*4]

        redq r1, r9, r12
        redq r2, r9, r12
        redq r3, r9, r12
        redq r4, r9, r12
        redq r5, r9, r12
        redq r6, r9, r12
        redq r7, r9, r12
        redq r8, r9, r12

        str.w r2, [r0, #1*4]
        str.w r3, [r0, #2*4]
        str.w r4, [r0, #3*4]
        str.w r5, [r0, #4*4]
        str.w r6, [r0, #5*4]
        str.w r7, [r0, #6*4]
        str.w r8, [r0, #7*4]
        str r1, [r0], #8*4
        subs r10, #1
        bne.w 1b

    pop {r4-r10}
    bx lr
.size pqcrystals_dilithium_asm_reduce32, .-pqcrystals_dilithium_asm_reduce32



// void asm_poly_shiftl(int32_t a[N]);
.global pqcrystals_dilithium_asm_poly_shiftl
.type pqcrystals_dilithium_asm_poly_shiftl, %function
.align 2
pqcrystals_dilithium_asm_poly_shiftl:
    push {r4-r10}

    movw r10, #32
    1:
        ldr.w r1, [r0]
        ldr.w r2, [r0, #1*4]
        ldr.w r3, [r0, #2*4]
        ldr.w r4, [r0, #3*4]
        ldr.w r5, [r0, #4*4]
        ldr.w r6, [r0, #5*4]
        ldr.w r7, [r0, #6*4]
        ldr.w r8, [r0, #7*4]

        lsl.w r1, r1, #13
        lsl.w r2, r2, #13
        lsl.w r3, r3, #13
        lsl.w r4, r4, #13
        lsl.w r5, r5, #13
        lsl.w r6, r6, #13
        lsl.w r7, r7, #13
        lsl.w r8, r8, #13

        str.w r2, [r0, #1*4]
        str.w r3, [r0, #2*4]
        str.w r4, [r0, #3*4]
        str.w r5, [r0, #4*4]
        str.w r6, [r0, #5*4]
        str.w r7, [r0, #6*4]
        str.w r8, [r0, #7*4]
        str r1, [r0], #8*4
        subs r10, #1
        bne.w 1b

    pop {r4-r10}
    bx lr
.size pqcrystals_dilithium_asm_poly_shiftl, .-pqcrystals_dilithium_asm_poly_shiftl




.macro barrett_32 a, Qbar, Q, tmp
    smmulr.w \tmp, \a, \Qbar
    mls.w \a, \tmp, \Q, \a
.endm

// INPUT: target (signed), KYBER_Q (signed)
// OUTPUT: target adjusted to be between -KYBER_Q/2 and KYBER_Q/2
.macro central_reduce target, Q
  cmp \target, \Q, lsr #1
  it hi
  subhi \target, \Q
  cmn \target, \Q, lsr #1
  it lt
  addlt \target, \Q
.endm

// void asm_reduce32(int32_t a[N]);
.global pqcrystals_dilithium_small_asm_reduce32_central
.type pqcrystals_dilithium_small_asm_reduce32_central, %function
.align 2
pqcrystals_dilithium_small_asm_reduce32_central:
    push {r4-r12, lr}


    movw r9, #:lower16:5585133
    movt r9, #:upper16:5585133
    mov.w r10,#769

    movw r12, #32
    1:
        ldr.w r1, [r0]
        ldr.w r2, [r0, #1*4]
        ldr.w r3, [r0, #2*4]
        ldr.w r4, [r0, #3*4]
        ldr.w r5, [r0, #4*4]
        ldr.w r6, [r0, #5*4]
        ldr.w r7, [r0, #6*4]
        ldr.w r8, [r0, #7*4]

        barrett_32 r1, r9, r10, r11
        barrett_32 r2, r9, r10, r11
        barrett_32 r3, r9, r10, r11
        barrett_32 r4, r9, r10, r11
        barrett_32 r5, r9, r10, r11
        barrett_32 r6, r9, r10, r11
        barrett_32 r7, r9, r10, r11
        barrett_32 r8, r9, r10, r11


        str.w r2, [r0, #1*4]
        str.w r3, [r0, #2*4]
        str.w r4, [r0, #3*4]
        str.w r5, [r0, #4*4]
        str.w r6, [r0, #5*4]
        str.w r7, [r0, #6*4]
        str.w r8, [r0, #7*4]
        str r1, [r0], #8*4
        subs r12, #1
        bne.w 1b

    pop {r4-r12, pc}

.size pqcrystals_dilithium_small_asm_reduce32_central, .-pqcrystals_dilithium_small_asm_reduce32_central

.macro caddq a, tmp, q
    and     \tmp, \q, \a, asr #31
    add     \a, \a, \tmp
.endm

.macro freezeq a, tmp, q
    redq \a, \tmp, \q
    caddq \a, \tmp, \q
.endm

// void asm_caddq(int32_t a[N]);
.global pqcrystals_dilithium_asm_caddq
.type pqcrystals_dilithium_asm_caddq, %function
.align 2
pqcrystals_dilithium_asm_caddq:
    push {r4-r10}

    movw r12,#:lower16:8380417
    movt r12,#:upper16:8380417

    movw r10, #32
    1:
        ldr.w r1, [r0]
        ldr.w r2, [r0, #1*4]
        ldr.w r3, [r0, #2*4]
        ldr.w r4, [r0, #3*4]
        ldr.w r5, [r0, #4*4]
        ldr.w r6, [r0, #5*4]
        ldr.w r7, [r0, #6*4]
        ldr.w r8, [r0, #7*4]

        caddq r1, r9, r12
        caddq r2, r9, r12
        caddq r3, r9, r12
        caddq r4, r9, r12
        caddq r5, r9, r12
        caddq r6, r9, r12
        caddq r7, r9, r12
        caddq r8, r9, r12

        str.w r2, [r0, #1*4]
        str.w r3, [r0, #2*4]
        str.w r4, [r0, #3*4]
        str.w r5, [r0, #4*4]
        str.w r6, [r0, #5*4]
        str.w r7, [r0, #6*4]
        str.w r8, [r0, #7*4]
        str r1, [r0], #8*4
        subs r10, #1
        bne.w 1b

    pop {r4-r10}
    bx lr
.size pqcrystals_dilithium_asm_caddq, .-pqcrystals_dilithium_asm_caddq


// asm_rej_uniform(int32_t *a,unsigned int len,const unsigned char *buf, unsigned int buflen);
.global pqcrystals_dilithium_asm_rej_uniform
.type pqcrystals_dilithium_asm_rej_uniform, %function
.align 2
pqcrystals_dilithium_asm_rej_uniform:
    push.w {r4-r6}
    push.w {r1}
    // Store Q-1 in r12.
    movw r12,#:lower16:8380416
    movt r12,#:upper16:8380416

    add.w r6, r0, r1, lsl #2
    add.w r3, r2, r3
    sub.w r3, r3, #2

1:
    // If there are less than 3 bytes available, return.
    cmp.w r3, r2
    ble.w end

    ldr r5, [r2], #3
    ubfx r5, r5, #0, #23

    cmp.n r5, r12
    it le
    strle r5, [r0], #4

    cmp.n r0, r6
    bne.n 1b

end:
    pop.w {r5}

    sub.w r0, r6, r0
    sub.w r0, r5, r0, lsr #2
    pop.w {r4-r6}
    bx lr
.size pqcrystals_dilithium_asm_rej_uniform, .-pqcrystals_dilithium_asm_rej_uniform
