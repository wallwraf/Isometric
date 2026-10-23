keySelect = keyboard_check_pressed(ord("Z"));
if (keySelect) atkBuffer = 8;
if (global.hitstop > 0) { image_speed = 0; exit; };

keyLeft = keyboard_check(vk_left);
keyRight = keyboard_check(vk_right);
keyUp = keyboard_check(vk_up);
keyDown = keyboard_check(vk_down);

hSpd = (keyRight - keyLeft);
vSpd = (keyDown - keyUp);
//show_debug_message("hSpd: " + string(hSpd) + " | vSpd: " + string(vSpd));

if (hSpd != 0 || vSpd != 0)
{
	var _dir = point_direction(0, 0, hSpd, vSpd);
	
	x += lengthdir_x(spd, _dir);
	y += lengthdir_y(spd, _dir);
	
	cursorDir = point_direction(0, 0, hSpd, vSpd);
}

if (hSpd != 0) hFace = keyRight - keyLeft;
if (vSpd != 0)
{
	if (vSpd >= 1) vFace = sPlayerHead;
	else vFace = sPlayerHead2;
}

image_xscale = hFace;
sprite_index = vFace;

if (hSpd != 0 || vSpd != 0)
{
	image_speed = 1;
}
else { image_speed = 0; image_index = 0; }

hbCX = x + lengthdir_x(hitDist, cursorDir);
hbCY = y + lengthdir_y(hitDist, cursorDir);

var _fx = lengthdir_x(1, cursorDir);
var _fy = lengthdir_y(1, cursorDir);
var _sx = -_fy;
var _sy = _fx;

var _hd = hitDepth / 2;
var _hw = hitWidth / 2;

hbCorners[0] = hbCX + _fx * _hd + _sx * _hw;  hbCorners[1] = hbCY + _fy * _hd + _sy * _hw;
hbCorners[2] = hbCX + _fx * _hd - _sx * _hw;  hbCorners[3] = hbCY + _fy * _hd - _sy * _hw;
hbCorners[4] = hbCX - _fx * _hd - _sx * _hw;  hbCorners[5] = hbCY - _fy * _hd - _sy * _hw;
hbCorners[6] = hbCX - _fx * _hd + _sx * _hw;  hbCorners[7] = hbCY - _fy * _hd + _sy * _hw;

headSpr = (sprite_index == sPlayerBody) ? sPlayerHead : sPlayerHead2;

weapon_update();

if (lungeSpd > 0.2)
{
	x += lengthdir_x(lungeSpd, cursorDir);
	y += lengthdir_y(lungeSpd, cursorDir);
	lungeSpd *= 0.7;
}

if (recoilSpd > 0.2)
{
	x += lengthdir_x(recoilSpd, recoilDir);
	y += lengthdir_y(recoilSpd, recoilDir);
	recoilSpd *= 0.75;
}

if (hSpd != 0 || vSpd != 0)
{
	if (--dustTimer <= 0)
	{
		dust_spawn(x, y, cursorDir + 180, 1, 30, 0.6, 2);
		dustTimer = 8;
	}
}

if (hitActive)
{
	with (oEnemy)
	{
		if (!dying && lastHitBy != other.attackId
		&& rotated_box_hits_instance(other.hbCX, other.hbCY, other.atkDir,
		                             other.hitDepth / 2, other.hitWidth / 2, id))
		{
			lastHitBy = other.attackId;
			hit_apply(id, other, other.atk.power);
		}
	}
}