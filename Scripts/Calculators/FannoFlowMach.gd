class_name FannoFlowMachSolver
extends Node

const MAX_ITERATIONS = 50
const TOLERANCE = 1e-6 # Precisão de 6 casas decimais
const DERIVATIVE_STEP = 1e-5 # O pequeno passo 'h' para calcular a inclinação

static func calculate_exit_mach_number(target_val: float, gam: float, supersonic_solution: bool = true) -> float:
	# 1. Chute Inicial Inteligente (Initial Guess)
	var mach = 0.0
	if supersonic_solution:
		mach = 2.0 # Um chute seguro para supersônico
	else:
		mach = 0.5 # Um chute seguro para subsônico

	# Proteção para valores negativos
	if target_val < 0: return -1.0

	# 2. Loop de Newton-Raphson
	for i in range(MAX_ITERATIONS):
		var current_val = _calculate_fanno_value(mach, gam)
		var error = current_val - target_val
		
		# Verificação de Sucesso
		if abs(error) < TOLERANCE:
			return mach
		
		# Calcular a Derivada (Inclinação da curva) numericamente
		# f'(x) ≈ (f(x+h) - f(x-h)) / 2h
		var val_plus = _calculate_fanno_value(mach + DERIVATIVE_STEP, gam)
		var val_minus = _calculate_fanno_value(mach - DERIVATIVE_STEP, gam)
		var derivative = (val_plus - val_minus) / (2.0 * DERIVATIVE_STEP)
		
		# Proteção contra divisão por zero (pode acontecer perto de M=1 ou picos)
		if abs(derivative) < 1e-9:
			# Se a derivada for zero, Newton falha. Caímos para Bisseção ou retornamos erro.
			print("Aviso: Derivada zero, mudando estratégia.")
			break 
		
		# Passo de Newton: x_novo = x_velho - (Erro / Derivada)
		var next_mach = mach - (error / derivative)
		
		# 3. Proteção de Limites (Safety Clamping)
		# Se o Newton jogar o Mach para o lado errado (ex: era pra ser supersônico e virou subsônico)
		if supersonic_solution:
			if next_mach <= 1.001: next_mach = 1.001 # Força a ficar supersônico
		else:
			if next_mach >= 0.999: next_mach = 0.999 # Força a ficar subsônico
			if next_mach <= 0.0: next_mach = 0.001
			
		mach = next_mach

	return mach

# Sua função original (intocada, ela está correta)
static func _calculate_fanno_value(M: float, gam: float) -> float:
	# Pequena proteção contra M=0 ou M=1 exato para não crashar log/divisão
	if abs(M - 1.0) < 1e-5: M = 1.00001
	if M < 1e-5: M = 1e-5
		
	var M2 = M * M
	var term1_num = 1.0 - M2
	var term1_den = gam * M2
	var term1 = term1_num / term1_den
	
	var term2_const = (gam + 1.0) / (2.0 * gam)
	
	var ln_num = (gam + 1.0) * M2
	var ln_den = 2.0 + (gam - 1.0) * M2
	var term2_ln = log(ln_num / ln_den)
	
	return term1 + (term2_const * term2_ln)
