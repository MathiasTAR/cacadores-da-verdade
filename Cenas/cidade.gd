extends Node2D
class_name Cidade

const _TELAPEQUENADIALOGO: PackedScene = preload("res://Dialog/DialogoTelaPequeno/tela_dialogo.tscn")
const _TELAGRANDEDIALOGO: PackedScene = preload("res://Dialog/DialogoTelaGrande/telaGrande_dialogo.tscn")

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

@export_category("Objects")
@export var _hud: CanvasLayer = null

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_select"):
		var _new_dialog: TelaDialogo = _TELAPEQUENADIALOGO.instantiate()
		_new_dialog.data = _dialog_data
		_hud.add_child(_new_dialog)
