/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

if (isnil "server") then {hint "YOU MUST PLACE A GAME LOGIC NAMED SERVER!";};

call compile preprocessFileLineNumbers "scripts\AES\AI_Skill.sqf";

eos_fnc_spawnVehicle  = compile preprocessFileLineNumbers "scripts\AES\functions\eos_SpawnVehicle.sqf";
eos_fnc_setSkill      = compile preprocessFileLineNumbers "scripts\AES\functions\setSkill.sqf";
eos_fnc_findSafePos   = compile preprocessFileLineNumbers "scripts\AES\functions\findSafePos.sqf";
eos_fnc_spawnInfantry = compile preprocessFileLineNumbers "scripts\AES\functions\spawnInfantry.sqf";
eos_fnc_setCargo      = compile preprocessFileLineNumbers "scripts\AES\functions\setCargo.sqf";
eos_fnc_taskpatrol    = compile preprocessFileLineNumbers "scripts\AES\functions\shk_patrol.sqf";
SHK_pos               = compile preprocessFileLineNumbers "scripts\AES\functions\shk_pos.sqf";
shk_fnc_fillhouse     = compile preprocessFileLineNumbers "scripts\AES\Functions\SHK_buildingpos.sqf";
eos_fnc_getUnitPool   = compile preprocessFileLineNumbers "scripts\AES\getUnitPool.sqf";
AES_setEquipment      = compile preprocessFileLineNumbers "scripts\AES\functions\AES_setEquipment.sqf";
AES_setNewWaypoint    = compile preprocessFileLineNumbers "scripts\AES\functions\AES_setNewWaypoint.sqf";
AES_log               = compile preprocessFileLineNumbers "scripts\AES\functions\AES_log.sqf";

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
   [vehicle, altitude] execVM "eject.sqf"
*/

/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/