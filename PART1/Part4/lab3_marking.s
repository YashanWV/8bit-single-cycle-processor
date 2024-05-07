loadi 0 0x05   // r4 = 5
loadi 1 0x09   // r1 = 9
mov 2 1        // r2 = r1
add 3 2 0      // r3 = r2 + r0
loadi 5 0x0E   // r5 = E
beq 0x01 3 5   // If r3 = r5 Branch to Adress 0x01
j 0x02         // Jump to Address 0x02
j 0x03         // Jump to Address 0x03
j 0x04         // Jump to Address 0x04