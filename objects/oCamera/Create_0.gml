camera = view_camera[0];
camWidth  = camera_get_view_width(camera);
camHeight = camera_get_view_height(camera);

target = oPlayer;

followSpd = 0.12;
lookAhead = 40;
lookSpd = 0.05;
lookOffsetX = 0;
lookOffsetY = 0;

global.shake = 0;
shakeDecay = 0.85;

display_set_gui_size(camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]));

if (instance_exists(target))
{
	camX = target.x - camWidth / 2;
	camY = target.y - camHeight / 2;
}
else
{
	camX = 0;
	camY = 0;
}