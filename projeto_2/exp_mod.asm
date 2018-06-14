	.data
		Modulo: .asciiz "Informe o divisor (provavel primo): "
		Base: .asciiz "Informe a base: "
		Expoente: .asciiz "Informe o expoente: "
		Primo: .asciiz "Eh primo! "
		Erro: .asciiz "O modulo nao eh primo! "
		quebra_linha: .asciiz "\n"
		Resultado1 : .asciiz "A�exponencial�modular�"
		Resultado2 : .asciiz " elevado�a�"
		Resultado3 : .asciiz " (mod�"
		Resultado4 : .asciiz ") eh "
		Ponto : .asciiz "."
	.text

le_inteiro: # Funcao para ler a base, o expoente e o possivel primo.

	li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
	la $a0,Base # Carrega o argumento em $a0.
	syscall # Chamada de funcao.

	li $v0,5 # Le um numero inteiro.
	syscall # Chamada de funcao.
	
	move $s1,$v0 # Move o conteudo de $v0 para o $s1 (BASE).
	
	add $t8,$zero,$s1 # Salva a base em $t8 para usar para impressao.
	
	add $s3,$s1,$zero # Salva a base em $s3 para multiplicar ate chegar no expoente desejado.
	
	li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
	la $a0,Expoente # Carrega o argumento em $a0.
	syscall # Chamada de funcao.

	li $v0,5 # Le um numero inteiro.
	syscall # Chamada de funcao.
	
	move $s2,$v0 # Move o conteudo de $v0 para o $s2 (EXPOENTE).
	add $t9,$zero,$s2 # Salva o expoente em $t9 para usar para impressao.

	li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
	la $a0,Modulo # Carrega o argumento em $a0.
	syscall # Chamada de funcao.

	li $v0,5 # Le um numero inteiro.
	syscall # Chamada de funcao.
	
	move $s0,$v0 # Move o conteudo de $v0 para o $s2 (POSSIVEL PRIMO OU DIVISOR).
	
	add $s4,$s0,$zero # Adiciona o conteudo de $s0 (DIVISOR) em $s4.
	
	addi $s6,$zero,1 # Inicializa $s6 com valor 1.
	
	addi $s7,$zero,2 # Inicializa $s7 com valor 2.
	
	beq $s4,1,imprime_erro # Se o divisor for igual a 1, imprimir erro.
	
	beq $s4,2,calc_exp # Se o divisor for igual a 2, pular direto pro calc_exp.
	
sqrt:
	mul $t0,$s5,2 # Salva em $t0 a multiplicacao de $s5 por 2.
	add $t0,$t0,1 # Incrementa em 1 o registrador $t0.
	sub $s0,$s0,$t0 # Salva em $s5 a subtracao de $s0 por $t0.
	add $s5,$s5,1 # Incrementa em 1 o registrador $s1.
	#li $v0,1 # Imprime um inteiro.
	#move $a0,$s5 # Move o conte�do de $t3 para $a0.
	#syscall # Chamada de funcao.
	blt $s0,$zero,eh_primo # Verifica se o $s0 � menor ou igual a zero que acabou de calcular a raiz ou se nao for exata o proximo numero da raiz quebrada.
	j sqrt	# Caso nao ocorra o caso acima, itera novamente.
	
		
eh_primo: # Funcao para verificar se o numero eh primo.
	
	addi $t7,$t7,1 # Incrementa em 1 o $t0.
	div $s4,$t7 # Faz a divisao de $s4 por $t7, manda o resultado da divisao inteira para o LO e o resto para o HI.
	mfhi $t6 # Manda o conteudo de HI (resto da divis�o) para o $t6.
	beq $t6,$zero,incrementa # Se o $t6 (resto) nao for igual a zero, retorna para o label eh_primo.
				 # Se o $t6 (resto) for igual a zero, incrementa em 1 o $t1 para contar quantos divisores tera.
	bne $t7,$s5,eh_primo # Se o $t7 (divisor) nao for igual a $s5, retorna para o label eh_primo.
			     # $s5 eh o numero final (possivel primo),
			     # o codigo faz a divis�o at� chegar nele para contar quantas divisoes sem resto foram obtidas.		     
	#bne $t5,1,imprime_erro # Se o $t1 n�o for igual a 2 (divisoes sem resto) imprime erro, pois n�o eh primo.
	j calc_exp # Pula para o label calc_dividendo.
	
incrementa:

	addi $t5,$t5,1 # Incrementa em 1 o $t5.
	bgt $t5,1,imprime_erro
	
	j eh_primo # Pula para o label eh_primo.
	
calc_exp: # Calcula o dividendo (base elevada ao expoente inseridos no inicio do programa).

	bgt $s1,$s4,base_maior # Se a base for maior que o m�dulo va para base_maior.
		
	div $s2,$s7 # Se a base for menor, divide o expoente por dois.
	mfhi $t3 # Passa o resto para $t3.
	mflo $t4 # Passa o resultado da divisao para $t4.
	
	beq $t3,$zero,base_ao_quadrado # Se nao houver resto, va para base_ao_quadrado.
	
	beq $s2,1,final_calc_exp # Quando o expoente for igual a 1, va para final_calc_exp.
	
	subi $s2,$s2,1 # Se o expoente for impar, subtraia um dele.
	
	mul $s6,$s6,$s1 # Multiplique a base pelo registrador que esta guardando a outra parte para fazer o modulo.
	
	bgt $s6,$s4,temporario_maior # Se o temporario for maior que o modulo, va para temporario_maior.
	
	j calc_exp # Pula para calc_exp.
	
	
temporario_maior:

	div $s6,$s4 # Divide a base pelo divisor.
	
	mfhi $s6 # Salvar o modulo temporario.
	
	j calc_exp # Pula para calc_exp.
	
base_maior:
	
	div $s1,$s4 # Divide a base pelo divisor.
	
	mfhi $s1 # Salva o modulo da base.
	
	j calc_exp # Pula para calc_exp.
	
	
base_ao_quadrado:
	
	mul $s1,$s1,$s1 # Eleva $s1 ao quadrado.
	
	move $s2,$t4 # Move o conteudo de $t4 para $s2
	
	j calc_exp # Pula para calc_exp
	
final_calc_exp:
	
	mul $s1,$s1,$s6 # Salva em $s1 o conteudo da multiplicacao de $s1 por $s6.
	
	div $s1,$s4 # Faz a divisao de $s1 por $s4.
	
	mfhi $t3 # Passa o resto para $t3.
	
	j imprime_sucesso

imprime_sucesso:
	
	li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
	la $a0,Resultado1 # Carrega o argumento em $a0.
	syscall # Chamada de funcao.
	
	li $v0,1 # Imprime um inteiro.
	move $a0,$t8 # Move o conteudo de $t8 para $a0.
	syscall # Chamada de funcao.
	
	li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
	la $a0,Resultado2 # Carrega o argumento em $a0.
	syscall # Chamada de funcao.
	
	li $v0,1 # Imprime um inteiro.
	move $a0,$t9 # Move o conte�do de $t9 para $a0.
	syscall # Chamada de funcao.
	
	li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
	la $a0,Resultado3 # Carrega o argumento em $a0.
	syscall # Chamada de funcao.
	
	li $v0,1 # Imprime um inteiro.
	move $a0,$s4 # Move o conte�do de $s4 para $a0.
	syscall # Chamada de funcao.
	
	li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
	la $a0,Resultado4 # Carrega o argumento em $a0.
	syscall # Chamada de funcao.
	
	li $v0,1 # Imprime um inteiro.
	move $a0,$t3 # Move o conte�do de $t3 para $a0.
	syscall # Chamada de funcao.
	
	li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
	la $a0,Ponto # Carrega o argumento em $a0.
	syscall # Chamada de funcao.
	
	j Exit # Pula para o label Exit.
	
	
imprime_erro: # Imprime uma mensagem de erro caso o modulo nao seja primo.
	
	li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
	la $a0,Erro # Carrega o argumento em $a0.
	syscall # Chamada de funcao.
	
	j Exit # Pula para o label Exit.
	
Exit: # Label que finaliza o programa.
	
