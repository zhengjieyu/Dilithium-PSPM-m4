.syntax unified
.cpu cortex-m4
.thumb

// void asm_polyeta_pack(uint8_t *r, const int32_t a[N])
.global pqcrystals_dilithium_asm_polyeta2_pack
.type pqcrystals_dilithium_asm_polyeta2_pack, %function
.align 2
pqcrystals_dilithium_asm_polyeta2_pack:
    push {r4-r12}
    movw r10, #8
    1:
        // 8个
        ldr.w r3, [r1, #1*4]
        ldr.w r4, [r1, #2*4]
        ldr.w r5, [r1, #3*4]
        ldr.w r6, [r1, #4*4]
        ldr.w r7, [r1, #5*4]
        ldr.w r8, [r1, #6*4]
        ldr.w r9, [r1, #7*4]
        ldr.w r2, [r1], #8*4
        //sub
        rsb.w r2, r2, #2
        rsb.w r3, r3, #2
        rsb.w r4, r4, #2
        rsb.w r5, r5, #2
        rsb.w r6, r6, #2
        rsb.w r7, r7, #2
        rsb.w r8, r8, #2
        rsb.w r9, r9, #2
        
        eor r11, r11
        lsl.w r11, r3, #3
        orr r11, r11, r2
        lsl.w r4, r4, #6
        orr r11, r11, r4
        lsl.w r5, r5, #9
        orr r11, r11, r5
        lsl.w r6, r6, #12
        orr r11, r11, r6
        lsl.w r7, r7, #15
        orr r11, r11, r7
        lsl.w r8, r8, #18
        orr r11, r11, r8
        lsl.w r9, r9, #21
        orr r11, r11, r9
        // 8个

        ldr.w r3, [r1, #1*4]
        ldr.w r4, [r1, #2*4]
        ldr.w r5, [r1, #3*4]
        ldr.w r6, [r1, #4*4]
        ldr.w r7, [r1, #5*4]
        ldr.w r8, [r1, #6*4]
        ldr.w r9, [r1, #7*4]
        ldr.w r2, [r1], #8*4
        //sub
        rsb.w r2, r2, #2
        rsb.w r3, r3, #2
        rsb.w r4, r4, #2
        rsb.w r5, r5, #2
        rsb.w r6, r6, #2
        rsb.w r7, r7, #2
        rsb.w r8, r8, #2
        rsb.w r9, r9, #2

        lsl.w r2, r2, #24
        orr r11, r11, r2
        lsl.w r3, r3, #27
        orr r11, r11, r3
     
        lsl.w r3, r4, #30
        orr r11, r11, r3
        //first four bytes
        str r11, [r0], #4 

        eor r11, r11
        asr r4, r4, #2
        lsl.w r11, r5, #1
        orr r11, r11, r4
        lsl.w r6, r6, #4
        orr r11, r11, r6
        lsl.w r7, r7, #7
        orr r11, r11, r7
        lsl.w r8, r8, #10
        orr r11, r11, r8
        lsl.w r9, r9, #13
        orr r11, r11, r9

        ldr.w r3, [r1, #1*4]
        ldr.w r4, [r1, #2*4]
        ldr.w r5, [r1, #3*4]
        ldr.w r6, [r1, #4*4]
        ldr.w r7, [r1, #5*4]
        ldr.w r8, [r1, #6*4]
        ldr.w r9, [r1, #7*4]
        ldr.w r2, [r1], #8*4
        //sub
        rsb.w r2, r2, #2
        rsb.w r3, r3, #2
        rsb.w r4, r4, #2
        rsb.w r5, r5, #2
        rsb.w r6, r6, #2
        rsb.w r7, r7, #2
        rsb.w r8, r8, #2
        rsb.w r9, r9, #2

        lsl.w r2, r2, #16
        orr r11, r11, r2
        lsl.w r3, r3, #19
        orr r11, r11, r3
        lsl.w r4, r4, #22
        orr r11, r11, r4
        lsl.w r5, r5, #25
        orr r11, r11, r5
        lsl.w r6, r6, #28
        orr r11, r11, r6
        
        lsl.w r6, r7, #31
        orr r11, r11, r6
        //second four bytes
        str r11, [r0], #4 

        eor r11, r11
        asr r7, r7, #1
        lsl.w r11, r8, #2
        orr r11, r11, r7
        lsl.w r9, r9, #5
        orr r11, r11, r9
        
        ldr.w r3, [r1, #1*4]
        ldr.w r4, [r1, #2*4]
        ldr.w r5, [r1, #3*4]
        ldr.w r6, [r1, #4*4]
        ldr.w r7, [r1, #5*4]
        ldr.w r8, [r1, #6*4]
        ldr.w r9, [r1, #7*4]
        ldr.w r2, [r1], #8*4
        //sub
        rsb.w r2, r2, #2
        rsb.w r3, r3, #2
        rsb.w r4, r4, #2
        rsb.w r5, r5, #2
        rsb.w r6, r6, #2
        rsb.w r7, r7, #2
        rsb.w r8, r8, #2
        rsb.w r9, r9, #2

        lsl.w r2, r2, #8
        orr r11, r11, r2
        lsl.w r3, r3, #11
        orr r11, r11, r3
        lsl.w r4, r4, #14
        orr r11, r11, r4
        lsl.w r5, r5, #17
        orr r11, r11, r5
        lsl.w r6, r6, #20
        orr r11, r11, r6
        lsl.w r7, r7, #23
        orr r11, r11, r7
        lsl.w r8, r8, #26
        orr r11, r11, r8
        lsl.w r9, r9, #29
        orr r11, r11, r9
        //third four bytes
        str r11, [r0], #4

        subs r10, #1
        bne.w 1b
        
    pop {r4-r12}
    bx lr

.size pqcrystals_dilithium_asm_polyeta2_pack, .-pqcrystals_dilithium_asm_polyeta2_pack

.global pqcrystals_dilithium_asm_polyeta4_pack
.type pqcrystals_dilithium_asm_polyeta4_pack, %function
.align 2
pqcrystals_dilithium_asm_polyeta4_pack:
    push {r4-r12}
    movw r10, #32
    movw r12, #4
    1:
        ldrb.w r3, [r1, #1*4]
        ldrb.w r4, [r1, #2*4]
        ldrb.w r5, [r1, #3*4]
        ldrb.w r6, [r1, #4*4]
        ldrb.w r7, [r1, #5*4]
        ldrb.w r8, [r1, #6*4]
        ldrb.w r9, [r1, #7*4]
        ldrb.w r2, [r1], #8*4
        //sub
        usub8 r2, r12, r2
        usub8 r3, r12, r3
        usub8 r4, r12, r4
        usub8 r5, r12, r5
        usub8 r6, r12, r6
        usub8 r7, r12, r7
        usub8 r8, r12, r8
        usub8 r9, r12, r9

        eor r11, r11
        lsl.w r11, r3, #4
        orr r11, r11, r2
        lsl.w r4, r4, #8
        orr r11, r11, r4
        lsl.w r5, r5, #12
        orr r11, r11, r5
        lsl.w r6, r6, #16
        orr r11, r11, r6
        lsl.w r7, r7, #20
        orr r11, r11, r7
        lsl.w r8, r8, #24
        orr r11, r11, r8
        lsl.w r9, r9, #28
        orr r11, r11, r9
        str r11, [r0], #4 
        // 8个
        subs r10, #1
        bne.w 1b
        
            
    pop {r4-r12}
    bx lr

.size pqcrystals_dilithium_asm_polyeta4_pack, .-pqcrystals_dilithium_asm_polyeta4_pack

//void polyt1_pack_compact(uint8_t *r, const int16_t a[N])
.global pqcrystals_dilithium_asm_polyt1_pack_compact
.type pqcrystals_dilithium_asm_polyt1_pack_compact, %function
.align 2
pqcrystals_dilithium_asm_polyt1_pack_compact:
    push.w {r4-r11,r14}
    movw r10, #16
    1:
        //8个
        ldrh.w r3, [r1, #1*2]
        ldrh.w r4, [r1, #2*2]
        ldrh.w r5, [r1, #3*2]
        ldrh.w r6, [r1, #4*2]
        ldrh.w r7, [r1, #5*2]
        ldrh.w r8, [r1, #6*2]
        ldrh.w r9, [r1, #7*2]
        ldrh.w r2, [r1], #8*2

        eor r11, r11
        lsl.w r11, r3, #10      //11-20bit
        orr r11, r11, r2
        lsl.w r4, r4, #20      //21-30bit
        orr r11, r11, r4
        lsl.w r4, r5, #30      //31-32bit
        orr r11, r11, r4
        str r11, [r0], #4       //4

        eor r11, r11
        asr r11, r5, #2         //1-8bit
        lsl.w r6, r6, #8       //9-18bit
        orr r11, r11, r6
        lsl.w r7, r7, #18      //19-28bit
        orr r11, r11, r7
        lsl.w r7, r8, #28      //29-32bit
        orr r11, r11, r7
        str r11, [r0], #4       //8

        eor r11, r11
        asr r11, r8, #4           //1-6bit
        lsl.w r9, r9, #6       //7-16bit
        orr r11, r11, r9
        
        ldrh.w r3, [r1, #1*2]
        ldrh.w r4, [r1, #2*2]
        ldrh.w r5, [r1, #3*2]
        ldrh.w r6, [r1, #4*2]
        ldrh.w r7, [r1, #5*2]
        ldrh.w r8, [r1, #6*2]
        ldrh.w r9, [r1, #7*2]
        ldrh.w r2, [r1], #8*2

        lsl.w r2, r2, #16      //17-26bit
        orr r11, r11, r2
        lsl.w r2, r3, #26      //27-32bit
        orr r11, r11, r2
        str r11, [r0], #4       //12

        eor r11, r11
        asr r11, r3, #6         //1-4bit
        lsl.w r4, r4, #4       //5-14bit
        orr r11, r11, r4
        lsl.w r5, r5, #14      //15-24bit
        orr r11, r11, r5
        lsl.w r5, r6, #24      //25-32bit
        orr r11, r11, r5
        str r11, [r0], #4       //16

        eor r11, r11
        asr r11, r6, #8         //1-2bit
        lsl.w r7, r7, #2       //3-12bit
        orr r11, r11, r7
        lsl.w r8, r8, #12      //13-22bit
        orr r11, r11, r8
        lsl.w r9, r9, #22      //22-32bit
        orr r11, r11, r9
        str r11, [r0], #4       //20

        subs r10, #1
        bne.w 1b

    pop.w {r4-r11, pc}
.size pqcrystals_dilithium_asm_polyt1_pack_compact, .-pqcrystals_dilithium_asm_polyt1_pack_compact

//void asm_polyt1_unpack(poly *r, const uint8_t *a)
.global pqcrystals_dilithium_asm_polyt1_unpack
.type pqcrystals_dilithium_asm_polyt1_unpack, %function
.align 2
pqcrystals_dilithium_asm_polyt1_unpack:
    push.w {r4-r12,r14}
    movw r10, #16
    movw r7, #1023
    1:
        //5个
        ldrb r3, [r1, #1]
        ldrb r4, [r1, #2]
        ldrb r5, [r1, #3]
        ldrb r6, [r1, #4]
        ldrb r2, [r1], #5

        eor r8, r8
        mov r8, r2             //8bit
        lsl.w r2, r3, #8        //2bit
        and r2, r2, r7
        orr r8, r8, r2

        eor r9, r9
        asr r9, r3, #2          //6bit
        lsl.w r3, r4, #6       //4bit
        and r3, r3, r7        //10bit 
        orr r9, r9, r3       

        eor r11, r11
        asr r11, r4, #4          //4bit
        lsl.w r4, r5, #4         //6bit
        and r4, r4, r7 
        orr r11, r11, r4        //10bit

        eor r12, r12
        asr r12, r5, #6          //2bit
        lsl.w r6, r6, #2       //8bit
        and r6, r6, r7 
        orr r12, r12, r6        //10bit
        
        str r8, [r0], #4
        str r9, [r0], #4
        str r11, [r0], #4
        str r12, [r0], #4

        //5个
        ldrb r3, [r1, #1]
        ldrb r4, [r1, #2]
        ldrb r5, [r1, #3]
        ldrb r6, [r1, #4]
        ldrb r2, [r1], #5

        eor r8, r8
        mov r8, r2             //8bit
        lsl.w r2, r3, #8        //2bit
        and r2, r2, r7
        orr r8, r8, r2

        eor r9, r9
        asr r9, r3, #2          //6bit
        lsl.w r3, r4, #6       //4bit
        and r3, r3, r7        //10bit 
        orr r9, r9, r3       

        eor r11, r11
        asr r11, r4, #4          //4bit
        lsl.w r4, r5, #4         //6bit
        and r4, r4, r7 
        orr r11, r11, r4        //10bit

        eor r12, r12
        asr r12, r5, #6          //2bit
        lsl.w r6, r6, #2       //8bit
        and r6, r7
        orr r12, r12, r6        //10bit
        
        str r8, [r0], #4
        str r9, [r0], #4
        str r11, [r0], #4
        str r12, [r0], #4

        //5个
        ldrb r3, [r1, #1]
        ldrb r4, [r1, #2]
        ldrb r5, [r1, #3]
        ldrb r6, [r1, #4]
        ldrb r2, [r1], #5

        eor r8, r8
        mov r8, r2             //8bit
        lsl.w r2, r3, #8        //2bit
        and r2, r2, r7
        orr r8, r8, r2

        eor r9, r9
        asr r9, r3, #2          //6bit
        lsl.w r3, r4, #6       //4bit
        and r3, r3, r7        //10bit 
        orr r9, r9, r3       

        eor r11, r11
        asr r11, r4, #4          //4bit
        lsl.w r4, r5, #4         //6bit
        and r4, r4, r7 
        orr r11, r11, r4        //10bit

        eor r12, r12
        asr r12, r5, #6          //2bit
        lsl.w r6, r6, #2       //8bit
        and r6, r6, r7 
        orr r12, r12, r6        //10bit
        
        str r8, [r0], #4
        str r9, [r0], #4
        str r11, [r0], #4
        str r12, [r0], #4

        //5个
        ldrb r3, [r1, #1]
        ldrb r4, [r1, #2]
        ldrb r5, [r1, #3]
        ldrb r6, [r1, #4]
        ldrb r2, [r1], #5

        eor r8, r8
        mov r8, r2             //8bit
        lsl.w r2, r3, #8        //2bit
        and r2, r2, r7
        orr r8, r8, r2

        eor r9, r9
        asr r9, r3, #2          //6bit
        lsl.w r3, r4, #6       //4bit
        and r3, r3, r7        //10bit 
        orr r9, r9, r3       

        eor r11, r11
        asr r11, r4, #4          //4bit
        lsl.w r4, r5, #4         //6bit
        and r4, r4, r7 
        orr r11, r11, r4        //10bit

        eor r12, r12
        asr r12, r5, #6          //2bit
        lsl.w r6, r6, #2       //8bit
        and r6, r7
        orr r12, r12, r6        //10bit
        
        str.w r8, [r0], #4
        str.w r9, [r0], #4
        str.w r11, [r0], #4
        str.w r12, [r0], #4

        
       
        subs r10, #1
        bne.w 1b

    pop.w {r4-r12, pc}
.size pqcrystals_dilithium_asm_polyt1_unpack, .-pqcrystals_dilithium_asm_polyt1_unpack




//void polyt0_pack_compact(uint8_t *r, const int16_t a[N])
.global pqcrystals_dilithium_asm_polyt0_pack_compact
.type pqcrystals_dilithium_asm_polyt0_pack_compact, %function
.align 2
pqcrystals_dilithium_asm_polyt0_pack_compact:
    push {r4-r12,r14}
    movw r10, #8
    movw r14, #4096
    1:
        //8个
        ldrh.w r3, [r1, #1*2]
        ldrh.w r4, [r1, #2*2]
        ldrh.w r5, [r1, #3*2]
        ldrh.w r6, [r1, #4*2]
        ldrh.w r7, [r1, #5*2]
        ldrh.w r8, [r1, #6*2]
        ldrh.w r9, [r1, #7*2]
        ldrh.w r2, [r1], #8*2
        usub16 r2, r14, r2
        usub16 r3, r14, r3
        usub16 r4, r14, r4
        usub16 r5, r14, r5
        usub16 r6, r14, r6
        usub16 r7, r14, r7
        usub16 r8, r14, r8
        usub16 r9, r14, r9
        eor r11, r11
        lsl r11, r3, #13    //26
        orr r11, r2         //13
        lsl r3, r4, #26     //32
        orr r11, r3
        str r11, [r0], #4   //4

        eor r11, r11
        asr r11, r4, #6     //7
        lsl r5, r5, #7      //20
        orr r11, r5
        lsl r5, r6, #20     //32
        orr r11, r5
        str r11, [r0], #4   //8

        eor r11, r11
        asr r11, r6, #12    //1
        lsl r7, r7, #1     //14
        orr r11, r7
        lsl r8, r8, #14
        orr r11, r8         //27
        lsl r8, r9, #27     //32
        orr r11, r8
        str r11, [r0], #4   //12

        eor r11, r11
        asr r11, r9, #5     //8
        //8个
        ldrh.w r3, [r1, #1*2]
        ldrh.w r4, [r1, #2*2]
        ldrh.w r5, [r1, #3*2]
        ldrh.w r6, [r1, #4*2]
        ldrh.w r7, [r1, #5*2]
        ldrh.w r8, [r1, #6*2]
        ldrh.w r9, [r1, #7*2]
        ldrh.w r2, [r1], #8*2
        usub16 r2, r14, r2
        usub16 r3, r14, r3
        usub16 r4, r14, r4
        usub16 r5, r14, r5
        usub16 r6, r14, r6
        usub16 r7, r14, r7
        usub16 r8, r14, r8
        usub16 r9, r14, r9
        lsl r2, r2, #8      
        orr r11, r2     //21
        lsl r2, r3, #21
        orr r11, r2     //32
        str r11, [r0], #4   //16

        eor r11, r11
        asr r11, r3, #11    //2
        lsl r4, r4, #2
        orr r11, r4         //15
        lsl r5, r5, #15
        orr r11, r5         //28
        lsl r5, r6, #28
        orr r11, r5         //32
        str r11, [r0], #4   //20

        eor r11, r11
        asr r11, r6, #4     //9
        lsl r7, r7, #9      //22
        orr r11, r7
        lsl r7, r8, #22     //32
        orr r11, r7
        str r11, [r0], #4   //24

        eor r11, r11
        asr r11, r8, #10     //3
        lsl r9, r9, #3      //16
        orr r11, r9
        //8个
        ldrh.w r3, [r1, #1*2]
        ldrh.w r4, [r1, #2*2]
        ldrh.w r5, [r1, #3*2]
        ldrh.w r6, [r1, #4*2]
        ldrh.w r7, [r1, #5*2]
        ldrh.w r8, [r1, #6*2]
        ldrh.w r9, [r1, #7*2]
        ldrh.w r2, [r1], #8*2
        usub16 r2, r14, r2
        usub16 r3, r14, r3
        usub16 r4, r14, r4
        usub16 r5, r14, r5
        usub16 r6, r14, r6
        usub16 r7, r14, r7
        usub16 r8, r14, r8
        usub16 r9, r14, r9
        lsl r2, r2, #16
        orr r11, r2     //29
        lsl r2, r3, #29
        orr r11, r2     //32
        str r11, [r0], #4   //28

        eor r11, r11
        asr r11, r3, #3 //10
        lsl r4, r4, #10
        orr r11, r4     //23
        lsl r4, r5, #23
        orr r11, r4     //32
        str r11, [r0], #4   //32

        eor r11, r11
        asr r11, r5, #9 //4
        lsl r6, r6, #4  //17
        orr r11, r6
        lsl r7, r7, #17 //30
        orr r11, r7
        lsl r7, r8, #30
        orr r11, r7     //32
        str r11, [r0], #4   //36

        eor r11, r11
        asr r11, r8, #2 //11
        lsl r9, r9, #11 //24
        orr r11, r9
        ldrh.w r3, [r1, #1*2]
        ldrh.w r4, [r1, #2*2]
        ldrh.w r5, [r1, #3*2]
        ldrh.w r6, [r1, #4*2]
        ldrh.w r7, [r1, #5*2]
        ldrh.w r8, [r1, #6*2]
        ldrh.w r9, [r1, #7*2]
        ldrh.w r2, [r1], #8*2
        usub16 r2, r14, r2
        usub16 r3, r14, r3
        usub16 r4, r14, r4
        usub16 r5, r14, r5
        usub16 r6, r14, r6
        usub16 r7, r14, r7
        usub16 r8, r14, r8
        usub16 r9, r14, r9
        lsl r12, r2, #24  //32
        orr r11, r12
        str r11, [r0], #4   //40

        eor r11, r11
        asr r11, r2, #8 //5
        lsl r3, r3, #5
        orr r11, r3     //18
        lsl r4, r4, #18
        orr r11, r4     //31
        lsl r4, r5, #31
        orr r11, r4     //32
        str r11, [r0], #4   //44

        eor r11, r11
        asr r11, r5, #1 //12

        lsl.w r6, r6, #12
        orr r11, r6     //25 

        lsl r6, r7, #25
        orr r11, r6     //32
        str r11, [r0], #4   //48

        eor r11, r11
        asr r11, r7, #7 //6
        lsl r8, r8, #6
        orr r11, r8     //19
        lsl r9, r9, #19
        orr r11, r9     //32
        str r11, [r0], #4   //52

        subs r10, #1
        bne.w 1b
    pop {r4-r12,r14}
    bx lr
.size pqcrystals_dilithium_asm_polyt0_pack_compact, .-pqcrystals_dilithium_asm_polyt0_pack_compact
 


//void asm_polyt0_unpack(poly *r, const uint8_t *a)
.global pqcrystals_dilithium_asm_polyt0_unpack
.type pqcrystals_dilithium_asm_polyt0_unpack, %function
.align 2
pqcrystals_dilithium_asm_polyt0_unpack:
    push.w {r4-r12,r14}
    movw r10, #32
    movw r12, #8191
    1:

        ldrb r3, [r1, #1]
        ldrb r4, [r1, #2]
        ldrb r5, [r1, #3]
        ldrb r6, [r1, #4]
        ldrb r7, [r1, #5]
        ldrb r8, [r1, #6]
        ldrb r9, [r1, #7]
        ldrb r2, [r1], #8

        eor r11, r11
        lsl.w r11, r3, #8
        orr r11, r2
        and r11, r12
        rsb.w r11, r11, #4096
        str r11, [r0], #4

        eor r11, r11
        lsr r11, r3, #5
        lsl r4, r4, #3
        orr r11, r4
        lsl r4, r5, #11
        orr r11, r4
        and r11, r12
        rsb.w r11, r11, #4096
        str r11, [r0], #4

        eor r11, r11
        lsr r11, r5, #2
        lsl r5, r6, #6
        orr r11, r5
        and r11, r12
        rsb.w r11, r11, #4096
        str r11, [r0], #4

        eor r11, r11
        lsr r11, r6, #7
        lsl r7, r7, #1
        orr r11, r7
        lsl r7, r8, #9
        orr r11, r7
        and r11, r12
        rsb.w r11, r11, #4096
        str r11, [r0], #4

        eor r11, r11
        lsr r11, r8, #4
        lsl r9, r9, #4
        orr r11, r9

        ldrb r3, [r1, #1]
        ldrb r4, [r1, #2]
        ldrb r5, [r1, #3]
        ldrb r6, [r1, #4]
        ldrb r2, [r1], #5


        lsl r12, r2, #12
        orr r11, r12
        movw r12, #8191
        and r11, r12
        rsb.w r11, r11, #4096
        str r11, [r0], #4

        eor r11, r11
        lsr r11, r2, #1
        lsl r2, r3, #7
        orr r11, r2
        and r11, r12
        rsb.w r11, r11, #4096
        str r11, [r0], #4

        eor r11, r11
        lsr r11, r3, #6
        lsl r2, r4, #2
        orr r11, r2
        lsl r2, r5, #10
        orr r11, r2
        and r11, r12
        rsb.w r11, r11, #4096
        str r11, [r0], #4

        eor r11, r11
        lsr r11, r5, #3
        lsl r2, r6, #5
        orr r11, r2
        and r11, r12
        rsb.w r11, r11, #4096
        str r11, [r0], #4

       
        subs r10, #1
        bne.w 1b

    pop.w {r4-r12, pc}
.size pqcrystals_dilithium_asm_polyt0_unpack, .-pqcrystals_dilithium_asm_polyt0_unpack


// void asm_sparse_polyeta_unpack(int8_t r[2*N], const uint8_t *a) 
.global pqcrystals_dilithium_asm_sparse_polyeta_unpack
.type pqcrystals_dilithium_asm_sparse_polyeta_unpack, %function
.align 2
pqcrystals_dilithium_asm_sparse_polyeta_unpack:
    push {r4-r12}
    movw r10, #16
    movw r9, #2
    1:
        ldrb r3, [r1, #1]
        ldrb r4, [r1, #2]
        ldrb r5, [r1, #3]
        ldrb r6, [r1, #4]
        ldrb r7, [r1, #5]
        ldrb r2, [r1], #6
        
        eor r11, r11
        mov.w r8, r2
        and r8, #7
        usub8 r8, r9, r8
        orr r11, r8        
        asr r8, r2, #3
        and r8, #7
        usub8 r8, r9, r8
        lsl r8, r8, #8     
        orr r11, r8         
        asr r8, r2, #6
        lsl r2, r3, #2
        orr r8, r2
        and r8, #7
        usub8 r8, r9, r8
        lsl r8, r8, #16    
        orr r11, r8          
        asr r8, r3, #1
        and r8, #7
        usub8 r8, r9, r8
        lsl r8, r8, #24    
        orr r11, r8         
        str r11, [r0], #4 

        eor r11, r11
        asr r8, r3, #4
        and r8, #7  
        usub8 r8, r9, r8
        mov.w r11, r8        
        asr r8, r3, #7
        lsl r2, r4, #1
        orr r8, r2
        and r8, #7
        usub8 r8, r9, r8
        lsl r8, r8, #8     
        orr r11, r8          
        asr r8, r4, #2
        and r8, #7
        usub8 r8, r9, r8
        lsl r8, r8, #16    
        orr r11, r8          
        asr r8, r4, #5
        and r8, #7
        usub8 r8, r9, r8
        lsl r8, r8, #24    
        orr r11, r8          
        str r11, [r0], #4 

        eor r11, r11
        mov.w r8, r5
        and r8, #7   
        usub8 r8, r9, r8
        mov.w r11, r8        
        asr r8, r5, #3
        and r8, #7
        usub8 r8, r9, r8
        lsl r8, r8, #8     
        orr r11, r8          
        asr r8, r5, #6
        lsl r5, r6, #2
        orr r8, r5
        and r8, #7
        usub8 r8, r9, r8
        lsl r8, r8, #16    
        orr r11, r8          
        asr r8, r6, #1
        and r8, #7
        usub8 r8, r9, r8
        lsl r8, r8, #24    
        orr r11, r8          
        str r11, [r0], #4 

        eor r11, r11
        asr r8, r6, #4
        and r8, #7  
        usub8 r8, r9, r8
        mov.w r11, r8        
        asr r8, r6, #7
        lsl r5, r7, #1
        orr r8, r5
        and r8, #7
        usub8 r8, r9, r8
        lsl r8, r8, #8     
        orr r11, r8         
        asr r8, r7, #2
        and r8, #7
        usub8 r8, r9, r8
        lsl r8, r8, #16    
        orr r11, r8          
        asr r8, r7, #5
        and r8, #7
        usub8 r8, r9, r8
        lsl r8, r8, #24    
        orr r11, r8          
        str r11, [r0], #4 

        
        subs r10, #1
        bne.w 1b
        
            
    pop {r4-r12}
    bx lr

.size pqcrystals_dilithium_asm_sparse_polyeta_unpack, .-pqcrystals_dilithium_asm_sparse_polyeta_unpack


// void sparse_polyeta4_unpack(int8_t r[2*N], const uint8_t *a) 
.global pqcrystals_dilithium_asm_sparse_polyeta4_unpack
.type pqcrystals_dilithium_asm_sparse_polyeta4_unpack, %function
.align 2
pqcrystals_dilithium_asm_sparse_polyeta4_unpack:
    push {r4-r12}
    movw r10, #16
    movw r12, #4
    1:
        ldrb r3, [r1, #1]
        ldrb r4, [r1, #2]
        ldrb r5, [r1, #3]
        ldrb r6, [r1, #4]
        ldrb r7, [r1, #5]
        ldrb r8, [r1, #6]
        ldrb r9, [r1, #7]
        ldrb r2, [r1], #8
        
        eor r11, r11
        orr r11, r2
        and r11, #15
        usub8 r11, r12, r11 //1-4bit
        asr r2, r2, #4
        usub8 r2, r12, r2
        lsl r2, r2, #8
        orr r11, r2         //8-12
        and r2, r3, #15
        usub8 r2, r12, r2
        lsl r2, r2, #16
        orr r11, r2         //16-20
        asr r3, r3, #4
        usub8 r3, r12, r3
        lsl r3, r3, #24
        orr r11, r3
        str r11, [r0], #4

        eor r11, r11
        orr r11, r4
        and r11, #15
        usub8 r11, r12, r11 //1-4bit
        asr r4, r4, #4
        usub8 r4, r12, r4
        lsl r4, r4, #8
        orr r11, r4         //8-12
        and r4, r5, #15
        usub8 r4, r12, r4
        lsl r4, r4, #16
        orr r11, r4         //16-20
        asr r5, r5, #4
        usub8 r5, r12, r5
        lsl r5, r5, #24
        orr r11, r5
        str r11, [r0], #4

        eor r11, r11
        orr r11, r6
        and r11, #15
        usub8 r11, r12, r11 //1-4bit
        asr r6, r6, #4
        usub8 r6, r12, r6
        lsl r6, r6, #8
        orr r11, r6         //8-12
        and r6, r7, #15
        usub8 r6, r12, r6
        lsl r6, r6, #16
        orr r11, r6         //16-20
        asr r7, r7, #4
        usub8 r7, r12, r7
        lsl r7, r7, #24
        orr r11, r7
        str r11, [r0], #4

        eor r11, r11
        orr r11, r8
        and r11, #15
        usub8 r11, r12, r11 //1-4bit
        asr r8, r8, #4
        usub8 r8, r12, r8
        lsl r8, r8, #8
        orr r11, r8         //8-12
        and r8, r9, #15
        usub8 r8, r12, r8
        lsl r8, r8, #16
        orr r11, r8         //16-20
        asr r9, r9, #4
        usub8 r9, r12, r9
        lsl r9, r9, #24
        orr r11, r9
        str r11, [r0], #4

        
        subs r10, #1
        bne.w 1b
        
            
    pop {r4-r12}
    bx lr

.size pqcrystals_dilithium_asm_sparse_polyeta4_unpack, .-pqcrystals_dilithium_asm_sparse_polyeta4_unpack