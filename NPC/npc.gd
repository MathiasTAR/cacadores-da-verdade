extends Node2D
class_name npc

@onready var anim = $Path2D/PathFollow2D/npc/AnimatedSprite2D
@onready var caminho = $Path2D/PathFollow2D

@onready var dialogBox = $Path2D/PathFollow2D/Area2D/Sprite2D

const _TELAPEQUENADIALOGO: PackedScene = preload("res://Dialog/DialogoTelaPequeno/tela_dialogo.tscn")
const _TELAGRANDEDIALOGO: PackedScene = preload("res://Dialog/DialogoTelaGrande/telaGrande_dialogo.tscn")

@export_category("NPC Settings")
@export var _speed: float = 75.0
@export var _pause_min: float = 2.0
@export var _pause_max: float = 5.0

@export_category("HUD Dialog")
@export var _hud: CanvasLayer = null

@export_category("Debug")
@export var _moving: bool = true
@export var _playerAreaDialog: bool = false
var _moving_forward: bool = true
var _dialogActive: bool = false

func _ready():
	anim.play("Direita")

func _physics_process(delta):
	if (_playerAreaDialog and Input.is_action_just_pressed("interact") and !_dialogActive):
		dialogBox.hide()
		_startDialog()
	
	if _moving and !Global.Paused:
		if _moving_forward:
			caminho.progress += _speed * delta
			if caminho.progress_ratio >= 1.0:
				_stop_and_wait()
		else:
			caminho.progress -= _speed * delta
			if caminho.progress_ratio <= 0.0:
				_stop_and_wait()
		
		_update_direction()

func _update_direction():
	var curve = caminho.get_parent().curve
	if curve:
		var current_progress = caminho.progress
		var lookahead = 5.0 if _moving_forward else -5.0
		var next_progress = clamp(current_progress + lookahead, 0.0, curve.get_baked_length())
		
		var current_pos = curve.sample_baked(current_progress)
		var next_pos = curve.sample_baked(next_progress)
		var direction = next_pos - current_pos
		
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				anim.play("Direita")
			else:
				anim.play("Esquerda")
		else:
			if direction.y > 0:
				anim.play("Baixo")
			else:
				anim.play("Cima")

func _stop_and_wait():
	_moving = false
	anim.play("Idle")
	
	await get_tree().create_timer(randf_range(_pause_min, _pause_max)).timeout
	
	_moving = true
	_moving_forward = !_moving_forward

	
func _on_area_2d_area_entered(area: Area2D) -> void:
	dialogBox.show()
	_playerAreaDialog = true
	
	_moving = false  # Para de andar imediatamente
	anim.play("Idle")


func _on_area_2d_area_exited(area: Area2D) -> void:
	dialogBox.hide()
	_playerAreaDialog = false
	# Volta a se mover após o player sair
	_moving = true
	
func _startDialog():
	print_debug("Iniciando diálogo com NPC")
	_dialogActive = true
	Global.Paused = true
	_moving = false
	anim.play("Idle")
	
	var _new_dialog: TelaGrandeDialogo = _TELAGRANDEDIALOGO.instantiate()
	_new_dialog.data = _dialog_data
	
	# Conectar o sinal
	_new_dialog.dialog_finished.connect(_on_dialog_finished)
	
	_hud.add_child(_new_dialog)

func _on_dialog_finished():
	print_debug("Diálogo terminado")
	Global.Paused = false
	if !_playerAreaDialog:
		_moving = true
	

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://icon.svg",
		"facesetPlayer": "res://idle1.png",  # Para TelaGrandeDialogo
		"facesetNPC": "res://icon.svg",  # Para TelaGrandeDialogo
		"dialog": "Olá Teste de fala, como voce está?",
		"title": "Maria"
	},
	
	1: {
		"faceset": "res://icon.svg",
		"facesetPlayer": "res://idle1.png",  # Para TelaGrandeDialogo
		"facesetNPC": "res://icon.svg",  # Para TelaGrandeDialogo
		"dialog": "A cidade esta vazia hoje né?",
		"title": "Maria"
	},
	
	2: {
		"faceset": "res://sprite_3.png",
		"facesetPlayer": "res://idle1.png",  # Para TelaGrandeDialogo
		"facesetNPC": "res://sprite_3.png",  # Para TelaGrandeDialogo
		"dialog": "Como que aumenta a fonte? tem muuuuuito espaço aqui",
		"title": "Turing"
	},
	
	3: {
		"faceset": "res://ICONEMASCOTE-export.png",
		"facesetPlayer": "res://idle1.png",  # Para TelaGrandeDialogo
		"facesetNPC": "res://TRIBUNA1.png",  # Para TelaGrandeDialogo
		"dialog": "Sou eu! Mascote da LADG, qual o jogo de hoje?, so que agora grande",
		"title": "Ladzin"
	},
	
	4: {
		"faceset": "res://ICONEMASCOTE-export.png",
		"facesetPlayer": "res://idle1.png",  # Para TelaGrandeDialogo
		"facesetNPC": "res://icon.svg",  # Para TelaGrandeDialogo
		"dialog": "Agora cabe muuuuuuuito mais texto, vou ter que aumentar a fonte",
		"title": "Ladzin"
	},
	
	5: {
		"faceset": "res://TRIBUNA1.png",
		"facesetPlayer": "",  # Para TelaGrandeDialogo
		"facesetNPC": "res://TRIBUNA1.png",  # Para TelaGrandeDialogo
		"dialog": "Teste de tamanho de sprites, sera que pode emoji?\n 🤔🤔🤔",
		"title": "Tribuna"
	},
}
