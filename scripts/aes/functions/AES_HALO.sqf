/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/

OpenPlayerChuteHA = {
	params ["_paraUnit","_chuteheight"];
	waitUntil {(position _paraUnit select 2) <= _chuteheight};
	_paraUnit action ["openParachute", _paraUnit];
};

paraLandSafeHA = {
	params ["_unit","_chuteheight"];
	_unit allowDamage false;
	[_unit,_chuteheight] spawn OpenPlayerchuteHA;
	//_unit allowdamage true;// Now you can take damage.
	waitUntil { isTouchingGround _unit || (position _unit select 2) < 1 };
	_unit allowdamage true;// Now you can take damage.
	sleep 1;
	//if (alive _unit){
		_inv = name _unit;
		[_unit, [missionNamespace, format["%1%2", "Inventory",_inv]]] call BIS_fnc_loadInventory;// Reload Loadout.
	//}
	_unit allowdamage true;// Now you can take damage.
};

params ["_grp"];

private _chuteheight = 50;

{
	_inv = name _x;// Get Unique name for Unit's loadout.
	[_x, [missionNamespace, format["%1%2", "Inventory",_inv]]] call BIS_fnc_saveInventory;// Save Loadout
	removeBackpack _x;
	_x allowdamage false;// Trying to prevent damage.
	_x addBackPack "B_parachute";
} forEach units _grp;

{
	[_x, _chuteheight] spawn paraLandSafeHA;
} forEach units _grp;


/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/