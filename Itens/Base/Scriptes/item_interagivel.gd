extends ItemBase
class_name ItemInteragivelBase

@export_category("Interactible Settings")
@export var _reusable: bool = false
@export var _required_item: String = ""
@export var _remove_required_item: bool = false

var _used: bool = false

func _use_item():
	if _used and !_reusable:
		return
	
	# Verifica se precisa de item específico
	if _required_item != "":
		if Global.has_item(_required_item):
			# Tem o item necessário
			if _remove_required_item:
				Global.remove_item(_required_item, 1)
			
			if !_dialog_data.is_empty():
				_start_dialog()
			else:
				_execute_item_behavior()
		else:
			# Não tem o item necessário
			_show_required_item_message()
	else:
		if !_dialog_data.is_empty():
			_start_dialog()
		else:
			_execute_item_behavior()

func _execute_item_behavior():
	_used = true
	
	# Se não for reutilizável, desativa
	if !_reusable:
		if has_node("CollisionShape2D"):
			$CollisionShape2D.disabled = true
		if interaction_icon:
			interaction_icon.hide()

func _show_required_item_message():
	if _hud:
		var required_dialog_data = {
			0: {
				"faceset": "",
				"facesetPlayer": "",
				"facesetNPC": "", 
				"dialog": "Você precisa de " + _required_item + " para usar isso!",
				"title": "Sistema"
			}
		}
		
		var _new_dialog = preload("res://Dialog/DialogoTelaPequeno/tela_dialogo.tscn").instantiate()
		_new_dialog.data = required_dialog_data
		_hud.add_child(_new_dialog)
