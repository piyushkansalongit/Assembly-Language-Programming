@ r0: Tracks the position of iterator in the loop in reverse order
@ r1: Tracks the position of iterator
@ r2: Starting address of the array
@ r3: Number of elements
@ r4: Loading and Unloading
@ r5: Loading and Unloading
@ r6: Calculates the offset during swapping
@ r7: 0 if the array isn't sorted and 1 if it is sorted.

.return:
    ret

.compare:
    sub r1, r3, r0
    mul r6, r1, 4
    add r6, r2, r6
    ld r4, [r6]
    ld r5, 4[r6]
    cmp r4, r5
    bgt .forwardpass @if failure occurs, continue with forwardpass again.
    sub r0, r0, 1
    b .check_loop @continue with the checking loop.

.checkpass:
    mov r0, r3 
    .check_loop:
        cmp r0, 1
        beq .return
        bgt .compare @send the elemets for comparison.

.store:
    st r4, 4[r6]
    st r5, [r6]
    sub r0, r0, 1
    cmp r0, 1
    beq .checkpass @call the checkpass if the iterator has reached the end.
    bgt .swap_loop @continue swapping

.swap:
    sub r1, r3, r0
    mul r6, r1, 4 
    add r6, r2, r6 @find the address of the first element
    ld r4, [r6]
    ld r5, 4[r6]
    cmp r4, r5
    bgt .store @store the swapped values if needed
    sub r0, r0, 1
    cmp r0, 1
    bgt .swap_loop
    beq .checkpass

.forwardpass:
    mov r0, r3 @iterator for the array
    .swap_loop:
        cmp r0, 1
        beq .checkpass @If swapping is finished, check if the array is sorted
        bgt .swap @ Check if the elements needs to be swapped, swap if requried.

.bubblesort:
    b .forwardpass
    
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
    mov r1, 45
    st r1, 24[r0]

    mov r2, 0 @set the starting address of the array.
    mov r3, 7 @set the size of the array

    call .bubblesort

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
    ld r1, 24[r0]
    .print r1
