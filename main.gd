extends Node3D

@onready var icon_ci: Sprite2D = $IconCi
var ripp_shader

@onready var timer: Timer = $Timer

var start = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ripp_shader = icon_ci.material as ShaderMaterial
	ripp_shader.set_shader_parameter("enabled",false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	start += delta
	ripp_shader.set_shader_parameter("start_time",start)
	pass


func _on_button_pressed() -> void:
	start = 0.0
	set_process(true)
	ripp_shader.set_shader_parameter("start_time",0.0)
	ripp_shader.set_shader_parameter("enabled",true)
	timer.start()
	pass # Replace with function body.


#after adjusting the Speed of your shader, adjust the Wait Time accodingle to have the shader only play once
func _on_timer_timeout() -> void:
	ripp_shader.set_shader_parameter("start_time",Time)
	ripp_shader.set_shader_parameter("enabled",false)
	set_process(false)
	pass # Replace with function body.
