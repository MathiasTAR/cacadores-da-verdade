extends Control
class_name TelaDialogo

var _step: float = 0.05
var _idText: int = 0
var data: Dictionary = {}
var _is_typing: bool = false

@export_category("Objects")
@export var _name: Label = null
@export var _dialog: RichTextLabel = null
@export var _faceset: TextureRect = null

signal dialog_finished  # Adicionar sinal

func _ready() -> void:
	_initialize_dialog()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("advance_message"):
		if _is_typing:
			# Pular animação de digitação
			_complete_typing()
		else:
			# Avançar para próximo diálogo
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
	
	# Carregar texture com verificação de erro
	var texture = load(data[_idText]["faceset"])
	if texture:
		_faceset.texture = texture
	
	# Resetar e iniciar animação
	_dialog.visible_characters = 0
	_is_typing = true
	_start_typing_animation()

func _start_typing_animation() -> void:
	var total_chars: int = _dialog.get_total_character_count()
	
	for i in range(total_chars + 1):
		if not _is_typing:  # Se o jogador pulou a animação
			break
		_dialog.visible_characters = i
		await get_tree().create_timer(_step).timeout
	
	_is_typing = false

func _complete_typing() -> void:
	_is_typing = false
	_dialog.visible_characters = -1  # Mostra todos os caracteres

func _finish_dialog() -> void:
	dialog_finished.emit()  # Emitir sinal antes de fechar
	queue_free()

# Garantir que o sinal seja emitido mesmo se fechado abruptamente
func _exit_tree() -> void:
	if _idText >= data.size() - 1:
		dialog_finished.emit()
