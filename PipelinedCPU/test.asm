# s7 = y
main:addi a0, zero, 2 # argument 0 = 2
addi a1, zero, 2 # argument 1 = 3
addi a2, zero, 4 # argument 2 = 4
addi a3, zero, 5 # argument 3 = 5
jal diffofsums # call function
add s7, a0, zero # y = returned value
jal end

# s3 = result
diffofsums:
add t0, a0, a1 # t0 = f+g
add t1, a2, a3 # t1 = h+i
sub s3, t0, t1 # result = (f+g)−(h+i)
add a0, s3, zero # put return value in a0
jr ra # return to caller

end:
    addi x0,x0,0