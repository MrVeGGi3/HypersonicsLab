class_name  AtmosfericProperties
extends Properties


var actual_height : float
var _table_data : Array = []

func _ready() -> void:
	gamma = GAMMA_AIR
	gas_constant = AIR_SPECIFIC_GAS_CONSTANT
	_load_csv("res://Data/dados_atmosfera.csv")
	
func _load_csv(path : String):
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		print("Arquivo não encontrado")
		return
	
	file.get_csv_line()
	
	while file.get_position() < file.get_length():
		var line = file.get_csv_line()
		if line.size() > 6:
			_table_data.append(
				{
					"z": float(line[0]),
					"temp": float(line[2]),
					"press": float(line[3]),
					"dens": float(line[5])
				}
			)

func update_conditions_at(altitude : float):
	actual_height = altitude
	var chosen_row = {}
	if altitude <= _table_data[0]["z"]:
		chosen_row = _table_data[0]
	elif altitude >= _table_data[-1]["z"]:
		chosen_row = _table_data[-1]
	else:
		for i in range(_table_data.size()-1):
			var z_low = _table_data[i]["z"]
			var z_high = _table_data[i+1]["z"]
			
			if altitude >= z_low and altitude <= z_high:
				var dist_low = abs(altitude - z_low)
				var dist_high = abs(altitude - z_high)
				
				if dist_low < dist_high:
					chosen_row = _table_data[i]
				else:
					chosen_row = _table_data[i+1]
				break
				
	if chosen_row.is_empty():
		return
	
	temp_kelvin = chosen_row["temp"]
	pressure_pa = pressure_mbar_to_pa(chosen_row["press"])
	density_kg_m3 = chosen_row["dens"]
	
	
