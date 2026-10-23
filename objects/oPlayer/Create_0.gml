hSpd = 1;
vSpd = 1;
spd = 2;

hFace = 1;
vFace = 1;

cursorDir = 0;
hitDist  = 10;

attackId = 0;
lungeSpd = 0;
recoilDir = 0;
recoilSpd = 0;
dustTimer = 0;

weapon = undefined;
atk = undefined;
atkState = ATK.NONE;
atkTimer = 0;
atkLen = [0, 1, 1, 1];
atkDir = 0;
atkBuffer = 0;
comboIdx = 0;
comboTimer = 0;
attackId = 0;
hitActive = false;
bodyCY = -6;
showHitbox = true;

hitDepth = 32; hitWidth = 24;
hbCX = x; hbCY = y;
hbCorners = array_create(8, 0);

weapon_equip("sword");