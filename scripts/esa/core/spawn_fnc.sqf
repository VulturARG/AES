/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

if (isnil "server") then {hint "YOU MUST PLACE A GAME LOGIC NAMED SERVER!";};

call compile preprocessfile "scripts\AES\AI_Skill.sqf";

eos_fnc_spawnvehicle  = compile preprocessfile "scripts\AES\functions\eos_SpawnVehicle.sqf";
eos_fnc_grouphandlers = compile preprocessfile "scripts\AES\functions\setSkill.sqf";
eos_fnc_findsafepos   = compile preprocessfile "scripts\AES\functions\findSafePos.sqf";
eos_fnc_spawngroup    = compile preprocessfile "scripts\AES\functions\infantry_fnc.sqf";
eos_fnc_setcargo      = compile preprocessfile "scripts\AES\functions\cargo_fnc.sqf";
eos_fnc_taskpatrol    = compile preprocessfile "scripts\AES\functions\shk_patrol.sqf";
SHK_pos               = compile preprocessfile "scripts\AES\functions\shk_pos.sqf";
shk_fnc_fillhouse     = compile preprocessFile "scripts\AES\Functions\SHK_buildingpos.sqf";
eos_fnc_getunitpool   = compile preprocessfile "scripts\AES\UnitPools.sqf";
AES_setEquipment      = compile preprocessfile "scripts\AES\functions\AES_setEquipment.sqf";
AES_newWaypoint       = compile preprocessfile "scripts\AES\functions\AES_newWaypoint.sqf";
AES_log               = compile preprocessfile "scripts\AES\functions\AES_log.sqf";

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