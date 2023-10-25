// Assignment:  Create an equivalent replacement in assembly for the int32_t MxPlusB(int32_t x, int32_t mtop, int32_t mbtm, int32_t b) function found in the C main program.

        .syntax     unified
        .cpu        cortex-m4
        .text
        
// int32_t MxPlusB(int32_t x, int32_t mtop, int32_t mbtm, int32_t b) ;

// #define ASR31(x) ((x < 0) ? -1 : 0)                          // Same as arithmetic shift right by 31 bits    
// rounding = ((((ASR31(dvnd*dvsr)) * dvsr) << 1) + dvsr) / 2 ; // rounding (where dvnd = x*mtop, dvsr = mbtm)
// quotient = (dvnd + rounding) / dvsr ;                        // quotient = (x*mtop + rounding) / mbtm

/* ------------------------------------------------------------------------------------------------------------------- */
// Note: The purpose of ASR31(dvnd*dvsr) is to produce a result that will be -1 if dvnd/dvsr is negative, else 0. 
/* ------------------------------------------------------------------------------------------------------------------- */

        .global     MxPlusB
        .thumb_func
        .align
        
MxPlusB:
            MUL                 R1, R0, R1
            SMULL               R12, R0, R1, R2                 // ARM_Instruction1: Calculate dvnd = x * mtop, R1 = dvnd, R0 = dvnd*dvsr
            // ARM_Instruction2: R0 = dvnd*dvsr (Sign of product = Sign of x*mtop*mbtm)
            ASR R0, R0, 31                                     // Calculate the sign of dvnd (ASR31)
            MUL                 R0, R0, R2                     // ARM_Instruction: R0 = (dvnd*dvsr) >> 31) * dvsr
            // ARM_Instruction5: R0 = ((dvnd*dvsr) >> 31) * dvsr) << 1) + dvsr
            ADD                 R0, R2, R0, LSL 1              // ARM_Instruction: Add 1 if R0 is negative so ASR divides by 2 correctly
            ADD                 R0, R0, R0, LSR 31       
            ASR                 R0, R0, 1                      // ARM_Instruction: R0 = rounding = (((dvnd*dvsr) >> 31) * dvsr) << 1) + dvsr) / 2
            ADD                 R0, R1, R0                    // ARM_Instruction: R0 = dvnd + rounding
            SDIV                R0, R0, R2                  // ARM_Instruction: R0 = (dvnd + rounding) / dvsr
            ADD                 R0, R0, R3                 // ARM_Instruction: R0 = (dvnd + rounding) / dvsr + b

            BX                  LR

        .end

//`MxPlusB` takes four 32-bit integers as input arguments and returns a 32-bit integer result. The purpose of the function is to calculate the value of `x * mtop + b` divided by `mbtm` while ensuring proper rounding.
