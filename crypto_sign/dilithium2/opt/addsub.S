.syntax unified

//void sub_asm(int8_t c[N], int8_t v[N])
.global sub_asm
.type sub_asm,%function
.align 2
sub_asm:
    push {r4-r11}
    ptr_c .req r0
    ptr_v .req r1
    polyc0 .req r2
    polyc1 .req r3
    polyc2 .req r4
    polyc3 .req r5
    polyv0 .req r6
    polyv1 .req r7
    polyv2 .req r8
    polyv3 .req r9

    movw r11,#16
    1:
        ldr.w polyc0, [ptr_c]
        ldr.w polyc1, [ptr_c, #1*4]
        ldr.w polyc2, [ptr_c, #2*4]
        ldr.w polyc3, [ptr_c, #3*4]

        ldr.w polyv1, [ptr_v, #1*4]
        ldr.w polyv2, [ptr_v, #2*4]
        ldr.w polyv3, [ptr_v, #3*4]
        ldr.w polyv0, [ptr_v], #4*4

        ssub8 polyc0, polyc0, polyv0
        ssub8 polyc1, polyc1, polyv1
        ssub8 polyc2, polyc2, polyv2
        ssub8 polyc3, polyc3, polyv3

        str.w polyc1, [ptr_c, #1*4]
        str.w polyc2, [ptr_c, #2*4]
        str.w polyc3, [ptr_c, #3*4]
        str polyc0, [ptr_c], #4*4
        subs r11, #1
        bne.w 1b
    pop {r4-r11}
    bx lr
.size sub_asm, .-sub_asm


.global add_asm
.type add_asm,%function
.align 2
add_asm:
    push {r4-r11}
    ptr_c .req r0
    ptr_v .req r1
    polyc0 .req r2
    polyc1 .req r3
    polyc2 .req r4
    polyc3 .req r5
    polyv0 .req r6
    polyv1 .req r7
    polyv2 .req r8
    polyv3 .req r9

    movw r11,#16
    1:
        ldr.w polyc0, [ptr_c]
        ldr.w polyc1, [ptr_c, #1*4]
        ldr.w polyc2, [ptr_c, #2*4]
        ldr.w polyc3, [ptr_c, #3*4]

        ldr.w polyv1, [ptr_v, #1*4]
        ldr.w polyv2, [ptr_v, #2*4]
        ldr.w polyv3, [ptr_v, #3*4]
        ldr.w polyv0, [ptr_v], #4*4

        sadd8 polyc0, polyc0, polyv0
        sadd8 polyc1, polyc1, polyv1
        sadd8 polyc2, polyc2, polyv2
        sadd8 polyc3, polyc3, polyv3

        str.w polyc1, [ptr_c, #1*4]
        str.w polyc2, [ptr_c, #2*4]
        str.w polyc3, [ptr_c, #3*4]
        str polyc0, [ptr_c], #4*4
        subs r11, #1
        bne.w 1b
    pop {r4-r11}
    bx lr
.size add_asm, .-add_asm

.global preparetable_asm
.type preparetable_asm,%function
.align 2
preparetable_asm:
    push {r4-r11}
    ptr_c .req r0
    ptr_v .req r1
    polyc0 .req r2
    polyc1 .req r3
    polyc2 .req r4
    polyc3 .req r5
    polyv0 .req r6
    polyv1 .req r7
    polyv2 .req r8
    polyv3 .req r9

    eor r10, r10
    movw r11,#16
    1:
        ldr.w polyc0, [ptr_c]
        ldr.w polyc1, [ptr_c, #1*4]
        ldr.w polyc2, [ptr_c, #2*4]
        ldr.w polyc3, [ptr_c, #3*4]

        ldr.w polyv1, [ptr_v, #1*4]
        ldr.w polyv2, [ptr_v, #2*4]
        ldr.w polyv3, [ptr_v, #3*4]
        ldr.w polyv0, [ptr_v], #4*4

        ssub8 polyc0, r10, polyv0
        ssub8 polyc1, r10, polyv1
        ssub8 polyc2, r10, polyv2
        ssub8 polyc3, r10, polyv3

        str.w polyc1, [ptr_c, #1*4]
        str.w polyc2, [ptr_c, #2*4]
        str.w polyc3, [ptr_c, #3*4]
        str polyc0, [ptr_c], #4*4
        subs r11, #1
        bne.w 1b
    movw r11,#16
    sub.w ptr_v, #256
    2:
        ldr.w polyc0, [ptr_c]
        ldr.w polyc1, [ptr_c, #1*4]
        ldr.w polyc2, [ptr_c, #2*4]
        ldr.w polyc3, [ptr_c, #3*4]

        ldr.w polyv1, [ptr_v, #1*4]
        ldr.w polyv2, [ptr_v, #2*4]
        ldr.w polyv3, [ptr_v, #3*4]
        ldr.w polyv0, [ptr_v], #4*4

        sadd8 polyc0, r10, polyv0
        sadd8 polyc1, r10, polyv1
        sadd8 polyc2, r10, polyv2
        sadd8 polyc3, r10, polyv3

        str.w polyc1, [ptr_c, #1*4]
        str.w polyc2, [ptr_c, #2*4]
        str.w polyc3, [ptr_c, #3*4]
        str polyc0, [ptr_c], #4*4
        subs r11, #1
        bne.w 2b
    pop {r4-r11}
    bx lr
.size preparetable_asm, .-preparetable_asm
