extends Area2D
class_name ItemBase

# Configurações básicas
@export_category("Item Settings")
@export var _item_name: String = "Item"
@export var _consumable: bool = false
@export var _max_quantity: int = 1

# Diálogo
@export_category("Dialogue")
@export var _hud: CanvasLayer = null
@export var _dialog_data: Dictionary = {}

# Variáveis internas
var _item_active: bool = false
var _player_near: bool = false
var interaction_icon: Sprite2D

func _ready():
	# Configura para processar mesmo quando pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if interaction_icon:
		interaction_icon.hide()

func _physics_process(delta):
	if _player_near and Input.is_action_just_pressed("interact") and !_item_active:
		if interaction_icon:
			interaction_icon.hide()
		_item_active = true
		_use_item()

# sobrescrito pelas classes filhas
func _use_item():

	pass

func _start_dialog():
	_item_active = true
	get_tree().paused = true
	
	var _new_dialog = preload("res://Dialog/DialogoTelaPequeno/tela_dialogo.tscn").instantiate()
	_new_dialog.data = _dialog_data
	_new_dialog.dialog_finished.connect(_on_dialog_finished)
	_hud.add_child(_new_dialog)

func _on_dialog_finished():
	_item_active = false
	get_tree().paused = false
	
	# Executa o comportamento específico do item após o diálogo
	_execute_item_behavior()
	
	if !_player_near:
		_reset_item()

func _execute_item_behavior():
	# Comportamento específico do item - sobrescrever nas classes filhas
	pass

func _reset_item():
	# Resetar estado do item se necessário
	pass

func _on_area_entered(area: Area2D):
	_player_near = true
	if interaction_icon:
		interaction_icon.show()

func _on_area_exited(area: Area2D):
	_player_near = false
	if interaction_icon:
		interaction_icon.hide()
	if !_item_active:
		_reset_item()
