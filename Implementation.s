      
        .syntax     unified
        .cpu        cortex-m4
        .text
//Name: Parneet Kaur
// ----------------------------------------------------------
// unsigned HalfWordAccess(int16_t *src) ;
// ----------------------------------------------------------

        .global     HalfWordAccess
        .thumb_func
        .align
HalfWordAccess:
    //Implementation
    .rept       100         //repeats process 100 times
    LDRH        R1, [R0]    //Used to load half-words (16 bits because it is LDRH) from memory 
    .endr
    BX LR

// ----------------------------------------------------------
// unsigned FullWordAccess(int32_t *src) ;
// ----------------------------------------------------------
        .global     FullWordAccess
        .thumb_func
        .align
FullWordAccess:
    //Implementation
    .rept       100         //repeats process 100 times
    LDR         R1, [R0]    //Used to load full words (32 bits) from memory
    .endr
    BX LR
// ----------------------------------------------------------
// unsigned NoAddressDependency(uint32_t *src) ;
// ----------------------------------------------------------

        .global     NoAddressDependency
        .thumb_func
        .align
NoAddressDependency:
	//Implementation
    .rept       100       //repeats process 100 times without address dependency
    LDR         R1,[R0]   //Loads data from memory pointed to by R0 without address dependency; R1 and R2 from memory
    LDR         R2,[R0]     
    .endr
    BX LR                 //NoAddressDependency does not depend on one register to store data memory/address 

// ----------------------------------------------------------
// unsigned AddressDependency(uint32_t *src) ;
// ----------------------------------------------------------

        .global     AddressDependency
        .thumb_func
        .align
AddressDependency:
	//Implementation
    .rept       100          //repeats process 100 times with address dependency
    LDR         R1,[R0]     //Loads data from memory pointed to by R0
    LDR         R0,[R1]     //Loads data from memory pointed to by R1
    .endr
    BX LR                   //AddressDependency does not depend on one register to store data memory/address
    
// ----------------------------------------------------------
// unsigned NoDataDependency(float f1) ;
// ----------------------------------------------------------

        .global     NoDataDependency
        .thumb_func
        .align
NoDataDependency:
	//Implementation
    .rept       100               //100 iterations of floating point addition without dependency
    VADD.F32    S1,S0,S0          //Use VADD.F32 to perform floating point addition and store result in S1
    VADD.F32    S2,S0,S0          //Use VADD.F32 to perform floating point addition and store result in S2
    .endr                           
    VMOV        S1,S0            //Moves the result to `S1` 
    BX LR

// ----------------------------------------------------------
// unsigned DataDependency(float f1) ;
// ----------------------------------------------------------

        .global     DataDependency
        .thumb_func
        .align                  //Addressing mode is word addressable
DataDependency:
	//Implementation
    .rept           100         //100 iterations of floating point addition without dependency       
    VADD.F32        S1,S0,S0    //Use VADD.F32 to perform floating point addition and store result in S1
    VADD.F32        S0,S1,S1    //Use VADD.F32 to perform floating point addition and store result in S0
    .endr                       //Problem: S1 can not be used in arithemtic operations until it is not outputted
    VMOV            S1,S0       //Moves the result to `S1`
    BX              LR

// ----------------------------------------------------------
// void VDIVOverlap(float dividend, float divisor) ;
// ----------------------------------------------------------

        .global     VDIVOverlap
        .thumb_func
        .align
VDIVOverlap:
	//Implementation
    VDIV.F32        S2,S1,S0        //Performs a floating-point division (`VDIV.F32`) of `S1` by `S0`
    .rept           1               
    NOP                             //Includes a `NOP` instruction within a loop (1 repetition) for some delay.
    .endr
    VMOV            S3,S2           //Moves result to S3 which takes up 16 cycles
    BX LR
        .end

// Results:
// Half word address = X…XX1 penalty: 2 cycles/instruction
// Takes two cycles because of address alignement.
// Full word address = X…X01 penalty: 301 cycles/instruction
// Exlanation: Becuase X...X00 aligned, but X...X01 is not properly aligned. The word is split into two physcial words, so processor get 2 bytes at a time.
// Full word address = X…X10 penalty: 201 cycles/instruction
// Explanation: Because X...X00 is properly algined and X...X10 has a trailing 10 alignment.
// Full word address = X…X11 penalty: 301 cycles/instruction
// Explanation: Because X...X00 is properly aligned and X...X11 has a trailing 11 alignment. 
// Address dependency penalty:        400 cycles/instruction
// Explanation: When we load from the memory, then we copy the value. The problem is that we have to wait for previous instruction to finish. 
// Data dependency penalty:           401 cycles/instruction
// Explanantion: There is a problem that S1 can not be used in arithemtic operations until it is not outputted. We must wait until the instruction finishes because we need results from previous instructions. 
// Maximum VDIV/VSQRT overlap:        16  clock cycles
//Explanation: VDIV takes 14 cycles (free the process) and VMOV takes one more cycle in order to move the result.