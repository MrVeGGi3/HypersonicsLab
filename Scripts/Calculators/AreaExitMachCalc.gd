class_name AreaMachSolver
extends Node

const TOLERANCE = 0.000001
const MAX_ITERATIONS = 100

# Resolve a equação para encontrar o Mach (M) dado uma razão de área ao quadrado
# target_area_ratio_sq: O valor de (A/A*)^2
# gamma: Razão de calores específicos (ex: 1.4)
# supersonic: TRUE para achar a raiz supersônica (bocal), FALSE para subsônica (entrada)
static func get_mach_from_area_ratio_squared(target_area_ratio_sq: float, gamma: float = 1.4, supersonic: bool = true) -> float:
	# 1. Definição dos Limites de Busca
	var low = 0.0
	var high = 0.0
	
	# A relação A/A* é 1.0 em M=1. Então (A/A*)^2 também é 1.0.
	# Se o alvo for menor que 1.0, é impossível fisicamente (colocamos uma proteção)
	if target_area_ratio_sq < 1.0:
		return 1.0 # Garganta sônica
		
	if supersonic:
		# Região Supersônica: M > 1
		low = 1.0001
		high = 50.0 # Limite seguro para hipersônicos
	else:
		# Região Subsônica: M < 1
		low = 0.0001
		high = 0.9999

	# 2. Loop Numérico (Bisseção)
	for i in range(MAX_ITERATIONS):
		var mid = (low + high) / 2.0
		var val_mid = _calculate_area_sq_equation(mid, gamma)
		
		if abs(val_mid - target_area_ratio_sq) < TOLERANCE:
			return mid
			
		# Lógica de Direção:
		# A função (A/A*)^2 AUMENTA conforme nos afastamos de M=1 (seja pra cima ou pra baixo).
		# Portanto, se o valor calculado é MENOR que o alvo, precisamos nos afastar mais de 1.
		
		if val_mid < target_area_ratio_sq:
			# O valor está muito baixo, precisamos de um Mach mais "extremo"
			if supersonic:
				low = mid # Aumenta o Mach
			else:
				high = mid # Diminui o Mach (para se afastar de 1 para baixo)
		else:
			# O valor está muito alto, precisamos aproximar de 1
			if supersonic:
				high = mid # Diminui o Mach
			else:
				low = mid # Aumenta o Mach
				
	return (low + high) / 2.0

# Aplica a fórmula exata da imagem image_83b264.png
static func _calculate_area_sq_equation(M: float, gamma: float) -> float:
	var M2 = M * M
	
	# Termo 1: 1 / M^2
	var term1 = 1.0 / M2
	
	# Termo 2 (dentro do colchete): 2 / (gamma + 1)
	var term2_frac = 2.0 / (gamma + 1.0)
	
	# Termo 3 (parenteses): 1 + (gamma-1)/2 * M^2
	var term3_inner = 1.0 + ((gamma - 1.0) / 2.0) * M2
	
	# Expoente: (gamma + 1) / (gamma - 1)
	var exponent = (gamma + 1.0) / (gamma - 1.0)
	
	# Montagem final
	var bracket_content = term2_frac * term3_inner
	var result = term1 * pow(bracket_content, exponent)
	
	return result
