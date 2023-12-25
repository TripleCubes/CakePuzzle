extends Button

var TextureSize: Vector2:
	get:
		return Vector2($Sprite2D.texture.get_width(), $Sprite2D.texture.get_height())

var piece_size: Vector2:
	set(val):
		$Sprite2D.piece_size = val
	get:
		return $Sprite2D.piece_size

var piece_offset: Vector2:
	set(val):
		$Sprite2D.piece_offset = val
	get:
		return $Sprite2D.piece_offset

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
var up_connected = false
var down_connected = false
var left_connected = false
var right_connected = false

var grid_size: Vector2i
var index: Vector2i



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
	_move_connected_pieces()

func _move_connected_pieces():
	if not _holding:
		return

	_flood(self, func(data):
		data.piece.position = _previous_pos + (get_global_mouse_position() - _previous_mouse_pos) \
									+ Vector2((data.index.x - index.x) * piece_size.x, \
												(data.index.y - index.y) * piece_size.y)
	)

func _move_connected_pieces_2(first_piece, pos: Vector2) -> void:
	_flood(first_piece, func(data):
		data.piece.position = pos + Vector2((data.index.x - first_piece.index.x) * piece_size.x, \
												(data.index.y - first_piece.index.y) * piece_size.y)
	)

func _flood(first_piece, f: Callable) -> void:
	var check_list: = []
	for y in grid_size.y:
		check_list.append([])
		for x in grid_size.x:
			check_list[y].append(false)

	var queue: = [{
		index = first_piece.index,
		piece = first_piece,
	}]

	while queue.size() != 0:		
		var data = queue.pop_back()
		check_list[data.index.y][data.index.x] = true

		if data.piece.up_connected and not check_list[data.index.y - 1][data.index.x]:
			var append_data = {
				index = Vector2i(data.index.x, data.index.y - 1),
				piece = data.piece.up_piece,
			}
			queue.append(append_data)
		if data.piece.down_connected and not check_list[data.index.y + 1][data.index.x]:
			var append_data = {
				index = Vector2i(data.index.x, data.index.y + 1),
				piece = data.piece.down_piece,
			}
			queue.append(append_data)
		if data.piece.left_connected and not check_list[data.index.y][data.index.x - 1]:
			var append_data = {
				index = Vector2i(data.index.x - 1, data.index.y),
				piece = data.piece.left_piece,
			}
			queue.append(append_data)
		if data.piece.right_connected and not check_list[data.index.y][data.index.x + 1]:
			var append_data = {
				index = Vector2i(data.index.x + 1, data.index.y),
				piece = data.piece.right_piece,
			}
			queue.append(append_data)

		f.call(data)

func _on_button_down():
	_holding = true

func _on_button_up():
	_holding = false
	_check_connect()

func _check_connect() -> void:
	_flood(self, func(data):
		var p = data.piece
		if not p.up_connected and p.up_piece != null:
			if _in_range(p.up_piece.position, p.position + Vector2(0, -p.piece_size.y), Vector2(10, 10)):
				_move_connected_pieces_2(p, p.up_piece.position + Vector2(0, piece_size.y))
				p.up_connected = true
				p.up_piece.down_connected = true

		if not p.down_connected and p.down_piece != null:
			if _in_range(p.down_piece.position, p.position + Vector2(0, p.piece_size.y), Vector2(10, 10)):
				_move_connected_pieces_2(p, p.down_piece.position + Vector2(0, -piece_size.y))
				p.down_connected = true
				p.down_piece.up_connected = true

		if not p.left_connected and p.left_piece != null:
			if _in_range(p.left_piece.position, p.position + Vector2(-p.piece_size.x, 0), Vector2(10, 10)):
				_move_connected_pieces_2(p, p.left_piece.position + Vector2(piece_size.x, 0))
				p.left_connected = true
				p.left_piece.right_connected = true

		if not p.right_connected and p.right_piece != null:
			if _in_range(p.right_piece.position, p.position + Vector2(p.piece_size.x, 0), Vector2(10, 10)):
				_move_connected_pieces_2(p, p.right_piece.position + Vector2(-piece_size.x, 0))
				p.right_connected = true
				p.right_piece.left_connected = true
	)

func _in_range(pos1: Vector2, pos2: Vector2, r: Vector2) -> bool:
	if pos1.x < pos2.x - r.x:
		return false
	
	if pos1.y < pos2.y - r.y:
		return false

	if pos1.x > pos2.x + r.x:
		return false

	if pos1.y > pos2.y + r.y:
		return false

	return true
