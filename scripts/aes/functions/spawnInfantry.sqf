/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

params["_pos","_grpSize","_faction","_side"];

if (!isServer) exitWith {};
// SINGLE INFANTRY GROUP
private ["_grp","_unit","_pool"];

_grpSize params["_grpMin","_grpMax"];
_difference = _grpMax-_grpMin;
_randomDifference = floor(random _difference);
_grpSize = _randomDifference + _grpMin;

if (surfaceiswater _pos) then {
	_pool=[_faction,"dive"] call AES_fnc_getUnitPool;
}else{
	_pool=[_faction,"troop"] call AES_fnc_getUnitPool;
};

_grp=createGroup _side;

for "_x" from 1 to _grpSize do {
	_unitType=_pool select (floor(random(count _pool)));
	_unit = _grp createUnit [_unitType, _pos, [], 6, "FORM"];

	// Vultur /////////////////////////////////////////////////////
	// Remuevo las granadas de las unidades
	
	_unit removeMagazines "HandGrenade";
	_unit removeMagazines "MiniGrenade";
	// Vultur /////////////////////////////////////////////////////
	// Comment this line if you do not want to change the equipment of the AI
	// Comentar esta línea si no desea cambiar el equipamiento de la IA
	
	_unit=[_unit,_unitType] call AES_setEquipment;
	///////////////////////////////////////////////////////////////
};

_grp

/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/