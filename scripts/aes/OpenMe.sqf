/*******************************************************************************
                            Modify by |ArgA|Vultur|Sgt
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

 
null=
[
  ["M1","M2","M3"],
  [
    [HOUSE GROUPS,SIZE OF GROUPS,PROBABILITY],
    [PATROL GROUPS,SIZE OF GROUPS,PROBABILITY],
    [LIGHT VEHICLES,SIZE OF CARGO,PROBABILITY],
    [ARMOURED VEHICLES,PROBABILITY],
    [STATIC VEHICLES,PROBABILITY],
    [HELICOPTERS,SIZE OF HELICOPTER CARGO,PROBABILITY]
  ],
  [FACTION,MARKERTYPE,DISTANCE,SIDE,HEIGHTLIMIT,hint_DEBUG,BIS_fnc_logFormat_DEBUG]
] call EOS_Spawn;

//EXAMPLE Defend a position

null=
[
  ["type"],            <- Must be playerAttack or playerDefend. playerAttack: the player attacks a position. playerDefend: the player defends a position
  ["M1","M2","M3"],
  [
    ["type",quantity,spawn distance (m), (number of units in each group,(jump height meters))], <---Must go a comma if there is another element
    [...]  <-- Last element without comma
  ],
  [FACTION,MARKERTYPE,SIDE,HEIGHTLIMIT,hint_DEBUG,BIS_fnc_logFormat_DEBUG],
  [INITIAL PAUSE, NUMBER OF WAVES, DELAY BETWEEN WAVES, INTEGRATE EOS, SHOW HINTS],
  angle       <-- Last element without comma
] call Bastion_Spawn;

Armor and Attack chopper have no units number of units in each group.
Only Para chopper and HALO jump have jump height

Example:
null=
[
  "playerDefend",
  ["M1","M2","M3"],
  [
    ["patrol",3,500,2],       <---Must go a comma if there is another element, and so on
    ["light vehicle",2,800,2], 
    ["armor",1,650],
    ["attack chopper",0,700],    <-- The unit does not appear if its type is not set or if it is done with zero units.
    ["cargo chopper",3,500,2],
    ["para chopper",1,600,100],
    ["halo",3,100,3000]       <-- Last element without comma
  ],
  [FACTION,MARKERTYPE,SIDE,HEIGHTLIMIT,hint_DEBUG,BIS_fnc_logFormat_DEBUG],
  [INITIAL PAUSE, NUMBER OF WAVES, DELAY BETWEEN WAVES, INTEGRATE EOS, SHOW HINTS],
  angle    <-- Last element without comma
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

Launch              = compile preprocessFileLineNumbers "scripts\AES\core\launch.sqf";
Bastion_Redirect_WP = compile preprocessFileLineNumbers "scripts\AES\core\b_redirijoUnidades.sqf";

call compile preprocessFileLineNumbers "scripts\AES\aes_settings.sqf";

execVM "scripts\AES\core\spawn_fnc.sqf";

onplayerConnected {[] execVM "scripts\AES\Functions\EOS_Markers.sqf";};

// Check if ACE is running
//if (isClass (configfile >> "CfgPatches" >> "ace_common")) then {KP_liberation_ace = true; diag_log "[KP LIBERATION] ACE detected. Deactivating resupply and weather scripts from Liberation."} else {KP_liberation_ace = false};
//TODO Adaptar para el VCOM
IsVCOM_MOD = true;
publicVariable "IsVCOM_MOD";

VictoryColor="colorBLUFOR";	// Colour of marker after completion
hostileColor="colorOPFOR";	// Default colour when enemies active
bastionColor="colorBLUFOR";	// Colour for bastion marker

AES_DAMAGE_MULTIPLIER = 1;	// 1 is default
AES_KILLCOUNTER = false;		// Counts killed units

//'Open Me' call BIS_fnc_log;

private _AES_FACCION = EAST;
/*

[
    "playerDefend",
    ["marker_0"],
    [
      ["house",0,100,2],
      ["patrol",1,100,2],
      ["light vehicle",0,100,4],
      ["cargo chopper",0,100,1],
      ["armor",0,100],
      ["attack chopper",0,100],
      ["static vehicle",0,100]
    ],
    [5,1,200,EAST,false,false,false]
] call Launch;

[
    "playerDefend",
    ["marker_0"],
    [
      ["patrol",0,300,3],
      ["light vehicle",1,400,3],
      ["armor",0,650],
      ["attack chopper",0,700],
      ["cargo chopper",0,500,1],
      ["para chopper",0,600,5,100],
      ["halo",0,100,2,300]
    ],
    [5,1,EAST,false,false,false],
    [1,1,60,false,false],
    360
] call Launch;
*/
/*
null=
[
  ["M1","M2","M3"],
  [
    [HOUSE GROUPS,SIZE OF GROUPS,PROBABILITY],
    [PATROL GROUPS,SIZE OF GROUPS,PROBABILITY],
    [LIGHT VEHICLES,SIZE OF CARGO,PROBABILITY],
    [ARMOURED VEHICLES,PROBABILITY],
    [STATIC VEHICLES,PROBABILITY],
    [HELICOPTERS,SIZE OF HELICOPTER CARGO,PROBABILITY]
  ],
  [FACTION,MARKERTYPE,DISTANCE,SIDE,HEIGHTLIMIT,hint_DEBUG,BIS_fnc_logFormat_DEBUG]
] call EOS_Spawn;
*/

// null = [["patrullas_H"],[0,2,100],[10,1,100],[0,0,0],[0,0],[0],[0,0,00],[5,0,200,_AES_FACCION,false]] call EOS_Spawn;

[
    "playerDefend",
    ["marker_0"],
    [
      ["patrol"        ,5,300,3],
      ["light vehicle" ,0,400,3],
      ["armor"         ,0,650],
      ["attack chopper",0,700],
      ["cargo chopper" ,0,500,1],
      ["para chopper"  ,0,600,5,100],
      ["halo"          ,0,100,2,300]
    ],
    [5,1,EAST,false,false,false],
    [1,1,60,false,false],
    360
] call Launch;


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
                            Modify by |ArgA|Vultur|Sgt
*******************************************************************************/
