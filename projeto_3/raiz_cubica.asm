.data
	radicando: .asciiz "Informe o radicando: "
	resultado_raiz : .asciiz "A raiz cubica eh "
	resultado_erro : .asciiz "O erro eh menor que "
	ponto : .asciiz ". "
	numero_1: .double 1.0
	numero_2: .double 2.0
	numero_3: .double 3.0
	tolerancia: .double 0.000000000001

.text

	le_float: # faz a leitura da variavel digitada pelo usuario.
		li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
		la $a0,radicando # Carrega o argumento em $a0.
		syscall # Chamada de funcao.

		li $v0,7 # Le um numero ponto flutuante precisao dupla.
		syscall # Chamada de funcao.

		add.d $f12, $f0, $f10 # Salva o double lido em $f12

		j inicializar_variaveis # pula para o inicializar_variaveis.

	inicializar_variaveis:
		ldc1 $f2,numero_1 # Carrega o numero1 (1.0) em $f2
		ldc1 $f4,numero_2 # Carrega o numero2 (2.0) em $f4
		ldc1 $f6,numero_3 # Carrega o numero3 (3.0) em $f6
		ldc1 $f16,tolerancia # Carrega a tolerancia de erro em $f16

		div.d $f6,$f2,$f6 # Carrega em $f6 o resultado de 1/3 para o metodo de newton

		j calc_raiz # Pula para o calc_raiz.

	calc_raiz: # Encontra a raiz por meio do metodo de newton.
	# A condicao de parada eh a diferenca entre a raiz encontrada ao cubo e o radicando digitado
	# ser menor do que 10^-12.
	# A diferenca eh calculada em calc_erro.

		mul.d $f8,$f2,$f4 # 2 * f2
		mul.d $f10,$f2,$f2 # f2 * f2
		div.d $f14,$f12,$f10 # f12 / (f2*f2)

		add.d $f14,$f14,$f8 # (2*f2) + (f12 / (f2*f2))

		mul.d $f2,$f6,$f14 # 1/3 * [(2*f2) + (f12 / (f2*f2))]

		# Metodo de newton -> Xi+1 = 1/3 * [(2*Xi) + (C / (Xi*Xi))]

		j calc_erro # Pula para o calc_erro.

	calc_erro: # Faz o calculo do erro entre a raiz encontrada ao cubo e o radicando digitado.

		mul.d $f18,$f2,$f2 # Eleva ao quadrado a raiz encontrada.
		mul.d $f18,$f18,$f2 # Eleva ao cubo a raiz encontrada.

		sub.d $f20,$f18,$f12 # subtrai a raiz encontrada ao cubo e o radicando.

		abs.d $f20,$f20 # faz o modulo de $f20.

		c.lt.d $f16,$f20 # compara se $f16 eh menor que $f20, se for falso marca a flag 0.

		bc1t calc_raiz # se for true a condicao, ele volta pro calc_raiz

		j imprime_saida # pula para o label imprime_saida

	imprime_saida: # faz a impressao das saidas.

		li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
		la $a0,resultado_raiz # Carrega o argumento em $a0.
		syscall # Chamada de funcao.

		li $v0,3 # Carregando $v0, passo1 = carregar numero no registrador $v0, 3 = printar um double.
		mov.d $f12,$f2 # Carrega o argumento em $a0.
		syscall # Chamada de funcao.

		li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
		la $a0,ponto # Carrega o argumento em $a0.
		syscall # Chamada de funcao.

		li $v0,4 # Carregando $v0, passo1 = carregar numero no registrador $v0, 4 = printar uma string.
		la $a0,resultado_erro # Carrega o argumento em $a0.
		syscall # Chamada de funcao.

		li $v0,3 # Carregando $v0, passo1 = carregar numero no registrador $v0, 3 = printar um double.
		mov.d $f12,$f20 # Carrega o argumento em $a0.
		syscall # Chamada de funcao.

		j exit # Pula para o label exit.

	exit: # Finaliza o programa.
		li $v0, 10 # Encerra o programa
		syscall # Chamada de funcao.
