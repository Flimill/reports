#10. Циклический сдвиг массива чисел на заданное количество разрядов влево. 
.globl __start

.rodata # неизменяемые данные
msg1: .string "Number of shifts to the left: "
msg2: .string "The resulting array: {"
msg3: .string "}"
comma: .string ", "
array_length:
  .word 5
.data # изменяемые данные
array: # изменяемый массив
  .word 0, 1, 2, 3, 4
    
.text
__start:
  #печать "Number of shifts to the left: "
  li a0, 4
  la a1, msg1
  ecall
  #чтение количества сдвигов и запись в t2
  li a0, 5
  ecall
  mv t2, a0
  #перенос на новую строку
  li a0, 11
  li a1, '\n'
  ecall
  #печать "The resulting array: {"
  li a0, 4
  la a1, msg2
  ecall
  beq t2, zero, print_res # if(t2==zero) goto printRes
  la a6, array_length
  la a7, array # a4 = <адрес 0-го элемента массива>
loop1:
  li t0, 0 # t0 = 0
  li t1, 0 # t1 = 0
  la a3, array_length #} 
  lw a3, 0(a3)  #} a3 = <длина массива> 
  la a4, array # a4 = <адрес 0-го элемента массива>
  slli a2, a3, 2 # a2 = <длина массива> * 4
  add a4, a4, a2 # a4 = <адрес 0-го элемента массива> + <длина массива> * 4
loop2:
  addi a4, a4, -4 # a4 = a4 - 4
  addi a3, a3, -1 # a3 = a3 - 1
  lw a5, 0(a4) # a5 = элемент массиыв
  mv t1, t0  # t1 = t0
  mv t0, a5  # t0 = a5
  sw t1, 0(a4)  # элемент массиыв = t1
  beq a3, zero, continue # if(a3==zero) goto continue
  j loop2 #goto loop2
continue:
  la a3, array_length #} 
  lw a3, 0(a3)  #} a3 = <длина массива> 
  la a4, array # a4 = <адрес 0-го элемента массива>
  slli a2, a3, 2 # a2 = <длина массива> * 4
  add a4, a4, a2 # a4 = <адрес 0-го элемента массива> + <длина массива> * 4
  addi a4, a4, -4 # a4 = a4 - 4 <адрес последнего элемента массива> 
  sw t0, 0(a4) # последний элемент массива = t0
    addi t2, t2, -1 # t2 = t2 - 1
  beq t2, zero, print_res # if(t2==zero) goto printRes
  j loop1
print_res:
  la a3, array_length #} 
  lw a3, 0(a3)  #} a3 = <длина массива> 
  la a4, array # a4 = <адрес 0-го элемента массива>
print_loop:
  lw a5, 0(a4) # a5 = элемент массиыв
  #печать элемента массива
  li a0, 1
  mv a1, a5
  ecall
  addi a4, a4, 4 # a4 = a4 - 1
  addi a3, a3, -1  # a3 = a3 - 1
  beq a3, zero, finish # if(a3==zero) goto continue
  # печать ", "
  li a0, 4
  la a1, comma
  ecall
  j print_loop # goto finloop
finish:
  # печать "}"
  li a0, 4
  la a1, msg3
  ecall
  li a0, 10 # x10 = 10 
  ecall # ecall при значении x10 = 10 => останов симулятора