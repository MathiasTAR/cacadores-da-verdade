extends Node

var inventory= []

# Variável para controlar estados do jogo
var game_paused: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func add_item(item_name: String, quantity: int = 1):
	# Procura se o item já existe
	for item in inventory:
		if item["name"] == item_name:
			item["quantity"] += quantity
			return
	
	# Se não existe, adiciona novo
	inventory.append({"name": item_name, "quantity": quantity})
	
	# Atualiza UI
	update_inventory_ui()

func remove_item(item_name: String, quantity: int = 1):
	for i in range(inventory.size()):
		if inventory[i]["name"] == item_name:
			inventory[i]["quantity"] -= quantity
			if inventory[i]["quantity"] <= 0:
				inventory.remove_at(i)
			
			# Atualiza UI
			update_inventory_ui()
			return

func has_item(item_name: String) -> bool:
	# Procura pelo item no inventario
	for item in inventory:
		if item["name"] == item_name:
			return true
	return false

func get_item_quantity(item_name: String) -> int:
	# Pega quantidade de um item
	for item in inventory:
		if item["name"] == item_name:
			return item["quantity"]
	return 0

func update_inventory_ui():
	# Emite sinal para a UI atualizar
	inventory_updated.emit()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	game_paused = !game_paused
	get_tree().paused = game_paused

# Sinal para UI
signal inventory_updated
