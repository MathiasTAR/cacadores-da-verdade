extends Control
class_name TelaGrandeDialogo

var _step: float = 0.05
var _idText: int = 0
var data: Dictionary = {}
var _is_typing: bool = false

@export_category("Objects")
@export var _name: Label = null
@export var _dialog: RichTextLabel = null
@export var _facesetPlayer: TextureRect = null
@export var _facesetNPC: TextureRect = null

signal dialog_finished

func _ready() -> void:
	_initialize_dialog()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if _is_typing:
			_complete_typing()
		else:
			_idText += 1
			if _idText >= data.size():
				_finish_dialog()
				return
			_initialize_dialog()

func _initialize_dialog() -> void:
	if _idText >= data.size():
		_finish_dialog()
		return
	
	_name.text = data[_idText]["title"]
	_dialog.text = data[_idText]["dialog"]
	
	var player_texture = load(data[_idText]["facesetPlayer"])
	var npc_texture = load(data[_idText]["facesetNPC"])
	
	if player_texture:
		_facesetPlayer.texture = player_texture
	if npc_texture:
		_facesetNPC.texture = npc_texture
	
	_dialog.visible_characters = 0
	_is_typing = true
	_type_text()

func _type_text() -> void:
	var text_length = _dialog.get_total_character_count()
	
	for i in range(text_length + 1):
		if not _is_typing:
			return
		_dialog.visible_characters = i
		await get_tree().create_timer(_step).timeout
	
	_is_typing = false

func _complete_typing() -> void:
	_is_typing = false
	_dialog.visible_characters = -1

func _finish_dialog() -> void:
	dialog_finished.emit()
	queue_free()
