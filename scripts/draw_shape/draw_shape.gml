// ----------- Octagon
/// @function draw_octagon(x, y, radius, outline, [flat])
/// @param {Real} x       x position of the center
/// @param {Real} y       y position of the center
/// @param {Real} radius  Distance from the centre to a corner
/// @param {Bool} outline whether it is an outline or filled shape
/// @param {Bool} [flat]  true = flat side on top, false = corner on top
function draw_octagon(_x, _y, _rad, _outline, _flat = true)
{
    var _start = _flat ? 22.5 : 0;
    var _base = 90 + _start;

    if (_outline) draw_primitive_begin(pr_linestrip);
    else {
        draw_primitive_begin(pr_trianglefan);
        draw_vertex(_x, _y);
    }

    for (var i = 0; i <= 8; i++) {
        var _a = _base + i * 45;
        draw_vertex(_x + lengthdir_x(_radius, _a),
                    _y + lengthdir_y(_radius, _a));
    }
    draw_primitive_end();
}

// ----------- Octagon Ext
/// @function draw_octagon_ext(x, y, radius, outline, [flat], [angle], [col], [alpha])
/// @param {Real} x x position of the center
/// @param {Real} y y position of the center
/// @param {Real} width the width of the shape
/// @param {Real} height the height of the shape
/// @param {Bool} outline whether it is an outline or filled shape
/// @param {Bool} flat true = flat side on top, false = corner on top
function draw_octagon_ext(_x, _y, _width, _height, _outline, _flat = true)
{
	var _rx = _width / 2;
	var _ry = _height / 2;

	var _steps = 8;
	var _angle_step = 360 / _steps;

	// Flat: faces on the cardinal directions, so the corners sit 22.5° off-axis.
	// The corners must reach out further for the faces to land on width/height.
	var _start = 0;
	if (_flat)
	{
		_start = _angle_step / 2;
		var _scale = 1 / dcos(_start);
		_rx *= _scale;
		_ry *= _scale;
	}

	if (_outline) draw_primitive_begin(pr_linestrip);
	else
	{
		draw_primitive_begin(pr_trianglefan);
		draw_vertex(_x, _y);
	}

	// <= so the last vertex repeats the first and closes the shape
	for (var i = 0; i <= _steps; i++)
	{
		var _angle = _start + i * _angle_step;
		draw_vertex(_x + lengthdir_x(_rx, _angle),
		            _y + lengthdir_y(_ry, _angle));
	}

	draw_primitive_end();
}