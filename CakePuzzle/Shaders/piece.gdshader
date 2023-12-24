shader_type canvas_item;

const int TYPE_FLAT = 0;
const int TYPE_IN = 1;
const int TYPE_OUT = 2;
const int TYPE_ROUND_TOP_LEFT = 3;
const int TYPE_ROUND_TOP_RIGHT = 4;
const int TYPE_ROUND_BOTTOM_LEFT = 5;
const int TYPE_ROUND_BOTTOM_RIGHT = 6;

const float CIRCLE_RADIUS = 10.0f;
const float CORNER_CIRCLE_RADIUS = 10.0f;

uniform vec2 sprite_size;
uniform vec2 piece_size = vec2(100.0f, 100.0f);
uniform vec2 offset = vec2(500.0f, 500.0f);
uniform vec2 padding = vec2(20.0f, 20.0f);
uniform int up_type;
uniform int down_type;
uniform int left_type;
uniform int right_type;

float get_circle_alpha(vec2 center, float r, vec2 pos) {
	const float BORDER_SIZE = 1.0f;

	float dist = distance(center, pos);
	if (dist > r) {
		return -1.0f;
	}

	if (dist < r - BORDER_SIZE) {
		return 1.0f;
	}

	return (r - dist) / BORDER_SIZE;
}

float piece_side_check(int type, vec2 circle_center, float r, vec2 pos) {
	float a = get_circle_alpha(circle_center, r, pos);
	if (a < 0.0f) {
		return -1.0f;
	}

	if (type == TYPE_IN) {
		return a;
	} else if (type == TYPE_OUT) {
		return 1.0f - a;
	}
}

float get_a_inner(vec2 pos, vec2 uv2) {
	float a = 1.0f;

	if (uv2.y < uv2.x && uv2.y < 1.0f - uv2.x) {
		if (up_type == TYPE_IN) {
			vec2 circle_center = vec2(piece_size.x / 2.0f, 0.0f);
			a = 1.0f - get_circle_alpha(circle_center, CIRCLE_RADIUS, pos);
		}

		if (up_type == TYPE_ROUND_TOP_LEFT) {
			vec2 circle_center = vec2(CORNER_CIRCLE_RADIUS, CORNER_CIRCLE_RADIUS);
			if (pos.x < circle_center.x && pos.y < circle_center.y) {
				a = get_circle_alpha(circle_center, CORNER_CIRCLE_RADIUS, pos);
			}
		}

		if (up_type == TYPE_ROUND_TOP_RIGHT) {
			vec2 circle_center = vec2(piece_size.x - CORNER_CIRCLE_RADIUS, CORNER_CIRCLE_RADIUS);
			if (pos.x > circle_center.x && pos.y < circle_center.y) {
				a = get_circle_alpha(circle_center, CORNER_CIRCLE_RADIUS, pos);
			}
		}
	}

	if (uv2.x < uv2.y && uv2.x > 1.0f - uv2.y) {
		if (down_type == TYPE_IN) {
			vec2 circle_center = vec2(piece_size.x / 2.0f, piece_size.y);
			a = 1.0f - get_circle_alpha(circle_center, CIRCLE_RADIUS, pos);
		}

		if (down_type == TYPE_ROUND_BOTTOM_LEFT) {
			vec2 circle_center = vec2(CORNER_CIRCLE_RADIUS, piece_size.y - CORNER_CIRCLE_RADIUS);
			if (pos.x < circle_center.x && pos.y > circle_center.y) {
				a = get_circle_alpha(circle_center, CORNER_CIRCLE_RADIUS, pos);
			}
		}

		if (down_type == TYPE_ROUND_BOTTOM_RIGHT) {
			vec2 circle_center = vec2(piece_size.x - CORNER_CIRCLE_RADIUS, piece_size.y - CORNER_CIRCLE_RADIUS);
			if (pos.x > circle_center.x && pos.y > circle_center.y) {
				a = get_circle_alpha(circle_center, CORNER_CIRCLE_RADIUS, pos);
			}
		}
	}

	if (uv2.x < uv2.y && uv2.x < 1.0f - uv2.y) {
		if (left_type == TYPE_IN) {
			vec2 circle_center = vec2(0.0f, piece_size.y/2.0f);
			a = 1.0f - get_circle_alpha(circle_center, CIRCLE_RADIUS, pos);
		}

		if (left_type == TYPE_ROUND_TOP_LEFT) {
			vec2 circle_center = vec2(CORNER_CIRCLE_RADIUS, CORNER_CIRCLE_RADIUS);
			if (pos.x < circle_center.x && pos.y < circle_center.y) {
				a = get_circle_alpha(circle_center, CORNER_CIRCLE_RADIUS, pos);
			}
		}

		if (left_type == TYPE_ROUND_BOTTOM_LEFT) {
			vec2 circle_center = vec2(CORNER_CIRCLE_RADIUS, piece_size.y - CORNER_CIRCLE_RADIUS);
			if (pos.x < circle_center.x && pos.y > circle_center.y) {
				a = get_circle_alpha(circle_center, CORNER_CIRCLE_RADIUS, pos);
			}
		}
	}

	if (uv2.y < uv2.x && uv2.y > 1.0f - uv2.x) {
		if (right_type == TYPE_IN) {
			vec2 circle_center = vec2(piece_size.x, piece_size.y/2.0f);
			a = 1.0f - get_circle_alpha(circle_center, CIRCLE_RADIUS, pos);
		}

		if (right_type == TYPE_ROUND_BOTTOM_RIGHT) {
			vec2 circle_center = vec2(piece_size.x - CORNER_CIRCLE_RADIUS, piece_size.y - CORNER_CIRCLE_RADIUS);
			if (pos.x > circle_center.x && pos.y > circle_center.y) {
				a = get_circle_alpha(circle_center, CORNER_CIRCLE_RADIUS, pos);
			}
		}

		if (right_type == TYPE_ROUND_TOP_RIGHT) {
			vec2 circle_center = vec2(piece_size.x - CORNER_CIRCLE_RADIUS, CORNER_CIRCLE_RADIUS);
			if (pos.x > circle_center.x && pos.y < circle_center.y) {
				a = get_circle_alpha(circle_center, CORNER_CIRCLE_RADIUS, pos);
			}
		}
	}

	return a;
}

float get_a_outer(vec2 pos, vec2 uv2) {
	float a = 0.0f;

	if (uv2.y < uv2.x && uv2.y < 1.0f - uv2.x) {
		if (up_type == TYPE_OUT) {
			vec2 circle_center = vec2(piece_size.x / 2.0f, 0.0f);
			a = get_circle_alpha(circle_center, CIRCLE_RADIUS, pos);
		}
	}

	if (uv2.x < uv2.y && uv2.x > 1.0f - uv2.y) {
		if (down_type == TYPE_OUT) {
			vec2 circle_center = vec2(piece_size.x / 2.0f, piece_size.y);
			a = get_circle_alpha(circle_center, CIRCLE_RADIUS, pos);
		}
	}

	if (uv2.x < uv2.y && uv2.x < 1.0f - uv2.y) {
		if (left_type == TYPE_OUT) {
			vec2 circle_center = vec2(0.0f, piece_size.y/2.0f);
			a = get_circle_alpha(circle_center, CIRCLE_RADIUS, pos);
		}
	}

	if (uv2.y < uv2.x && uv2.y > 1.0f - uv2.x) {
		if (right_type == TYPE_OUT) {
			vec2 circle_center = vec2(piece_size.x, piece_size.y/2.0f);
			a = get_circle_alpha(circle_center, CIRCLE_RADIUS, pos);
		}
	}

	return a;
}

float get_a(vec2 pos) {
	float lower_pos_x = - padding.x;
	float upper_pos_x = piece_size.x + padding.x;
	float lower_pos_y = - padding.y;
	float upper_pos_y = piece_size.y + padding.y;

	vec2 uv2 = vec2(pos.x / piece_size.x, pos.y / piece_size.y);

	if (pos.x > 0.0f && pos.x < piece_size.x && pos.y > 0.0f && pos.y < piece_size.y) {
		return get_a_inner(pos, uv2);
	}

	return get_a_outer(pos, uv2);
}

void fragment() {
	vec2 pos = vec2(UV.x * sprite_size.x - padding.x, UV.y * sprite_size.y - padding.y);
	vec4 result = texture(TEXTURE, UV + vec2((offset.x-padding.x)/sprite_size.x, (offset.y-padding.y)/sprite_size.y));
	result.a = get_a(pos);
	
	COLOR = result;
}
