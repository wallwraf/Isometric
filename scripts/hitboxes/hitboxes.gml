/// @param {real} cx centre x of the rotated box
/// @param {real} cy centre y of the rotated box
/// @param {real} dir direction the box is facing
/// @param {real} halfDepth half the length along the facing direction
/// @param {real} halfWidth half the width across the facing direction
/// @param {Id.Instance} inst the instance to test against
function rotated_box_hits_instance(_cx, _cy, _dir, _hd, _hw, _inst)
{
	var _fx = lengthdir_x(1, _dir);
	var _fy = lengthdir_y(1, _dir);
	var _sx = -_fy;
	var _sy = _fx;

	var _ex  = (_inst.bbox_left + _inst.bbox_right) / 2;
	var _ey  = (_inst.bbox_top + _inst.bbox_bottom) / 2;
	var _ehx = (_inst.bbox_right - _inst.bbox_left) / 2;
	var _ehy = (_inst.bbox_bottom - _inst.bbox_top) / 2;

	var _dx = _ex - _cx;
	var _dy = _ey - _cy;

	// World X axis
	if (abs(_dx) > _hd * abs(_fx) + _hw * abs(_sx) + _ehx) return false;
	// World Y axis
	if (abs(_dy) > _hd * abs(_fy) + _hw * abs(_sy) + _ehy) return false;
	// Box's forward axis
	if (abs(_dx * _fx + _dy * _fy) > _hd + _ehx * abs(_fx) + _ehy * abs(_fy)) return false;
	// Box's sideways axis
	if (abs(_dx * _sx + _dy * _sy) > _hw + _ehx * abs(_sx) + _ehy * abs(_sy)) return false;

	return true;
}

/// @param {Id.Instance} target
/// @param {Id.Instance} attacker
/// @param {Real} power 1 = light, 2 = heavy
function hit_apply(_target, _attacker, _power = 1)
{
	var _dir = _attacker.atkDir;

	with (_target)
	{
		hp -= _power;
		flashTimer = 4;
		kbDir = _dir;
		kbSpd = 3 * _power;
		if (hp <= 0)
		{
			dying = true;
			kbSpd *= 1.5;
		}
	}

	with (_attacker)
	{
		recoilDir = _dir + 180;
		recoilSpd = 2.5 * _power;
		lungeSpd = 0;
	}

	global.hitstop = 3 * _power;
	global.shake = max(global.shake, 2 * _power);

	// Spawn on the far side of the enemy and keep travelling in the hit direction
	var _fx = _target.x + lengthdir_x(8, _dir);
	var _fy = _target.y + lengthdir_y(8, _dir);
	dust_spawn(_fx, _fy, _dir, 4 + 2 * _power, 35, 1.8, 3);
}