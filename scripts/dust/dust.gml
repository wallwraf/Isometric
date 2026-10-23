// Script: dust (replaces the previous dust functions)
function dust_init()
{
	global.dust = [];
}

/// @param x {real}
/// @param y {real}
/// @param dir {real}
/// @param count {real}
/// @param spread {real}
/// @param speed {real}
/// @param size {real} max radius
/// @param colour {Constant.Colour}
/// @param front {bool} true = drawn above everything, false = under the player
function dust_spawn(_x, _y, _dir, _count, _spread = 50, _speed = 1.5, _size = 3, _col = c_white, _front = true)
{
	repeat (_count)
	{
		array_push(global.dust, {
			x: _x + random_range(-2, 2),
			y: _y + random_range(-2, 2),
			dir: _dir + random_range(-_spread, _spread),
			spd: random_range(_speed * 0.5, _speed),
			r: random_range(_size * 0.6, _size),
			shrink: random_range(0.06, 0.12),
			col: _col,
			front: _front
		});
	}
}

function dust_update()
{
	if (global.hitstop > 0) return;

	for (var i = array_length(global.dust) - 1; i >= 0; i--)
	{
		var _d = global.dust[i];
		_d.x += lengthdir_x(_d.spd, _d.dir);
		_d.y += lengthdir_y(_d.spd, _d.dir);
		_d.spd *= 0.9;
		_d.r -= _d.shrink;
		if (_d.r < 0.8) array_delete(global.dust, i, 1);
	}
}

/// @param front {bool} which layer to draw
function dust_draw(_front)
{
	draw_set_circle_precision(24);
	for (var i = 0; i < array_length(global.dust); i++)
	{
		var _d = global.dust[i];
		if (_d.front != _front) continue;
		draw_set_colour(_d.col);
		draw_circle(_d.x, _d.y, _d.r, false);
	}
	draw_set_colour(c_white);
}