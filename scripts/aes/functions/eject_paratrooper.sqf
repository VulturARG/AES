/*
	Filename: Simple ParaDrop Script v0.96 eject.sqf
	Author: Beerkan
	Modify by Vultur

	Description:
     A Simple Paradrop Script

	Parameter(s):
	0: VEHICLE  - vehicle that will be doing the paradrop (object)
	1: ALTITUDE - (optional) the altitude where the group will open their parachute (number)

   Example:
   [vehicle, altitude] execVM "eject.sqf"
*/
params ["_vehicle",["_chuteHeight",100]];

if (!isServer) exitWith {};

private ["_paras","_dir"];

_vehicle allowDamage false;
_paras = assignedcargo _vehicle;
_dir = direction _vehicle;

paraLandSafe =
{
	params ["_unit","_chuteheight"];
	(vehicle _unit) allowDamage false;
	if (isPlayer _unit) then {[_unit,_chuteheight] spawn OpenPlayerchute};
	waitUntil { isTouchingGround _unit || (position _unit select 2) < 1 };
	_unit action ["eject", vehicle _unit];
	sleep 1;
	_inv = name _unit;
	[_unit, [missionNamespace, format["%1%2", "Inventory",_inv]]] call BIS_fnc_loadInventory;// Reload Loadout.
	_unit allowdamage true;// Now you can take damage.
};

OpenPlayerChute =
{
	params ["_paraUnit","_chuteheight"];
	waitUntil {(position _paraUnit select 2) <= _chuteheight};
	_paraUnit action ["openParachute", _paraUnit];
};

{
	_inv = name _x;// Get Unique name for Unit's loadout.
	[_x, [missionNamespace, format["%1%2", "Inventory",_inv]]] call BIS_fnc_saveInventory;// Save Loadout
	removeBackpack _x;
	_x disableCollisionWith _vehicle;// Sometimes units take damage when being ejected.
	_x allowdamage false;// Trying to prevent damage.
	_x addBackPack "B_parachute";
	unassignvehicle _x;
	moveout _x;
	_x setDir (_dir + 90);// Exit the chopper at right angles.
	sleep 0.3;
} forEach _paras;

_vehicle allowDamage true;

{
	[_x,_chuteheight] spawn paraLandSafe;
} forEach _paras;
