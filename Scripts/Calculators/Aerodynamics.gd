class_name Aerodynamics
extends Node

const MAX_ITERATIONS = 100
const TOLERANCE = 0.00001

# --- FUNÇÃO PRINCIPAL ---
# Retorna o Beta (Ângulo da Onda) em GRAUS
static func calculate_weak_beta(mach: float, theta_deg: float, gamma: float = 1.4) -> float:
	# 1. Validação Básica
	if mach <= 1.0: 
		printerr("Erro: Mach deve ser > 1.0 para haver choque oblíquo.")
		return -1.0
	
	if theta_deg <= 0.0:
		return asin(1.0/mach) * (180.0/PI) # Retorna onda de Mach (sem deflexão)

	# 2. Definição dos Limites de Busca
	# Limite Inferior: Ângulo da Onda de Mach (Mu)
	# O Beta nunca pode ser menor que isso.
	var mu_rad = asin(1.0 / mach)
	var mu_deg = rad_to_deg(mu_rad)
	
	# Limite Superior: 85 graus (Evita singularidade de 90 graus no solver)
	# A solução FRACA (que queremos) está sempre mais perto de Mu do que de 90.
	var min_beta = mu_deg + 0.1 
	var max_beta = 85.0
	
	# 3. Solver (Bisseção Robusta)
	for i in range(MAX_ITERATIONS):
		var mid_beta = (min_beta + max_beta) / 2.0
		
		# Calcula qual Theta esse Beta geraria
		var theta_calculated = _get_theta_from_beta_math(mach, mid_beta, gamma)
		
		# Se deu erro matemático (ex: raiz negativa), aborta
		if is_nan(theta_calculated):
			return -1.0
			
		# Checa se achamos a resposta (Diferença pequena entre o Theta que queremos e o calculado)
		if abs(theta_calculated - theta_deg) < TOLERANCE:
			return mid_beta
			
		# Lógica de Direção da Bisseção
		# Na curva Theta-Beta (lado fraco), se aumentamos Beta, Theta aumenta.
		if theta_calculated < theta_deg:
			min_beta = mid_beta # Precisamos aumentar o Beta
		else:
			max_beta = mid_beta # Precisamos diminuir o Beta
			
	# Se acabou as iterações e não convergiu (provavelmente choque destacado)
	printerr("Aviso: Solução não convergiu. Possível Choque Destacado para M=%.2f, Theta=%.1f" % [mach, theta_deg])
	return -1.0

# --- A MATEMÁTICA PURA (Onde o erro costuma morar) ---
static func _get_theta_from_beta_math(m: float, beta_deg: float, gamma: float) -> float:
	# CONVERSÃO CRÍTICA: Tudo aqui dentro tem que ser radianos
	var beta = deg_to_rad(beta_deg)
	
	var m2 = m * m
	var sin_b = sin(beta)
	var cos_2b = cos(2.0 * beta)
	var tan_b = tan(beta)
	
	# Evita divisão por zero no cotangente
	if abs(tan_b) < 0.000001: return 0.0
	
	# Fórmula: tan(theta) = 2 * cot(beta) * (...)
	# cot(beta) é 1.0 / tan(beta)
	
	var numerador = (m2 * (sin_b * sin_b)) - 1.0
	var denominador = (m2 * (gamma + cos_2b)) + 2.0
	
	# Se denominador for zero (muito raro), retorna erro
	if denominador == 0: return NAN
	
	var tan_theta = (2.0 / tan_b) * (numerador / denominador)
	
	# Retorna em GRAUS para comparar com o input do solver
	return rad_to_deg(atan(tan_theta))
