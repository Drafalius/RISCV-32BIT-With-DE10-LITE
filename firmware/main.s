lui  x6, 0x80000    
addi x7, x6, 4  
addi x1, x0, 8        
addi x3, x0, 0        
addi x4, x0, 1     
sw   x3, 0(x6)       
sw   x3, 0(x7)        
sw   x4, 0(x6)      
sw   x4, 0(x7)      
addi x2, x0, 2     
LOOP:
    add  x5, x3, x4  
    sw   x5, 0(x6)   
    sw   x5, 0(x7)  
    add  x3, x4, x0  
    add  x4, x5, x0  
    addi x2, x2, 1    
    bne  x2, x1, LOOP 
END:
    jal  x0, 0    