          .text                         
          .globl main                   

          .data                         
          .align 2                      
_Main:                                  # virtual table
          .word 0                       # parent
          .word _STRING0                # class name

          .data                         
          .align 2                      
_Fibonacci:                             # virtual table
          .word 0                       # parent
          .word _STRING1                # class name
          .word _Fibonacci.get          



          .text                         
_Main_New:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L15:                                   
          li    $t0, 4                  
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          move  $t1, $v0                
          la    $t0, _Main              
          sw    $t0, 0($t1)             
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     

_Fibonacci_New:                         # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L16:                                   
          li    $t0, 4                  
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          move  $t1, $v0                
          la    $t0, _Fibonacci         
          sw    $t0, 0($t1)             
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     

main:                                   # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -28           
_L17:                                   
          jal   _Fibonacci_New          
          move  $t0, $v0                
          move  $t1, $t0                
          li    $t0, 0                  
          sw    $t0, -8($fp)            
          sw    $t1, -12($fp)           
_L18:                                   
          lw    $t0, -8($fp)            
          li    $t1, 10                 
          slt   $t1, $t0, $t1           
          sw    $t0, -8($fp)            
          beqz  $t1, _L20               
_L19:                                   
          lw    $t1, -12($fp)           
          lw    $t0, -8($fp)            
          sw    $t1, 4($sp)             
          sw    $t0, 8($sp)             
          lw    $t2, 0($t1)             
          lw    $t2, 8($t2)             
          sw    $t0, -8($fp)            
          sw    $t1, -12($fp)           
          jalr  $t2                     
          move  $t2, $v0                
          lw    $t0, -8($fp)            
          lw    $t1, -12($fp)           
          sw    $t2, 4($sp)             
          sw    $t0, -8($fp)            
          sw    $t1, -12($fp)           
          jal   _PrintInt               
          lw    $t0, -8($fp)            
          lw    $t1, -12($fp)           
          la    $t2, _STRING2           
          sw    $t2, 4($sp)             
          sw    $t0, -8($fp)            
          sw    $t1, -12($fp)           
          jal   _PrintString            
          lw    $t0, -8($fp)            
          lw    $t1, -12($fp)           
          li    $t2, 1                  
          add   $t0, $t0, $t2           
          sw    $t0, -8($fp)            
          sw    $t1, -12($fp)           
          b     _L18                    
_L20:                                   
          lw    $t1, -12($fp)           
          sw    $t1, -12($fp)           
          jal   _ReadInteger            
          move  $t0, $v0                
          lw    $t1, -12($fp)           
          sw    $t1, 4($sp)             
          sw    $t0, 8($sp)             
          lw    $t0, 0($t1)             
          lw    $t0, 8($t0)             
          jalr  $t0                     
          move  $t0, $v0                
          sw    $t0, 4($sp)             
          jal   _PrintInt               
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     

_Fibonacci.get:                         # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
_L21:                                   
          lw    $t1, 8($fp)             
          li    $t0, 2                  
          slt   $t0, $t1, $t0           
          sw    $t1, 8($fp)             
          beqz  $t0, _L23               
_L22:                                   
          li    $t0, 1                  
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
_L23:                                   
          lw    $t1, 8($fp)             
          lw    $t3, 4($fp)             
          li    $t0, 1                  
          sub   $t0, $t1, $t0           
          sw    $t3, 4($sp)             
          sw    $t0, 8($sp)             
          lw    $t0, 0($t3)             
          lw    $t0, 8($t0)             
          sw    $t3, 4($fp)             
          sw    $t1, 8($fp)             
          jalr  $t0                     
          move  $t2, $v0                
          lw    $t3, 4($fp)             
          lw    $t1, 8($fp)             
          li    $t0, 2                  
          sub   $t0, $t1, $t0           
          sw    $t3, 4($sp)             
          sw    $t0, 8($sp)             
          lw    $t0, 0($t3)             
          lw    $t0, 8($t0)             
          sw    $t3, 4($fp)             
          sw    $t2, -8($fp)            
          sw    $t1, 8($fp)             
          jalr  $t0                     
          move  $t0, $v0                
          lw    $t3, 4($fp)             
          lw    $t2, -8($fp)            
          lw    $t1, 8($fp)             
          add   $t0, $t2, $t0           
          sw    $t3, 4($fp)             
          sw    $t1, 8($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     




          .data                         
_STRING2:
          .asciiz "\n"                  
_STRING1:
          .asciiz "Fibonacci"           
_STRING0:
          .asciiz "Main"                
