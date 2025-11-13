extends Control

func _ready():
	$MarcadorHome.pressed.connect(_on_home_pressed)
	$MarcadorBacklog.pressed.connect(_on_backlog_pressed)
	$MarcadorDeduction.pressed.connect(_on_deduction_pressed)

func _on_home_pressed():
	# Muda para aba 0 (Home)
	get_parent().get_parent().set_current_tab(0)

func _on_backlog_pressed():
	# Muda para aba 1 (Backlog)
	get_parent().get_parent().set_current_tab(1)

func _on_deduction_pressed():
	# Muda para aba 2 (Painel de Dedução)
	get_parent().get_parent().set_current_tab(2)
