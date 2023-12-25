extends ColorRect

@onready var _sprite = get_parent().get_node("Sprite2D")

func _ready():
	material = material.duplicate()
	material.set_shader_parameter("sprite_size", size)
	material.set_shader_parameter("piece_size", _sprite.piece_size)
	material.set_shader_parameter("offset", _sprite.piece_offset)
	material.set_shader_parameter("padding", Vector2(20, 20))
	material.set_shader_parameter("up_type", _sprite.up_type)
	material.set_shader_parameter("down_type", _sprite.down_type)
	material.set_shader_parameter("left_type", _sprite.left_type)
	material.set_shader_parameter("right_type", _sprite.right_type)
	material.set_shader_parameter("CIRCLE_RADIUS", _sprite.circle_radius)
	material.set_shader_parameter("height_draw", true)

func update() -> void:
	if _sprite == null:
		return
	material.set_shader_parameter("up_type", _sprite.up_type)
	material.set_shader_parameter("down_type", _sprite.down_type)
	material.set_shader_parameter("left_type", _sprite.left_type)
	material.set_shader_parameter("right_type", _sprite.right_type)
