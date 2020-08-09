/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

//params ["_marker","_infantry","_LVeh","_AVeh","_SVeh","_PTrooper","_HAtrooper","_settings","_basSettings","_angle",["_initialLaunch",false]];

if (!isServer) exitWith {};

params ["_marker","_unitsArrays","_settings","_basSettings","_angle",["_initialLaunch",false]];



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Refactor

private _bastionMarquerAlphaValue  = [1,0,0.5];
private _multipleMarquerAlphaValue = [0.5,0,0.5];
private _spawnGroup                = [];
private _groups                    = [];

AES_bastionTrigger = compile preprocessFileLineNumbers "scripts\AES\functions\AES_bastionTrigger.sqf";
AES_deleteUnits    = compile preprocessFileLineNumbers "scripts\AES\functions\AES_deleteUnits.sqf";
AES_b_spawnUnits   = compile preprocessFileLineNumbers "scripts\AES\core\b_spawnUnits.sqf";
AES_waypoints      = compile preprocessFileLineNumbers "scripts\AES\functions\AES_waypoints.sqf";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private ["_ptGroup","_fGroup","_cargoType","_vehType","_CHside","_mkrAngle","_pause","_eosZone","_hints","_waves","_aGroup","_side"];
private ["_enemyFaction","_distance","_grp","_cGroup","_bGroup","_CHType","_time","_timeout","_faction"];
private ["_troupsPA","_troupsLV","_troupsAV","_troupsHT","_troupsPT","_troupsHA"];


_markerPos = getMarkerPos _marker;
getMarkerSize _marker params ["_mkrX","_mkrY"];
_mkrAngle = markerDir _marker;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TODO Code to remove. Legacy code
_unitsArrays params["_infantry","_LVeh"   ,  "_AVeh" ,   "_SVeh", "_borrar",   "_PTrooper", "_HAtrooper"];
_infantry params["_PApatrols","_PAgroupSize","_PAminDist"];
_LVeh params["_LVehGroups","_LVgroupSize","_LVminDist"];
_AVeh params["_AVehGroups","_AVminDist","_nada"];
_SVeh params["_CHGroups","_fsize","_CHminDist"];
_PTrooper params["_ptNumGroups","_PTSize","_PTminDist","_PTAltSalto"];
_HAtrooper params["_HApatrols","_HAgroupSize","_HAminDist","_HAAltSalto"];
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

_settings params["_faction","_markerType","_side",["_heightLimit",false],["_debug",false],["_debugLog",false]];
_basSettings params["_pause","_waves","_timeout","_eosZone",["_hints",false]];

if (_side==EAST) then {_enemyFaction="east";};
if (_side==WEST) then {_enemyFaction="west";};
if (_side==INDEPENDENT) then {_enemyFaction="GUER";};
if (_side==CIVILIAN) then {_enemyFaction="civ";};

private _bastionTriggerReturn = [_marker,_heightLimit,_multipleMarquerAlphaValue select _markerType,_bastionMarquerAlphaValue select _markerType,_enemyFaction] call AES_bastionTrigger;
_bastionTriggerReturn params ["_bastActive","_bastclear","_basActivated"];

// PAUSE IF REQUESTED
if (_pause > 0 and !_initialLaunch) then {
	if (_debugLog) then {[[_marker,"Wave", _waves,"Inicio_Espera_Inicial","-",_side]] call AES_log;};
	_espera = time + _pause;
	_counter = 1;
	waitUntil { 
		if (_hints) then {hint format ["Attack ETA : %1",(_pause - _counter)];};
		sleep 1;
		_counter = _counter +1;
		time > _espera
	};
	if (_debugLog) then {[[_marker,"Wave", _waves,"Fin_Espera_Inicial","-",_side]] call AES_log;};

	[_side,_debugLog,_marker,_waves] call AES_deleteUnits;

};

// *///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//format ["TD _unitsArrays: %1",_unitsArrays] call BIS_fnc_log;

{
	//format ["_forEachIndex %1",_forEachIndex] call BIS_fnc_log;
	//format ["%1",_x] call BIS_fnc_log;
	if (_x select 1 != 0) then {
		_spawnGroup = ([_marker,_x,_angle,_side,_faction] call AES_b_spawnUnits);
		[_spawnGroup,_x,_marker] call AES_waypoints;
		_groups pushBack _spawnGroup;
	};
} forEach _unitsArrays;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

// ADD WAYPOINTS PATROLS
/*
{
	_getToMarker = _x addWaypoint [_markerPos, 0];
	_getToMarker setWaypointType "SAD";
	_getToMarker setWaypointSpeed "LIMITED";
	_getToMarker setWaypointBehaviour "AWARE";
	_getToMarker setWaypointFormation (["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND", "LINE"] call BIS_fnc_selectRandom);
	_getToMarker setWaypointCompletionRadius 15;
	_getToMarker setWaypointCombatMode "RED";
}foreach _aGroup;
/*
// ADD WAYPOINTS LIGHT VEHICLES
{
	_dir_atk= _markerPos getDir (_x select 0);
	_pos = [_markerPos, (_mkrX + random 100), _dir_atk] call BIS_fnc_relPos;
	_getToMarker = (_x select 2) addWaypoint [_pos, 0];
	_getToMarker setWaypointType "UNLOAD";
	_getToMarker setWaypointSpeed "LIMITED";
	_getToMarker setWaypointBehaviour "SAFE";
	_getToMarker setWaypointFormation "NO CHANGE";
	_getToMarker setWaypointCombatMode "RED";
	_pos = [_markerPos, 150, _dir_atk] call BIS_fnc_relPos;
	_wp = (_x select 2) addWaypoint [_Pos, 1];
	_wp setWaypointType "SAD";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointBehaviour "AWARE";
	_wp setWaypointFormation "NO CHANGE";
	_wp setWaypointCombatMode "RED";
}foreach _bGrp;

// ADD WAYPOINTS ARMOURED VEHICLES
{
	_dir_atk= _markerPos getDir (_x select 0);
	_pos = [_markerPos, (_mkrX + random 100), _dir_atk] call BIS_fnc_relPos;
	_group = (_x select 2);
	_leader = leader _group;
	_leader doMove _pos;
	_getToMarker = (_x select 2) addWaypoint [_pos, 0];
	_getToMarker setWaypointType "SAD";
	_getToMarker setWaypointSpeed "LIMITED";
	_getToMarker setWaypointBehaviour "AWARE";
	_getToMarker setWaypointFormation "NO CHANGE";
	_getToMarker setWaypointCombatMode "RED";
}foreach _cGrp;

// ADD WAYPOINTS HALO
{
	_getToMarker = _x addWaypoint [_markerPos, 0];
	_getToMarker setWaypointType "SAD";
	_getToMarker setWaypointSpeed "LIMITED";
	_getToMarker setWaypointBehaviour "AWARE";
	_getToMarker setWaypointFormation (["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND", "LINE"] call BIS_fnc_selectRandom);
	_getToMarker setWaypointCompletionRadius 50;
	_getToMarker setWaypointCombatMode "RED";
}foreach _HAGroup;
*/
waituntil {triggeractivated _bastActive};

_waves=(_waves - 1);
if (_waves >= 1) then {
	if (_debugLog) then {[[_marker,"Wave", _waves,"Inicio_Espera_proximo_ataque","-",_side]] call AES_log;};
	
	_espera = time + _timeout;
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
		time > _espera
	};
	if (_debugLog) then { [[_marker,"Wave", _waves,"Fin_Espera_proximo_ataque","-",_side]] call AES_log;};
	
	[_side,_debugLog,_marker,_waves] call AES_deleteUnits;
	
};

if (triggeractivated _bastActive and triggeractivated _bastClear and (_waves < 1) ) then{
		if (_debugLog) then {[[_marker,"Wave", _waves,"Fin_ataques"]] call AES_log;};
		if (_hints) then  {hint "Waves complete";};
		_marker setmarkercolor VictoryColor;
		_marker setmarkeralpha (_multipleMarquerAlphaValue select _markerType);
}else{
	if (_waves >= 1) then {
		if (_hints) then  {hint "Reinforcements inbound";};
		//null = [_marker,[_PApatrols,_PAgroupSize],         [_LVehGroups,_LVgroupSize],           [_AVehGroups],           [_CHGroups,_fSize]                                                                                                      ,_settings,[_pause,_waves,_timeout,_eosZone,_hints],_angle,true] execVM "eos\core\b_core.sqf";
		//null = [_marker,[_PApatrols,_PAgroupSize,_PAminDist],[_LVehGroups,_LVgroupSize,_LVminDist],[_AVehGroups,_AVminDist],[_CHGroups,_fSize,_CHminDist],[_ptNumGroups,_PTSize,_PTminDist,_PTAltSalto],[_HApatrols,_HAgroupSize,_HAminDist,_HAAltSalto],_settings,[_pause,_waves,_timeout,_eosZone,_hints],_angle,true] execVM "scripts\AES\core\b_core.sqf";
		null = [_marker,_unitsArrays,_settings,[_pause,_waves,_timeout,_eosZone,_hints],_angle,true] execVM "scripts\AES\core\toDefend.sqf";
	};
};

waituntil {getmarkercolor _marker == "colorblack" OR getmarkercolor _marker == VictoryColor OR getmarkercolor _marker == hostileColor or !triggeractivated  _bastActive};
if (_debug) then {systemChat "delete units";};





//hint "Ataques finalizados"; //TODO Borrar

//if (_debug) then {systemChat "delete wp";};


//TODO los para cuando termina la ola no al final de las olas
// Borro los wp de las unidades
/*_todos = allGroups select {side _x isEqualTo _side};//returns all groups of _side
//systemChat (format ["_selection: %1",count _todos]);
{
	for "_i" from count waypoints _x - 1 to 0 step -1 do{
		deleteWaypoint [_x, _i];
	};
	{
		doStop _x
	}forEach units _x;
}forEach _todos;
*/

// Modificado por Vultur. Evito que borre todas las unidades activas al terminar las olas
/*
borroWP={
	params ["_group"];
	for "_i" from count waypoints _group - 1 to 0 step -1 do{
		deleteWaypoint [_group, _i];
	};
	/*if(count waypoints _group > 0)then{
		{
			deleteWaypoint((waypoints _group)select 0);
		}forEach waypoints _group;
	};* /
	{
		doStop _x
	}forEach units _group;
};

// BORRO WAYPOINTS TROPAS
{
	[_x] call borroWP;
}foreach _aGroup;

systemChat (format ["_bGrp: %1",count _bGrp]);
//BORRO WAYPOINTS LIGHT VEHICLES
if (count _bGrp > 0) then
{
	{
		/*_vehicle = _x select 0;
		_crew = _x select 1;
		_grp = _x select 2;
		{deleteVehicle _x} forEach (_crew);
		if (!(vehicle player == _vehicle)) then
			{{deleteVehicle _x} forEach[_vehicle];
		};
		{deleteVehicle _x} foreach units _grp;
		deleteGroup _grp;* /
		{
			[_x select 2] call borroWP;
		}foreach _cGrp;
		systemChat "LISTO";
	}foreach _bGrp;
};

// BORRO WAYPOINTS ARMOURED VEHICLES
if (count _cGrp > 0) then
{
	{
		[_x select 2] call borroWP;
	}foreach _cGrp;
};


*/
// CACHE HELICOPTER TRANSPORT
/*if (count _fGrp > 0) then {
	{
		_vehicle = _x select 0;_crew = _x select 1;//_grp = _x select 2; _cargoGrp = _x select 3;
		{deleteVehicle _x} forEach (_crew);
		if (!(vehicle player == _vehicle)) then {{deleteVehicle _x} forEach[_vehicle];};
		//{deleteVehicle _x} foreach units _grp;deleteGroup _grp;
		//{deleteVehicle _x} foreach units _cargoGrp;deleteGroup _cargoGrp;

	}foreach _fGrp;
};
hint "Borro Helis PT";
{
	systemChat format ["_vehicle %1 _crew %2 %3",_vehicle,_crew,time];
	[[_marker,"Wave", _waves,"_vehicle",_vehicle,_side,_crew]] call AES_log;
	_vehicle = _x select 0;_crew = _x select 1;//_grp = _x select 2; _cargoGrp = _x select 3;
	{deleteVehicle _x} forEach (_crew);
	if (!(vehicle player == _vehicle)) then {{deleteVehicle _x} forEach[_vehicle];};
	//{deleteVehicle _x} foreach units _grp;deleteGroup _grp;
	//{deleteVehicle _x} foreach units _cargoGrp;deleteGroup _cargoGrp;

}foreach _ptGrp;



// */
deletevehicle _bastActive;
deletevehicle _bastClear;
deletevehicle _basActivated;
if (getmarkercolor _marker == "colorblack") then {_marker setmarkeralpha 0;};

/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/