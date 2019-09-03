@ r0, r1 kept for common operations
@ r2 stores the stating address of the array
@ r3 stores the size of the array
@ r4 is the start pointer for the array
@ r5 is the mid pointer for the array
@ r6 is the end pointer for the array
@ r7 is used for temporary arithmetic
@ r8, r9 are used for swapping business

.return:
    ret

.store:
    st r10, [r9]
    st r11, [r8]
    ret
.swap:  
    mul r10, r4, 4
    mul r11, r6, 4
    add r8, r2, r10
    add r9, r2, r11
    ld r10, [r8]
    ld r11, [r9]
    cmp r10, r11
    bgt .store
    ret

.addfirsttobuffer:
    sub sp, sp, 4
    st r10, [sp]
    add r8, r8, 4
    b .join
    
.addsecondtobuffer:
    sub sp, sp, 4
    st r11, [sp]
    add r9, r9, 4
    b .join

.addelementsoffirst:
    cmp r8, r12
    beq .return
    sub sp, sp, 4
    ld r10, [r8]
    st r10, [sp]
    add r8, r8, 4
    b .addelementsoffirst
    ret

.addelementsofsecond:
    cmp r9, r13
    beq .return
    sub sp, sp, 4
    ld r11, [r9]
    st r11, [sp]
    add r9, r9, 4
    b .addelementsofsecond
    ret

.replace:
    cmp r4, r6
    bgt .return
    mul r11, r6, 4
    add r11, r11, r2
    ld r10, [sp]
    st r10, [r11]
    sub r6, r6, 1
    add sp, sp, 4
    b .replace

.join:
    cmp r8, r12 @Elements of second array are added if first one is empty.
    beq .addelementsofsecond 
    cmp r9, r13
    beq .addelementsoffirst @Elements of the first array are added if the second one is empty.
    ld r10, [r8]
    ld r11, [r9]
    cmp r10, r11
    bgt .addsecondtobuffer @second element is put first if it is smaller
    b .addfirsttobuffer @Put first in buffer if it is smaller.
    
.mergejoin:
    mul r8, r4, 4 @r8 stores our curret position in the first array.
    mul r9, r5, 4 @r9 stores our current position in the second array.
    add r8, r2, r8
    add r9, r2, r9
    add r9, r9, 4

    mov r12, r9    @Get the size of the first array.

    mul r13, r6, 4
    add r13, r2, r13
    add r13, r13, 4 @Get the size of the second array.

    sub sp, sp, 4
    st ra, [sp]
    call .join
    call .replace @Put the elements from the buffer in the registers back.
    ld ra, [sp]
    add sp, sp, 4
    ret
                                       
.split:
    sub sp, sp, 16  @Create some stack space.
    st r4, [sp]     @start pointer
    st r5, 4[sp]    @mid pointer
    st r6, 8[sp]    @end pointer
    st ra, 12[sp]
    mov r6, r5      @Creating the left child.
    add r5, r4, r6
    div r5, r5, 2

    call .mergesort @Recursively dividing the left array

    ld r6, 8[sp]
    ld r5, 4[sp]
    ld r4, [sp]
    add r4, r5, 1   @creating the right child
    add r5, r4, r6
    div r5, r5, 2
    call .mergesort @Recursively sort the right child

    ld ra, 12[sp]
    ld r6, 8[sp]
    ld r5, 4[sp]
    ld r4, [sp]
    add sp, sp, 16


    sub sp, sp, 4
    st ra, [sp]
    call .mergejoin @Join the two sorted arrays back.
    ld ra, [sp]
    add sp, sp, 4
    ret

.mergesort:
    sub r7, r6, r4
    cmp r7, 0
    beq .return
    cmp r7, 1
    beq .swap       @if size of the array is just 2, send it to the swap functionality.
    bgt .split      @Keep splitting the array
    ret 

.main:
    mov r0, 0

    mov r1, 12
    st r1, 0[r0]
    mov r1, 7
    st r1, 4[r0]
    mov r1, 4
    st r1, 8[r0]
    mov r1, -17
    st r1, 12[r0]
    mov r1, 15
    st r1, 16[r0]
    mov r1, -33
    st r1, 20[r0]

    mov r2, 0
    mov r3, 6

    mov r4, 0
    sub r6, r3, 1
    div r5, r6, 2
    call .mergesort

    mov r0, r2
    ld r1, 0[r0]
    .print r1
    ld r1, 4[r0]
    .print r1
    ld r1, 8[r0]
    .print r1
    ld r1, 12[r0]
    .print r1
    ld r1, 16[r0]
    .print r1
    ld r1, 20[r0]
    .print r1
