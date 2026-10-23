if (global.hitstop > 0) exit;

var _knocked = (kbSpd > 0.1);
if (_knocked)
{
	x += lengthdir_x(kbSpd, kbDir);
	y += lengthdir_y(kbSpd, kbDir);
	kbSpd *= 0.8;
}

if (dying)
{
	flashTimer = 2;
	if (!_knocked)
	{
		dust_spawn(x, y - 4, 0, 18, 180, 2.2, 5);
		instance_destroy();
	}
	exit;
}

if (flashTimer > 0) flashTimer--;