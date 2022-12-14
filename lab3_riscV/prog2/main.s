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
main:
.global main
 
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
 
  la a6, array_length #} 
  la a7, array
  addi sp, sp, -16 #выделение памяти в стеке 
  sw ra, 12(sp) # сохранение
  call shift 
  lw ra, 12(sp) # востанавливаем
  addi sp, sp, 16 # освобождение памяти в сетке

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
  ret