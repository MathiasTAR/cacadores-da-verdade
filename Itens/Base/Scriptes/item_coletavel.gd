extends ItemBase
class_name ItemColetavelBase

@export_category("Collectible Settings")
@export var _add_inventory: bool = true

func _use_item():
	if !_dialog_data.is_empty():
		_start_dialog()
	else:
		_execute_item_behavior()

func _execute_item_behavior():
	if _add_inventory:
		_addInventory()
	
	queue_free()

func _addInventory():
	print("Adicionado ao inventário: ")
