/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/
/* AES based in EOS 1.98 by BangaBob

GROUP SIZES
 0 = 1
 1 = 2,4
 2 = 4,8
 3 = 8,12
 4 = 12,16
 5 = 16,20

EXAMPLE CALL - AES
 null = [["M1","M2","M3"],[2,1,70],[0,1],[1,2,30],[2,60],[2],[1,1,10],[1,1,250,WEST]] call EOS_Spawn;
 
null=
[
  ["M1","M2","M3"],
  [HOUSE GROUPS,SIZE OF GROUPS,PROBABILITY],
  [PATROL GROUPS,SIZE OF GROUPS,PROBABILITY],
  [LIGHT VEHICLES,SIZE OF CARGO,PROBABILITY],
  [ARMOURED VEHICLES,PROBABILITY],
  [STATIC VEHICLES,PROBABILITY],
  [HELICOPTERS,SIZE OF HELICOPTER CARGO,PROBABILITY],
  [FACTION,MARKERTYPE,DISTANCE,SIDE,HEIGHTLIMIT,hint_DEBUG,BIS_fnc_logFormat_DEBUG]
] call EOS_Spawn;

//EXAMPLE CALL - BASTION
null=
[
  ["M1","M2","M3"],
  [
    [PATROL GROUPS,SIZE OF GROUPS,APPEARANCE DISTANCE],
    [LIGHT VEHICLES,SIZE OF CARGO,APPEARANCE DISTANCE],
    [ARMOURED VEHICLES,null,APPEARANCE DISTANCE],
    [ATTACK HELI,null,APPEARANCE DISTANCE], 
    [HELICOPTERS,SIZE OF HELICOPTER CARGO,APPEARANCE DISTANCE], 
    [PARACAIDISTAS,SIZE OF HELICOPTER CARGO,APPEARANCE DISTANCE,JUMP HEIGHT],
    [HALO,SIZE OF GROUPS,APPEARANCE DISTANCE,JUMP HEIGHT]
  ]
  [FACTION,MARKERTYPE,SIDE,HEIGHTLIMIT,hint_DEBUG,BIS_fnc_logFormat_DEBUG],
  [INITIAL PAUSE, NUMBER OF WAVES, DELAY BETWEEN WAVES, INTEGRATE EOS, SHOW HINTS],
  [angle]
] call Bastion_Spawn;

//EXAMPLE CALL - REDIRECT WP BASTION
//Borra todos los WP de las unidades del bando y luego crea otros

[
  ["M1","M2","M3"], //Marcadores _angle donde redirigir las unidades
  [["E1",% redirigido,"ND"],["E2",% redirigido,"ND"]],  // ["E1"] -> Nombre de las unidades parcialmente redirigidas. Puede ser vacio
                                                        // % redirigido [0 _angle 100] -> % del grupo que se redirige al nuevo WP
                                                        // ["ND"] -> Nombre del marcador que será el nuevo destino de las unidades remanentes (opcional)
  [Bando]                                               // Bando
] call Redirect_WP_Bastion_Spawn;

*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

params ["_marker",["_waves",0],["_players",1],["_angle",360]];

EOS_Spawn           = compile preprocessfile "scripts\AES\core\eos_launch.sqf";
Bastion_Spawn       = compile preprocessfile "scripts\AES\core\b_launch.sqf";
Bastion_Redirect_WP = compile preprocessfile "scripts\AES\core\b_redirijoUnidades.sqf";

null=[] execVM "scripts\AES\core\spawn_fnc.sqf";

onplayerConnected {[] execVM "scripts\AES\Functions\EOS_Markers.sqf";};

IsVCOM_MOD = true;
publicVariable "IsVCOM_MOD";

VictoryColor="colorBLUFOR";	// Colour of marker after completion
hostileColor="colorOPFOR";	// Default colour when enemies active
bastionColor="colorBLUFOR";	// Colour for bastion marker

EOS_DAMAGE_MULTIPLIER=1;	// 1 is default
EOS_KILLCOUNTER=false;		// Counts killed units

DEFAULT_INFANTERY_MIN_DIST      =  500;
DEFAULT_VEHICLES_MIN_DIST       =  800;
DEFAULT_ARMOR_MIN_DIST          =  800;
DEFAULT_ATTACK_CHOPPER_MIN_DIST = 1400;
DEFAULT_CHOPPER_MIN_DIST        = 1400;
DEFAULT_CHOPPER_JUMP_MIN_DIST   = 1400;
DEFAULT_CHOPPER_JUMP_HEIGHT     =  400;
DEFAULT_HALO_MIN_DIST           =  200;
DEFAULT_HALO_JUMP_HEIGHT        =  600;

DELETE_DISTANCE                 =  950;  //Delete _EOS_FACCION unit outside this distance from marker's center 

//'Open Me' call BIS_fnc_log;

private _EOS_FACCION = EAST;

//null = [["patrullas_H"],[0,2,100],[10,1,100],[0,0,0],[0,0],[0],[0,0,00],[5,0,200,_EOS_FACCION,false]] call EOS_Spawn;

null = [["marker_0"],[[0,2,150],[0,2,1000],[0,0,1500],[0,1,1500],[0,0,1500],[0,3,1500,600],[0,3,300,500]],[5,1,EAST,false,false,false],[1,2,60,false,false],360] call Bastion_Spawn;

if (_players > 10 && _players <= 15) then {

};
if (_players > 15 && _players <= 20) then {

};
if (_players > 20 && _players <= 25) then {

};
if (_players > 25 && _players <= 30) then {

};
if (_players > 30) then {

};

/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/
