dust_draw(false); // ground dust: under the player

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 1, 0, c_white, 1); // body
weapon_draw();                                                                    // weapon
draw_sprite_ext(headSpr, image_index, x, y, image_xscale, 1, 0, c_white, 1);      // head

if (showHitbox && hitActive)
{
	draw_set_colour(c_red);
	draw_primitive_begin(pr_linestrip);
	for (var i = 0; i < 8; i += 2) draw_vertex(hbCorners[i], hbCorners[i + 1]);
	draw_vertex(hbCorners[0], hbCorners[1]);
	draw_primitive_end();
	draw_set_colour(c_white);
}

if (hSpd != 0 || vSpd != 0)
{
	cursorDir = point_direction(0, 0, hSpd, vSpd);
}

// Hurtbox (if its triggered, player takes damage)
draw_set_colour(c_lime);
draw_octagon_ext(x, y, 14, 8, true, true);
draw_set_colour(c_white);