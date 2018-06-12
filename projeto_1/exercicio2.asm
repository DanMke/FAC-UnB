.data					# segmento de dados

		var: .word 0x0000FACE	# carrega a palavra com 0x0000FACE
.text					# inicio de segmento de codigo
	
main: 
	lw $s1,var			# movimenta os dados da palavra var para o registrador $s1

	add $s3,$zero,0x0000F000	# $s3 recebe 0x0000F000
	and $s3,$s1,$s3			# faz o OU lógico bit-a-bit de $s1 e $s3 e salva em $s3
	srl $s3,$s3,8			# desloca para a direita o $s3 em 8 bits e salva em $s3

	add $s4,$zero,0x000000F0	# $s4 recebe 0x000000F0
	and $s4,$s1,$s4			# faz o OU lógico bit-a-bit de $s1 e $s4 e salva em $s4
	sll $s4,$s4,8			# desloca para a esquerda o $s4 em 8 bits e salva em $s4

	add $s5,$zero,0x00000F0F	# $s5 recebe 0x00000F0F
	and $s5,$s1,$s5			# faz o OU lógico bit-a-bit de $s1 e $s5 e salva em $s5
	
	xor $s2,$s2,$s3			# faz o OU EXCLUSIVO lógico bit-a-bit de $s2 e $s3 e salva em $s2
	xor $s2,$s2,$s4			# faz o OU EXCLUSIVO lógico bit-a-bit de $s2 e $s4 e salva em $s2
	xor $s2,$s2,$s5			# faz o OU EXCLUSIVO lógico bit-a-bit de $s2 e $s5 e salva em $s2
