enum ATK { NONE, WINDUP, ACTIVE, RECOVERY }

function weapon_init()
{
	global.weapons = {};
	
	global.weapons.sword = {
		name: "Sword",
		sprite: sSword,
		spd: 1,
		comboWindow: 18,
		rest: { x: -6, y: -10, angle: 70 },
		combo: [
			// 1: Slash
			{ type: "slash", power: 1, windup: 4, active: 5, recovery: 7, lunge: 3, reach: 12, arcFrom: -80, arcTo: 80, hitDist: 12, hitDepth: 14, hitWidth: 24 },
			// 2: Slash
			{ type: "slash", power: 1, windup: 4, active: 5, recovery: 7, lunge: 3, reach: 12, arcFrom: 80, arcTo: -80, hitDist: 12, hitDepth: 14, hitWidth: 24 },
			// 3: Stab
			{ type: "stab", power: 2, windup: 7, active: 4, recovery: 12, lunge: 5, stabFrom: 2, stabTo: 18, hitDist: 17, hitDepth: 22, hitWidth: 10 }
		]
	};
	
	//
	weapon_validate();
}

function weapon_validate()
{
	var _common = ["type", "power", "windup", "active", "recovery", "lunge", "hitDist", "hitDepth", "hitWidth"];
	var _slash  = ["reach", "arcFrom", "arcTo"];
	var _stab   = ["stabFrom", "stabTo"];

	var _names = variable_struct_get_names(global.weapons);
	for (var w = 0; w < array_length(_names); w++)
	{
		var _wp = global.weapons[$ _names[w]];
		for (var c = 0; c < array_length(_wp.combo); c++)
		{
			var _a = _wp.combo[c];
			var _lists = [_common, (_a.type == "slash") ? _slash : _stab];

			for (var l = 0; l < 2; l++)
			{
				for (var f = 0; f < array_length(_lists[l]); f++)
				{
					if (!variable_struct_exists(_a, _lists[l][f]))
					{
						show_debug_message("WEAPON ERROR: '" + _names[w] + "' combo hit "
							+ string(c + 1) + " is missing '" + _lists[l][f] + "'");
					}
				}
			}
		}
	}
}

// @param key {string} e.g. "sword"
function weapon_equip(_key)
{
	if (atkState != ATK.NONE || !variable_struct_exists(global.weapons, _key)) return false;
	weapon = global.weapons[$ _key];
	comboIdx = 0;
	comboTimer = 0;
	return true;
}

function weapon_attack_start()
{
	atk = weapon.combo[comboIdx];
	atkDir = cursorDir;
	attackId++;
	atkBuffer = 0;
	comboTimer = 0;
	atkLen = [
		0,
		max(1, round(atk.windup / weapon.spd)),
		max(1, round(atk.active / weapon.spd)),
		max(1, round(atk.recovery / weapon.spd))
	];
	atkState = ATK.WINDUP;
	atkTimer = 0;
	dust_spawn(x, y, atkDir + 180, 3, 30, 1, 2, c_white, false);
}

function weapon_hitbox_update()
{
	hitDepth = atk.hitDepth;
	hitWidth = atk.hitWidth;
	hbCX = x + lengthdir_x(atk.hitDist, atkDir);
	hbCY = y + bodyCY + lengthdir_y(atk.hitDist, atkDir);

	var _fx = lengthdir_x(1, atkDir), _fy = lengthdir_y(1, atkDir);
	var _sx = -_fy, _sy = _fx;
	var _hd = hitDepth / 2, _hw = hitWidth / 2;

	hbCorners[0] = hbCX + _fx * _hd + _sx * _hw;  hbCorners[1] = hbCY + _fy * _hd + _sy * _hw;
	hbCorners[2] = hbCX + _fx * _hd - _sx * _hw;  hbCorners[3] = hbCY + _fy * _hd - _sy * _hw;
	hbCorners[4] = hbCX - _fx * _hd - _sx * _hw;  hbCorners[5] = hbCY - _fy * _hd - _sy * _hw;
	hbCorners[6] = hbCX - _fx * _hd + _sx * _hw;  hbCorners[7] = hbCY - _fy * _hd + _sy * _hw;
}

// Runs the attack state machine and combo chaining. Call once per Step (after the hitstop exit).
function weapon_update()
{
	switch (atkState)
	{
		case ATK.NONE:
			if (comboTimer > 0 && --comboTimer <= 0) comboIdx = 0; // combo window expired
			if (atkBuffer > 0) weapon_attack_start();
		break;

		default:
			atkTimer++;
			if (atkTimer >= atkLen[atkState])
			{
				atkTimer = 0;
				switch (atkState)
				{
					case ATK.WINDUP:
						atkState = ATK.ACTIVE;
						hitActive = true;
						lungeSpd = atk.lunge;
					break;
					case ATK.ACTIVE:
						atkState = ATK.RECOVERY;
						hitActive = false;
					break;
					case ATK.RECOVERY:
						atkState = ATK.NONE;
						comboIdx++;
						if (comboIdx >= array_length(weapon.combo))
						{
							comboIdx = 0;
							comboTimer = 0;
							atkBuffer = 0;
						}
						else comboTimer = weapon.comboWindow;
					break;
				}
			}
		break;
	}

	if (hitActive) weapon_hitbox_update();
	atkBuffer = max(0, atkBuffer - 1);
}

function pose_lerp(_a, _b, _t)
{
	return {
		x: lerp(_a.x, _b.x, _t),
		y: lerp(_a.y, _b.y, _t),
		ang: _a.ang - angle_difference(_a.ang, _b.ang) * _t
	};
}

function weapon_pose()
{
	var _r = weapon.rest;
	var _rest = {
		x: x + _r.x * hFace,
		y: y + _r.y,
		ang: (hFace >= 0) ? _r.angle : 180 - _r.angle
	};
	if (atkState == ATK.NONE) return _rest;

	var _t = atkTimer / atkLen[atkState];
	var _cy = y + bodyCY;
	var _from, _to;

	if (atk.type == "slash")
	{
		var _a0 = atkDir + atk.arcFrom;
		var _a1 = atkDir + atk.arcTo;
		_from = { x: x + lengthdir_x(atk.reach, _a0), y: _cy + lengthdir_y(atk.reach, _a0), ang: _a0 };
		_to   = { x: x + lengthdir_x(atk.reach, _a1), y: _cy + lengthdir_y(atk.reach, _a1), ang: _a1 };
	}
	else // stab
	{
		_from = { x: x + lengthdir_x(atk.stabFrom, atkDir), y: _cy + lengthdir_y(atk.stabFrom, atkDir), ang: atkDir };
		_to   = { x: x + lengthdir_x(atk.stabTo, atkDir),   y: _cy + lengthdir_y(atk.stabTo, atkDir),   ang: atkDir };
	}

	switch (atkState)
	{
		case ATK.WINDUP:
			return pose_lerp(_rest, _from, _t * _t);

		case ATK.ACTIVE:
			var _e = 1 - sqr(1 - _t);
			if (atk.type == "slash")
			{
				// orbit around the body so the blade sweeps an arc instead of cutting a straight line
				var _a = atkDir + lerp(atk.arcFrom, atk.arcTo, _e);
				return { x: x + lengthdir_x(atk.reach, _a), y: _cy + lengthdir_y(atk.reach, _a), ang: _a };
			}
			return pose_lerp(_from, _to, _e);

		case ATK.RECOVERY:
			return pose_lerp(_to, _rest, _t);
	}
	return _rest;
}

function weapon_draw()
{
	var _p = weapon_pose();
	var _flip = (lengthdir_x(1, _p.ang) < 0) ? -1 : 1; // keeps the blade's top edge on top when pointing left
	draw_sprite_ext(weapon.sprite, 0, _p.x, _p.y, 1, _flip, _p.ang, c_white, 1);
}