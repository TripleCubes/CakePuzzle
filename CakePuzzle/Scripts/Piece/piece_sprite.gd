extends Sprite2D

var piece_size: = Vector2(50, 50)
var piece_offset: = Vector2(0, 0)
var up_type: int = 0
var down_type: int = 0
var left_type: int = 0
var right_type: int = 0

func _ready():
	material = material.duplicate()
	material.set_shader_parameter("sprite_size", Vector2(texture.get_width(), texture.get_height()))
	material.set_shader_parameter("piece_size", piece_size)
	material.set_shader_parameter("offset", piece_offset)
	material.set_shader_parameter("padding", Vector2(20, 20))
	material.set_shader_parameter("up_type", up_type)
	material.set_shader_parameter("down_type", down_type)
	material.set_shader_parameter("left_type", left_type)
	material.set_shader_parameter("right_type", right_type)
	material.set_shader_parameter("height_draw", false)

func update():
	material.set_shader_parameter("up_type", up_type)
	material.set_shader_parameter("down_type", down_type)
	material.set_shader_parameter("left_type", left_type)
	material.set_shader_parameter("right_type", right_type)
