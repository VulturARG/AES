/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

// Defend a position against enemy

if (!isServer) exitWith {};

params ["_marker","_unitsArrays","_settings","_basSettings","_angle",["_initialLaunch",false]];

private _bastionMarquerAlphaValue  = [1,0,0.5];
private _multipleMarquerAlphaValue = [0.5,0,0.5];
private _spawnGroup                = [];
private _groups                    = [];

AES_bastionTrigger = compile preprocessFileLineNumbers "scripts\AES\functions\AES_bastionTrigger.sqf";
AES_deleteUnits    = compile preprocessFileLineNumbers "scripts\AES\functions\AES_deleteUnits.sqf";
AES_spawnUnits     = compile preprocessFileLineNumbers "scripts\AES\core\AES_spawnUnits.sqf";
AES_setWaypoint    = compile preprocessFileLineNumbers "scripts\AES\functions\AES_setWaypoint.sqf";

private ["_pause","_eosZone","_hints","_side"];
private ["_enemyFaction"];

_settings params["_faction","_markerType","_side",["_heightLimit",false],["_debug",false],["_debugLog",false]];
_basSettings params["_pause","_waves","_timeout","_eosZone",["_hints",false]];

// TODO Refactor this///////////////////////////////////
if (_side==EAST) then {_enemyFaction="east";};        //
if (_side==WEST) then {_enemyFaction="west";};        //
if (_side==INDEPENDENT) then {_enemyFaction="GUER";}; //
if (_side==CIVILIAN) then {_enemyFaction="civ";};     //
////////////////////////////////////////////////////////

private _bastionTriggerReturn = [_marker,_heightLimit,_multipleMarquerAlphaValue select _markerType,_bastionMarquerAlphaValue select _markerType,_enemyFaction] call AES_bastionTrigger;
_bastionTriggerReturn params ["_bastActive","_bastclear","_basActivated"];

// PAUSE IF REQUESTED
if (_pause > 0 and !_initialLaunch) then {
	if (_debugLog) then {[["[AES_log]",_marker,"Wave", _waves,"Inicio_Espera_Inicial","-",_side]] call AES_log;};
	_watingTime = time + _pause;
	_counter = 1;
	waitUntil { 
		if (_hints) then {hint format ["Attack ETA : %1",(_pause - _counter)];};
		sleep 1;
		_counter = _counter +1;
		time > _watingTime
	};
	if (_debugLog) then {[["[AES_log]",_marker,"Wave", _waves,"Fin_Espera_Inicial","-",_side]] call AES_log;};

	[_side,_debugLog,_marker,_waves] call AES_deleteUnits;

};
// SPAWN UNITS AND ADD WAYPOINTS
{
	if (_x select 1 != 0) then {
		_spawnGroup = ([_marker,_x,_angle,_side,_faction] call AES_spawnUnits);
		[_spawnGroup,_x,_marker] call AES_setWaypoint;
		_groups pushBack _spawnGroup;
	};
} forEach _unitsArrays;

waituntil {triggeractivated _bastActive};

_waves = (_waves - 1);
if (_waves >= 1) then {
	if (_debugLog) then {[["[AES_log]",_marker,"Wave", _waves,"Inicio_Espera_proximo_ataque","-",_side]] call AES_log;};
	
	_watingTime = time + _timeout;
	waitUntil { 
		if (_hints) then  {
			if (_waves > 1) then {
				hint format ["Next wave ETA : %1",(_timeout - _counter)];
			};
		};
		sleep 1;
		if (!triggeractivated _bastActive || getmarkercolor _marker == "colorblack") exitwith {
			if (_debug) then {hint "Zone lost. You must re-capture it";};
			_marker setmarkercolor hostileColor;
			_marker setmarkeralpha (_multipleMarquerAlphaValue select _markerType);
			// TODO Revisar el tema de la EOS Zone
			if (_eosZone) then {
				null = [_marker,[_PApatrols,_PAgroupSize],[_PApatrols,_PAgroupSize],[_LVehGroups,_LVgroupSize],[_AVehGroups,0,0,0],[_faction,_markerType,350,_CHside]] execVM "scripts\AES\core\EOS_Core.sqf";
			};
			_waves=0;
		};
		time > _watingTime
	};
	if (_debugLog) then { [["[AES_log]",_marker,"Wave", _waves,"Fin_Espera_proximo_ataque","-",_side]] call AES_log;};
	
	[_side,_debugLog,_marker,_waves] call AES_deleteUnits;
};

if (triggeractivated _bastActive and triggeractivated _bastClear and (_waves < 1) ) then{
		if (_debugLog) then {[["[AES_log]",_marker,"Wave", _waves,"Fin_ataques"]] call AES_log;};
		if (_hints) then  {hint "Waves complete";};
		_marker setmarkercolor VictoryColor;
		_marker setmarkeralpha (_multipleMarquerAlphaValue select _markerType);
}else{
	if (_waves >= 1) then {
		if (_hints) then  {hint "Reinforcements inbound";};
		null = [_marker,_unitsArrays,_settings,[_pause,_waves,_timeout,_eosZone,_hints],_angle,true] execVM "scripts\AES\core\playerDefend.sqf";
	};
};

waituntil {getmarkercolor _marker == "colorblack" OR getmarkercolor _marker == VictoryColor OR getmarkercolor _marker == hostileColor or !triggeractivated  _bastActive};
if (_debug) then {systemChat "delete units";};

deletevehicle _bastActive;
deletevehicle _bastClear;
deletevehicle _basActivated;
if (getmarkercolor _marker == "colorblack") then {_marker setmarkeralpha 0;};

/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/