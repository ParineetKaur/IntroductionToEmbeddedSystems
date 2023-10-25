    .syntax         unified
        .cpu            cortex-m4
        .text

// int32_t Return32Bits(void) ;
        .global         Return32Bits
        .thumb_func
        .align
Return32Bits:
    // Implementation
    MOV R0, 10
    BX LR

// int64_t Return64Bits(void) ;
        .global         Return64Bits
        .thumb_func
        .align
Return64Bits: //label is an address
    // Implementation
    MOV     R1, -1     // Clear R0 to store the lower 32 bits
    MOV     R0, -10   // Load -10 into R1 to store the upper 32 bits, representing signed negative value
    BX      LR        //returns from the function with the combined 64-bit value stored in R0 and R1


// uint8_t Add8Bits(uint8_t x, uint8_t y) ;
        .global         Add8Bits
        .thumb_func
        .align
Add8Bits:
	//Implementation
    ADD            R0, R0, R1   // Add the values in R0 and R1, and store the result in R2
    UXTB           R0, R0
    BX             LR         

// uint32_t FactSum32(uint32_t x, uint32_t y) ;
        .global         FactSum32
        .thumb_func
        .align
FactSum32:
	//Implementation
    PUSH {R4, R5, R6, LR}       //Save R4, R4, R5, R6 LR on the stack
    ADD R0, R0, R1          //Calculate x + y and store the result in R0
    //Call Factorial(x + y) and store the result in R5
    MOV R4, R0              //R4 = x + y
    BL Factorial            //Call Factorial(x + y)
    MOV R5, R0              //Preserve the result of Factorial in R5
    MOV R0, R5
    POP {R4, R5, R6, PC}        //Restore R4, R5, and return

// uint32_t XPlusGCD(uint32_t x, uint32_t y, uint32_t z) ;
        .global         XPlusGCD
        .thumb_func
        .align
XPlusGCD:
	//Implementation
    PUSH {R4, R5, R6, LR}       //Save R4, R4, R5, R6 LR on the stack
    MOV R4, R0          //R4 = y
    MOV R0, R1          //R0 = z
    MOV R1, R2          //R0 = z
    BL gcd              //Call gcd(y, z)
    ADD R0, R0, R4          //Add x and the result of gcd(y, z) (stored in R5)
    POP {R4, R5, R6, PC}    //Restore R4, R5, and return
.end