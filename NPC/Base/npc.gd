extends Node2D
class_name npc

# Cenas de diálogo
const _TELAPEQUENADIALOGO: PackedScene = preload("res://Dialog/DialogoTelaPequeno/tela_dialogo.tscn")
const _TELAGRANDEDIALOGO: PackedScene = preload("res://Dialog/DialogoTelaGrande/telaGrande_dialogo.tscn")

# Configurações básicas
@export_category("NPC Settings")
@export var _speed: float = 75.0
@export var _pause_min: float = 2.0
@export var _pause_max: float = 5.0
@export var _moving: bool = true

# Sistema de rotina
@export_category("Routine System") 
@export var _use_routine: bool = false
@export var _routine_points: Array[Vector2] = []
@export var _wait_times: Array[float] = []

# Diálogo
@export_category("Dialogue")
@export var _hud: CanvasLayer = null
@export var _dialog_data: Dictionary = {}

# Variáveis internas
var _moving_forward: bool = true
var _dialogActive: bool = false
var _playerAreaDialog: bool = false
var _current_routine_index: int = 0
var _is_moving_to_point: bool = false

var anim: AnimatedSprite2D
var caminho: PathFollow2D
var dialogBox: Sprite2D

func _ready():
	# Configura para processar mesmo quando pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if anim:
		anim.play("Idle")
	
	if _use_routine and not _routine_points.is_empty():
		_start_routine()

func _physics_process(delta):
	# Não processar movimento se o jogo estiver pausado
	if get_tree().paused and !_dialogActive:
		if anim and anim.animation != "Idle":
			anim.play("Idle")
		return
	
	if _playerAreaDialog and Input.is_action_just_pressed("interact") and !_dialogActive:
		if dialogBox:
			dialogBox.hide()
		_dialogActive = true
		_startDialog()
	
	if _moving and !_dialogActive and !get_tree().paused:
		if _use_routine and not _routine_points.is_empty():
			_routine_movement(delta)
		elif caminho:
			_path_movement(delta)

# Movimento com Path2D
func _path_movement(delta):
	if _moving_forward:
		caminho.progress += _speed * delta
		if caminho.progress_ratio >= 1.0:
			_stop_and_wait()
	else:
		caminho.progress -= _speed * delta
		if caminho.progress_ratio <= 0.0:
			_stop_and_wait()
	
	_update_direction()

# Sistema de rotina
func _start_routine():
	_current_routine_index = 0
	_is_moving_to_point = true

func _routine_movement(delta):
	if _is_moving_to_point:
		var target_point = _routine_points[_current_routine_index]
		var direction = (target_point - global_position).normalized()
		
		global_position += direction * _speed * delta
		
		# Atualiza animação
		if anim:
			if abs(direction.x) > abs(direction.y):
				anim.play("Direita" if direction.x > 0 else "Esquerda")
			else:
				anim.play("Baixo" if direction.y > 0 else "Cima")
		
		# Verifica se chegou
		if global_position.distance_to(target_point) < 5.0:
			_reached_routine_point()

func _reached_routine_point():
	_is_moving_to_point = false
	if anim:
		anim.play("Idle")
	
	var wait_time = _get_wait_time_for_point(_current_routine_index)
	await get_tree().create_timer(wait_time).timeout
	
	_current_routine_index = (_current_routine_index + 1) % _routine_points.size()
	_is_moving_to_point = true

func _get_wait_time_for_point(point_index: int) -> float:
	return _wait_times[point_index] if point_index < _wait_times.size() else 3.0

# Atualização de direção para Path2D
func _update_direction():
	if not anim or not caminho or not caminho.get_parent() or not caminho.get_parent().curve:
		return
	
	var curve = caminho.get_parent().curve
	var current_progress = caminho.progress
	var lookahead = 5.0 if _moving_forward else -5.0
	var next_progress = clamp(current_progress + lookahead, 0.0, curve.get_baked_length())
	
	var current_pos = curve.sample_baked(current_progress)
	var next_pos = curve.sample_baked(next_progress)
	var direction = next_pos - current_pos
	
	if abs(direction.x) > abs(direction.y):
		anim.play("Direita" if direction.x > 0 else "Esquerda")
	else:
		anim.play("Baixo" if direction.y > 0 else "Cima")

# Pausa entre movimentos
func _stop_and_wait():
	_moving = false
	if anim:
		anim.play("Idle")
	
	await get_tree().create_timer(randf_range(_pause_min, _pause_max)).timeout
	
	_moving = true
	_moving_forward = !_moving_forward

# Sinais de área (conectar na classe filha)
func _on_area_entered(area: Area2D):
	if dialogBox:
		dialogBox.show()
	_playerAreaDialog = true
	_moving = false
	_is_moving_to_point = false
	if anim:
		anim.play("Idle")

func _on_area_exited(area: Area2D):
	if dialogBox:
		dialogBox.hide()
	_playerAreaDialog = false
	if !_dialogActive and !get_tree().paused:
		_moving = true
		if _use_routine and not _routine_points.is_empty():
			_is_moving_to_point = true

# Sistema de diálogo
func _startDialog():
	_playerAreaDialog = false
	get_tree().paused = true  # Usa o sistema de pausa do Godot
	_moving = false
	_is_moving_to_point = false
	if anim:
		anim.play("Idle")
	
	var _new_dialog = _TELAGRANDEDIALOGO.instantiate()
	_new_dialog.data = _dialog_data
	_new_dialog.dialog_finished.connect(_on_dialog_finished)
	_hud.add_child(_new_dialog)

func _on_dialog_finished():
	_dialogActive = false
	get_tree().paused = false  # Usa o sistema de pausa do Godot
	if !_playerAreaDialog:
		_moving = true
		if _use_routine and not _routine_points.is_empty():
			_is_moving_to_point = true
