if (instance_exists(target))
{
	//lookOffsetX = lerp(lookOffsetX, target.hFace * lookAhead, lookSpd);
	//lookOffsetY = lerp(lookOffsetY, target.vFace * lookAhead, lookSpd);
	
	var _goalX = target.x + lookOffsetX - camWidth / 2;
	var _goalY = target.y + lookOffsetY - camHeight / 2;
	
	camX = lerp(camX, _goalX, followSpd);
	camY = lerp(camY, _goalY, followSpd);
}

camX = clamp(camX, 0, room_width - camWidth);
camY = clamp(camY, 0, room_height - camHeight);

var _ox = 0, _oy = 0;
if (global.shake > 0.1)
{
	_ox = random_range(-global.shake, global.shake);
	_oy = random_range(-global.shake, global.shake);
	global.shake *= shakeDecay;
}
else global.shake = 0;

camera_set_view_pos(camera, round(camX + _ox), round(camY + _oy));