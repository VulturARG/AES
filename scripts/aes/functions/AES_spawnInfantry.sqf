/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

params["_pos","_grpSize","_faction","_side"];

if (!isServer) exitWith {};

// SINGLE INFANTRY GROUP
private ["_grp","_unit","_pool"];

_grpSize params["_grpMin","_grpMax"];
_difference       = _grpMax-_grpMin;
_randomDifference = floor(random _difference);
_grpSize          = _randomDifference + _grpMin;

_grp = createGroup _side;

for "_x" from 1 to _grpSize do {
	_unitType = _pool select (floor(random(count _pool)));
	_unit     = _grp createUnit [_unitType, _pos, [], 6, "FORM"];
	_unit addEventHandler ["Killed", {_this execVM "scripts\aes\functions\AES_garbage_collector.sqf"}];

	// Remuevo las granadas de las unidades	
	_unit removeMagazines "HandGrenade";
	_unit removeMagazines "MiniGrenade";
	// Vultur /////////////////////////////////////////////////////
	// Comment this line if you do not want to change the equipment of the AI
	// Comentar esta línea si no desea cambiar el equipamiento de la IA
	
	_unit = [_unit,_unitType] call AES_fnc_setEquipment;
	///////////////////////////////////////////////////////////////
};

[_grp] call compile preprocessFileLineNumbers 'scripts\eos\functions\AES_transferGroups.sqf';

_grp

/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/