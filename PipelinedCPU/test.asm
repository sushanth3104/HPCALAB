# RAW hazard: a1 depends on a0 immediately
    addi a0, zero, 5        # a0 = 5
    add  a1, a0, a0         # RAW hazard: a1 = a0 + a0

    # Load-use hazard: a3 uses a2 right after lw
    sw  a0,0(a0)
    lw   a2, 0(a0)          # load word from memory[a0] into a2
    add  a3, a2, a0         # lw stall: using a2 right after lw

    # Branch: taken path
    addi a4, zero, 10       # a4 = 10
    addi a5, zero, 10       # a5 = 10
    beq  a4, a5, target     # branch taken

    addi a6, zero, 1        # skipped if branch is taken

target:
    addi a6,zero,-4
    # jal: jump to function
    jal  ra, func

    addi a7, zero, 255      # executed after returning from func
    beq x0,x0,end

func:
    addi s0, zero, 42       # inside function
    jalr zero, ra, 0        # return to caller
    
end:
    addi s0,zero,-100
