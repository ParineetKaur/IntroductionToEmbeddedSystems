// copy.s
// This is my code a class assignmed on Functions in Assembly

        .syntax     unified
        .cpu        cortex-m4
        .text

        .global     CopyCell
        .thumb_func
        .align

// Question 1: Translate each of the following C function calls into a sequence of ARM Cortex-M4 Instructions. Assume that all constants and variables are of type int32_t.
// Part a: f1(a);

LDR         R0, =a                  //R0 = &a
LDR         R0, [R0]                //R0 = a
BL          f1                      //Branch Link function f1

// Part b: f2(&a);

LDR         R0, =a                  //R0 = &a
BL          f2                      //Branch Link function f2

// Part c: f3(a, b);

LDR         R0, =a                  //R0 = &a
LDR         R0, [R0]                //R0 = a
LDR         R1, =b                  //R1 = &b
LDR         R1, [R1]                //R1 = b
BL          f3

// Part d: b = f4();
// NOTE: The program first branches to the function labeled "f4," and the instructions after the "BL" instruction are executed after the function returns.

BL          f4
LDR         R1, =b                  //R1 = &b
STR         R0, [R1]                //R0 -> b

// Question 2: Translate each of the following C function calls into a sequence of ARM Cortex-M4 Instructions. Assume that all constants and variables are of type uint64_t.

// Part a: g1(a);

LDR         R0, =a                  //R0 = &a
LDRD        R0, R1, [R0]            //R1.R0 = a
BL          g1


// Part b: g2(&a)

LDR         R0, =a                  //R0 = &a which is 32 bit value
BL          g2

// Part c: g3(a, b);

LDR         R0, =a                  //R0 = &a which is 32 bits
LDRD        R0, R1, [R0]            //R1.R0 = a which is 64 bits
LDR         R2, =b                  //R2 = &b which is 32 bits
LDRD        R2, R3, [R2]            //R3.R2 = b which is 64 bits
BL          g3

// Part d: b = g4();

BL          g4
LDR         R2, =b                  //R0 = &b which is 32 bits
STRD        R2, R1, [R2]            //R1.R2 = b which is 64 bits

// Question 3: Translate each of the following C function calls into a sequence of ARM Cortex-M4 Instructions. Assume that all constants and variables are of type int8_t.

// Part a: h1(a);

LDR         R0, =a                  //R0 = &a
LDRSB       R0, [R0]                //R0 = a
BL          h1

// Part b: h2(&a);

LDR         R0, =a                  //R0 = &a
BL          h1

// Part b: h3(a, b);

LDR         R0, =a                  //R0 = &a
LDRSB       R0, [R0]                //R0 = a
LDR         R1, =b                  //R1 = &b
LDRSB       R1, [R1]                //R1 = b
BL          h3

// Part c: b = h4();

BL          h4
LDR         R1, =a                  //R0 = &a
STRB        R0, [R1]                //R0 -> a

// Question 4: Translate each of the following functions into ARM Cortex-M4 assembly language:
// Part a:  uint64_t f4(uint32_t u32){
//              return (unit64_t) u32;
//          }

f4:
            LDR         R0, =u32        //R0 = &u32
            LDR         R1, =0          //R1 = 0
            STRD        R0, R1, [R0]    //R1.R0 -> u32
            BX          LR

// Part b: int32_t f5(int32_t a, int32_t b){
//              int32_t f6(int32_t) ;
//              return f6(a) + f6(b) ;
//          }

f5:
            PUSH        {R4, R5, LR}
            MOV         R4, R1           //Keep R1 (i.e. b) safe in R4
            BL          f6              //Call f6(a). R0 = a
            MOV         R5, R0          //Keep f6 safe in R5
            MOV         R0, R4          //Take value of R4 and copy into R0 in order to perform branch link to f6 again, so now R0 = b
            BL          f6              //Call f6(b). R0 = b
            ADD         R0, R0, R5      //R0 = f6(a) + f6(b)
            POP         {R4, R5, PC}


// Part c: uint32_t f7(uint32_t a, uint32_t b) {
//                  uint32_t f8(uint32_t, uint32_t) ;
//                  return f8(b, a) ;
//          }

f7:
            MOV         R2, R0          //Swap R0 and R1 using R2 as temporary register to store R0 contents
            MOV         R0, R1          //Copy R1 -> R0
            MOV         R1, R2          //Copy temporary contents in R2 into R1
            B           f8              //Given that call to f8 is the very last thing in f7, then we can use just B f8 so that R0 = f8(b, a)


// Part d: int32_t f9(int32_t a) {
//              int8_t f10(int8_t) ;
//              return a + (int32_t) f10(0) ;
//          }

f9:
            PUSH        {R4, LR}
            MOV         R4, R0          //Copy R0 -> R4
            LDR         R0, =0          //R0 = 0
            BL          f10             //Call f10(0)
            ADD         R0, R0, R4      //R0 = f10(0) + a
            POP         {R4, PC}

// Part e: uint64_t  f11(uint32_t a){
//              uint32_t  f12(uint32_t) ;
//              return (uint64_t) f12(a + 10) ;
//          }

f11:
            PUSH        {LR}
            ADD         R0, R0, 10      //R0 = R0 + 10
            BL          f12             //Function call: R0 <- f12(a+10)
            LDR         R1, =0          //zero extension
            POP         {PC}
