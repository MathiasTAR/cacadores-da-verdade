extends StaticBody2D

@onready var exclamacao = $Area2D/Sprite2D
@onready var PainelVerdadeHUD = $"../PainelVerdade"
var _playerAreaPainelVerdade = false
var _painelVerdadeActive = false

func _ready() -> void:
	# Permite que este node processe mesmo quando pausado
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	# abrir painel
	if _playerAreaPainelVerdade and Input.is_action_just_pressed("interact") and !_painelVerdadeActive:
		if exclamacao:
			exclamacao.hide()
		_painelVerdadeActive = true
		_startPainelVerdade()
		
	# fechar painel com ESC
	if _painelVerdadeActive and Input.is_action_just_pressed("ui_cancel"):
		_closePainelVerdade()

func _startPainelVerdade():
	_playerAreaPainelVerdade = false
	PainelVerdadeHUD.show()
	get_tree().paused = true

func _closePainelVerdade():
	PainelVerdadeHUD.hide()
	get_tree().paused = false
	_painelVerdadeActive = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if exclamacao:
		exclamacao.show()
	_playerAreaPainelVerdade = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if exclamacao:
		exclamacao.hide()
	_playerAreaPainelVerdade = false
