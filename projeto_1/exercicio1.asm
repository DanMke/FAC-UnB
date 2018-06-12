.data				# segmento de dados

	var: .word 0x55555555	# carrega a palavra com 0x55555555
.text				# inicio de segmento de codigo
	
main: 
	lw $s1,var		# carrega o registrador $s1 com a palavra var
	sll $s2,$s1,1		# desloca para a esquerda o $s1 em 1 bit e salva em $s2
	or $s3,$s1,$s2		# faz o OU lógico bit-a-bit de $s1 com $s2 e salva em $s3
	and $s4,$s1,$s2		# faz o E lógico bit-a-bit de $s1 com $s2 e salva em $s4
	xor $s5,$s1,$s2		# faz o OU EXCLUSIVO lógico bit-a-bit de $s1 com $s2 e salva em $s5
