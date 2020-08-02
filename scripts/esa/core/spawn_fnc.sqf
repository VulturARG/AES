/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

if (isnil "server") then {hint "YOU MUST PLACE A GAME LOGIC NAMED SERVER!";};

call compile preprocessfile "scripts\esa\AI_Skill.sqf";

eos_fnc_spawnvehicle  = compile preprocessfile "scripts\esa\functions\eos_SpawnVehicle.sqf";
eos_fnc_grouphandlers = compile preprocessfile "scripts\esa\functions\setSkill.sqf";
eos_fnc_findsafepos   = compile preprocessfile "scripts\esa\functions\findSafePos.sqf";
eos_fnc_spawngroup    = compile preprocessfile "scripts\esa\functions\infantry_fnc.sqf";
eos_fnc_setcargo      = compile preprocessfile "scripts\esa\functions\cargo_fnc.sqf";
eos_fnc_taskpatrol    = compile preprocessfile "scripts\esa\functions\shk_patrol.sqf";
SHK_pos               = compile preprocessfile "scripts\esa\functions\shk_pos.sqf";
shk_fnc_fillhouse     = compile preprocessFile "scripts\esa\Functions\SHK_buildingpos.sqf";
eos_fnc_getunitpool   = compile preprocessfile "scripts\esa\UnitPools.sqf";
ESA_fnc_infInv        = compile preprocessfile "scripts\esa\functions\ESA_infantry_inventory.sqf";
ESA_newWaypoint       = compile preprocessfile "scripts\esa\functions\ESA_newWaypoint.sqf";
ESA_log               = compile preprocessfile "scripts\esa\functions\ESA_log.sqf";

///////////////////////////////////////////////////////////////

EOS_Deactivate = {
	params ["_mkr"];;
	{
		_x setmarkercolor "colorblack";
		_x setmarkerAlpha 0;
	}foreach _mkr;
};

EOS_debug = {
	params ["_mkr","_n","_note","_pos"];

	_mkrID=format ["%3:%1,%2",_mkr,_n,_note];
	deletemarker _mkrID;
	_debugMkr = createMarker[_mkrID,_pos];
	_mkrID setMarkerType "Mil_dot";
	_mkrID setMarkercolor "colorBlue";
	_mkrID setMarkerText _mkrID;
	_mkrID setMarkerAlpha 0.5;
};

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
   0 = [vehicle, altitude] execVM "eject.sqf"
*/

/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/