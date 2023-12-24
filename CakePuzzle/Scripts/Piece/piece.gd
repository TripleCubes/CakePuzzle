extends Button

var TextureSize: Vector2:
	get:
		return Vector2($Sprite2D.texture.get_width(), $Sprite2D.texture.get_height())

var piece_size: Vector2:
	set(val):
		$Sprite2D.piece_size = val

var piece_offset: Vector2:
	set(val):
		$Sprite2D.piece_offset = val

var up_type: int:
	set(val):
		$Sprite2D.up_type = val
	get:
		return $Sprite2D.up_type

var down_type: int:
	set(val):
		$Sprite2D.down_type = val
	get:
		return $Sprite2D.down_type

var left_type: int:
	set(val):
		$Sprite2D.left_type = val
	get:
		return $Sprite2D.left_type

var right_type: int:
	set(val):
		$Sprite2D.right_type = val
	get:
		return $Sprite2D.right_type

var up_piece = null
var down_piece = null
var left_piece = null
var right_piece = null



var _previous_pos: Vector2
var _previous_mouse_pos: Vector2

var _holding: = false:
	set(val):
		if (_holding == val):
			return
		_holding = val
		
		_previous_pos = position
		_previous_mouse_pos = get_global_mouse_position()

		move_to_front()

func _process(_delta):
	if not _holding:
		return

	position = _previous_pos + (get_global_mouse_position() - _previous_mouse_pos)

func _on_button_down():
	_holding = true

func _on_button_up():
	_holding = false
