@ r2 stores the starting address of the array
@ r3 stores the size of the array
@ r4 stores the start pointer for quicksort
@ r5 stores the end pointer for quicksort
@ r6 is used to store array size during recursion
@ r7 stores the value of pivot which is set at the beginning of the array.
@ r8 stores the length of leftchild during recursion.
@ r9 stores the length of rightchild during recursion.
@ r10 is used as the iterator
@ r11, r12 is used to maintain the temporary value and positons.

.return:
    ret

.transfer:
    sub r1, r10, r4
    mul r1, r1, 4
    mul r11, r10, 4
    sub r12, r6, r1
    sub r12, r12, 4
    add sp, sp, r12
    ld r13, [sp]
    st r13, [r11]
    sub sp, sp, r12
    add r10, r10, 1
    b .saveChild

.saveChild:
    cmp r10, r5
    bgt .return
    b .transfer

.pushupside:
    add r10, r10, 1
    mul r12, r8, 4
    add sp, sp, r6
    sub sp, sp, 4
    sub sp, sp, r12
    st r11, [sp]
    add sp, sp, 4
    add sp, sp, r12
    sub sp, sp, r6
    add r8, r8, 1
    b .createChild @Continue the child creation process

.pushdownside:
    add r10, r10, 1
    mul r12, r9, 4
    add sp, sp, r12
    st r11, [sp]
    sub sp, sp, r12
    add r9, r9, 1
    b .createChild @Continue the child creation process.

.pushinside:
    mul r11, r10, 4
    ld r11, [r11]
    cmp r11, r7
    bgt .pushdownside @Keep the larger elements down in the array.
    b   .pushupside @Keep the smaller or equal elements up in the array.

.createChild:
    cmp r5, r10
    beq .return
    bgt .pushinside @Send the element to be pushed to a array in the stack.
    ret

.quicksort:
    cmp r4, r5 @the starting pointer should be smaller than the end pointer.
    bgt .return
    beq .return
    sub sp, sp, 16 @Create an activation block.
    st r6, 12[sp]
    st r4, 8[sp]
    st r5, 4[sp]
    st ra, [sp]

    mul r7, r5, 4
    ld r7, [r7] @Load the value of the pivot.
    sub sp, sp, r6
    mov r10, r4
    mov r8, 0 @Iterator for the size of the left children.
    mov r9, 0 @Iterator for the size of the right child.
    call .createChild @Divide the about the pivot
    
    mul r11, r9, 4
    add sp, sp, r11
    st r7, [sp]
    sub sp, sp, r11
    mov r10, r4
    
    call .saveChild @Once the array children has been created, shift them back to the registers.
    add sp, sp, r6


    add r5, r4, r8
    sub r5, r5, 1
    sub r6, r5, r4
    add r6, r6, 1
    mul r6, r6, 4
    call .quicksort @Repeat the process for the left child.
    ld r5, 4[sp]
    ld r4, 8[sp]

    add r4, r4, r8
    add r4, r4, 1
    sub r6, r5, r4
    add r6, r6, 1
    mul r6, r6, 4
    call .quicksort @Repeat the process for the right child.
    ld ra, [sp]
    ld r5, 4[sp]
    ld r4, 8[sp]
    ld r6, 12[sp]
    add sp, sp, 16
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
    mov r1, 12
    st r1, 24[r0]
    mov r1, 7
    st r1, 28[r0]
    mov r1, 4
    st r1, 32[r0]
    mov r1, -17
    st r1, 36[r0]
    mov r1, 15
    st r1, 40[r0]
    mov r1, -33
    st r1, 44[r0]

    mov r2, 0
    mov r3, 12

    mov r4, 0 @starting pointer for the quicksort.
    sub r5, r3, 1 @end pointer for the quicksort.
    mov r6, r3
    mul r6, r6, 4 @Total memory size of the array.
    call .quicksort

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
    mov r0, r2
    ld r1, 24[r0]
    .print r1
    ld r1, 28[r0]
    .print r1
    ld r1, 32[r0]
    .print r1
    ld r1, 36[r0]
    .print r1
    ld r1, 40[r0]
    .print r1
    ld r1, 44[r0]
    .print r1