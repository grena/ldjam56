extends CanvasLayer

const MAX_FUEL = 200.0  # Le maximum de carburant correspondant à 100%

# Référence au QuadMesh qui représente la jauge de fuel
@onready var niveau_fuel = $JaugeFuel #$Jauge.find_child('NiveauFuel')
@onready var position_origin = niveau_fuel.position.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_parent().get_node('Player')
	#clamp(player.FUEL, 0, MAX_FUEL)  # S'assurer que la valeur de fuel est entre 0 et 200
	var fuel_percentage = player.FUEL / MAX_FUEL # 200 fuel = 100% donc on calcule le pourcentage
	# Appliquer la mise à jour de la taille (échelle) de la jauge en fonction de fuel_percentage
	# On suppose ici que la hauteur de la jauge est liée à son échelle sur l'axe Y
	#niveau_fuel.scale.y = fuel_percentage  # Ajuster l'échelle Y en fonction du pourcentage
	#print('coucou', niveau_fuel.scale.y)
	niveau_fuel.size.y = fuel_percentage * 100   # Ajuster l'échelle Y en fonction du pourcentage
	print(niveau_fuel.size.y)
	niveau_fuel.position.y = position_origin - fuel_percentage * 100 
