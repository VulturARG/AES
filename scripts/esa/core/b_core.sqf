/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

//params ["_marker","_infantry","_LVeh","_AVeh","_SVeh","_PTrooper","_HAtrooper","_settings","_basSettings","_angle",["_initialLaunch",false]];

if (!isServer) exitWith {};

params ["_marker","_unitsArrays","_settings","_basSettings","_angle",["_initialLaunch",false]];


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Refactor
private _typeVehicle               = [[0,0],[7,9],[2,0],[3,0],[4,9],[4,9],[0,0]];
private _typeMessage               = ["PA","LV","AV","AH","TH","PT","HA"];
private _bastionMarquerAlphaValue  = [1,0,0.5];
private _multipleMarquerAlphaValue = [0.5,0,0.5];
_multipleMarquerAlphaValue call ESA_log;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private ["_ptGroup","_fGroup","_cargoType","_vehType","_CHside","_mkrAngle","_pause","_eosZone","_hints","_waves","_aGroup","_side"];
private ["_actCond","_enemyFaction",/*"_mAH","_mAN",*/"_distance","_grp","_cGroup","_bGroup","_CHType","_time","_timeout","_faction"];
private ["_troupsPA","_troupsLV","_troupsAV","_troupsHT","_troupsPT","_troupsHA"];
private ["_enemigos","_unconscious"];

_markerPos = getMarkerPos _marker;
getMarkerSize _marker params ["_mkrX","_mkrY"];
_mkrAngle=markerDir _marker;

/*
_infantry params["_PApatrols","_PAgroupSize","_PAminDist"];
_LVeh params["_LVehGroups","_LVgroupSize","_LVminDist"];
_AVeh params["_AVehGroups","_AVminDist"];
_SVeh params["_CHGroups","_fsize","_CHminDist"];
_PTrooper params["_ptNumGroups","_PTSize","_PTminDist","_PTAltSalto"];
_HAtrooper params["_HApatrols","_HAgroupSize","_HAminDist","_HAAltSalto"];
*/
_settings params["_faction","_markerType","_side",["_heightLimit",false],["_debug",false],["_debugLog",false]];
_basSettings params["_pause","_waves","_timeout","_eosZone",["_hints",false]];

_Placement=(_mkrX + 500);

//_mAH marquer alpha Value bastionColor                           -> _bastionMarquerAlphaValue
//_mAN marquer alpha Value VictoryColor hostileColor bastionColor -> _multipleMarquerAlphaValue

/*
if (_markerType==0) then {_mAH = 1;_mAN = 0.5;};
if (_markerType==1) then {_mAH = 0;_mAN = 0;};
if (_markerType==2) then {_mAH = 0.5;_mAN = 0.5;};
*/
if (_side==EAST) then {_enemyFaction="east";};
if (_side==WEST) then {_enemyFaction="west";};
if (_side==INDEPENDENT) then {_enemyFaction="GUER";};
if (_side==CIVILIAN) then {_enemyFaction="civ";};

if ismultiplayer then {
	if (_heightLimit) then{
		_actCond="{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count playableunits > 0";
	} else	{
		_actCond="{vehicle _x in thisList && isplayer _x} count playableunits > 0";
	};
} else {
	if (_heightLimit) then {
		_actCond="{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count allUnits > 0";
	}else {
		_actCond="{vehicle _x in thisList && isplayer _x} count allUnits > 0";
	};
};

_basActivated = createTrigger ["EmptyDetector",_markerPos];
_basActivated setTriggerArea [_mkrX,_mkrY,_mkrAngle,FALSE];
_basActivated setTriggerActivation ["ANY","PRESENT",true];
_basActivated setTriggerStatements [_actCond,"",""];

_marker setmarkercolor bastionColor;
_marker setmarkeralpha _multipleMarquerAlphaValue select _markerType;

waituntil {triggeractivated _basActivated};
_marker setmarkercolor bastionColor;
_marker setmarkeralpha _bastionMarquerAlphaValue select _markerType;

_bastActive = createTrigger ["EmptyDetector",_markerPos];
_bastActive setTriggerArea [_mkrX,_mkrY,_mkrAngle,FALSE];
_bastActive setTriggerActivation ["any","PRESENT",true];
_bastActive setTriggerTimeout [1, 1, 1, true];
_bastActive setTriggerStatements [_actCond,"",""];

_bastClear = createTrigger ["EmptyDetector",_markerPos];
_bastClear setTriggerArea [(_mkrX+(_Placement*0.3)),(_mkrY+(_Placement*0.3)),_mkrAngle,FALSE];
_bastClear setTriggerActivation [_enemyFaction,"NOT PRESENT",true];
_bastClear setTriggerStatements ["this","",""];

// PAUSE IF REQUESTED
if (_pause > 0 and !_initialLaunch) then {
	if (_debugLog) then {[[_marker,"Wave", _waves,"Inicio_Espera_Inicial","-",_side]] call ESA_log;};
	_espera = time + _pause;
	_counter = 1;
	waitUntil { 
		if (_hints) then {hint format ["Attack ETA : %1",(_pause - _counter)];};
		sleep 1;
		_counter = _counter +1;
		time > _espera
	};
	if (_debugLog) then {[[_marker,"Wave", _waves,"Fin_Espera_Inicial","-",_side]] call ESA_log;};
	
	// Delete all unconscious IAs
	_unconscious = allUnits select {_x getVariable "ACE_isUnconscious" isEqualTo true && !isPlayer _x && (side _x == _side)};
	if (_debugLog) then {[[_marker,"Wave", _waves,"Inconscientes",count _unconscious,_side]] call ESA_log;};
	{
		_x setDamage 1;
	} forEach _unconscious;
	if (_debugLog) then {
		_unconscious = allUnits select {_x getVariable "ACE_isUnconscious" isEqualTo true && !isPlayer _x && (side _x == _side)};
		[[_marker,"Wave", _waves,"Inconscientes(Post)",count _unconscious,_side]] call ESA_log;
	};

	//Borro las unidades que estan a mas de una determinada distancia 
	_enemigos = allUnits select {side _x == _side && _x iskindof "Man" && (_markerPos distance2D _x) > DELETE_DISTANCE}; 
	if (_debugLog) then {[[_marker,"Wave", _waves,"IAs>DELETE_DISTANCE",count _enemigos,_side]] call ESA_log;};
	{ 
		if (!(isPlayer _x))then { 
			_x setDamage 1 
		} 
	}foreach _enemigos;
	if (_debugLog) then {
		_enemigos = allUnits select {side _x == _side && _x iskindof "Man" && (_markerPos distance2D _x) > DELETE_DISTANCE}; 
		[[_marker,"Wave", _waves,"IAs>DELETE_DISTANCE(Post)",count _enemigos,_side]] call ESA_log;
	}
};

/* TODO refactor of spawn units
{
	
	
} forEach _unitsArrays;
*/
// SPAWN PATROLS
_aGroup=[];
_troupsPA = 0;
for "_counter" from 1 to _PApatrols do {
	_dir_atk=_mkrAngle+(random _angle)-_angle/2;
	_Place=(_PAminDist + random 75);
	_pos = [_markerPos, _Place, _dir_atk] call BIS_fnc_relPos;
	while {(surfaceiswater _pos)} do {
		_dir_atk=_mkrAngle+(random _angle)-_angle/2;
		_pos = [_markerPos, _Place, _dir_atk] call BIS_fnc_relPos;
	};
	for "_counter" from 0 to 20 do {
		_newpos = [_pos,0,50,5,1,20,0] call BIS_fnc_findSafePos;
		if ((_pos distance _newpos) < 55)
			exitWith {
			_pos = _newpos;
		};
	};	
	_grp=[_pos,_PAgroupSize,_faction,_side] call EOS_fnc_spawngroup;
	_grp setGroupId [format ["%1 PA %2-%3",_marker,_waves,_counter]];
	_troupsPA = _troupsPA + count units _grp;
	_aGroup set [count _aGroup,_grp];
	if (_debug) then {
		systemChat (format ["Spawned Patrol: %1",_counter]);
		0= [_marker,_counter,"patrol",getpos (leader _grp)] call EOS_debug;
	};
	
};
if (_debugLog) then {[[_marker,"Wave",_waves,"Total_Tropas_Patrullas",_troupsPA,_side]] call ESA_log;};

//SPAWN LIGHT VEHICLES
_bGrp=[];
_troupsLV = 0;
for "_counter" from 1 to _LVehGroups do {
	_dir_atk=_mkrAngle+(random _angle)-_angle/2;
	_Place=(_mkrX + _LVminDist + random 100);
	_newpos = [_markerPos, _Place, _dir_atk] call BIS_fnc_relPos;

	while {(surfaceiswater _newpos)} do {
		_dir_atk=_mkrAngle+(random _angle)-_angle/2;
		_pos = [_markerPos, _Place, _dir_atk] call BIS_fnc_relPos;
	};
	_vehType=7;_cargoType=9;
	_bGroup=[_newpos,_side,_faction,_vehType]call EOS_fnc_spawnvehicle;
	if ((_LVgroupSize select 0) > 0) then{
		0=[(_bGroup select 0),_LVgroupSize,(_bGroup select 2),_faction,_cargoType] call eos_fnc_setcargo;
	};
	0 = [(_bGroup select 2),"LIGskill"] call eos_fnc_grouphandlers;
	(_bGroup select 2) setGroupId [format ["%1 LV %2-%3",_marker,_waves,_counter]];
	_troupsLV = _troupsLV + count units (_bGroup select 2);
	_bGrp set [count _bGrp,_bGroup];
	if (_debug) then {
		systemChat format ["Light Vehicle:%1 - r%2",_counter,_LVehGroups];
		0= [_marker,_counter,"Light Veh",(getpos leader (_bGroup select 2))] call EOS_debug;
	};
};
if (_debugLog) then {[[_marker,"Wave",_waves,"Total_Tropas_LightVehicles",_troupsLV,_side]] call ESA_log;};

//SPAWN ARMOURED VEHICLES
_cGrp=[];
_troupsAV = 0;
for "_counter" from 1 to _AVehGroups do {
	_dir_atk=_mkrAngle+(random _angle)-_angle/2;
	_Place=(_mkrX + _AVminDist + random 100);
	_newpos = [_markerPos, _Place, _dir_atk] call BIS_fnc_relPos;
	while {(surfaceiswater _newpos)} do {
		_dir_atk=_mkrAngle+(random _angle)-_angle/2;
		_newpos = [_markerPos, _Place, _dir_atk] call BIS_fnc_relPos;
	};
	_vehType=2;
	_cGroup=[_newpos,_side,_faction,_vehType]call EOS_fnc_spawnvehicle;
	0=[(_cGroup select 2),"ARMskill"] call eos_fnc_grouphandlers;
	(_cGroup select 2) setGroupId [format ["%1 AV %2-%3",_marker,_waves,_counter]];
	_troupsAV = _troupsAV + count units (_cGroup select 2);
	_cGrp set [count _cGrp,_cGroup];
	if (_debug) then {
		systemChat format ["Armoured:%1 - r%2",_counter,_AVehGroups];
		0= [_marker,_counter,"Armour",(getpos leader (_cGroup select 2))] call EOS_debug;
	};
};
if (_debugLog) then {[[_marker,"Wave",_waves,"Total_Tropas_ArmoredVehicles",_troupsAV,_side]] call ESA_log;};

//SPAWN HELICOPTERS (ataque o transporte)
_fGrp=[];
_troupsHT = 0;
for "_counter" from 1 to _CHGroups do {
	if ((_fSize select 0) > 0) then {
		_vehType=4;
	} else {
		_vehType=3;
	};
	_dir_atk=_mkrAngle+(random _angle)-_angle/2;
	_Place=(_mkrX + _CHminDist + random 100);
	_newpos = [_markerPos, _Place, _dir_atk] call BIS_fnc_relPos;
	_fGroup=[_newpos,_side,_faction,_vehType,"fly"] call EOS_fnc_spawnvehicle;
	_CHside=_side;
	_fGrp set [count _fGrp,_fGroup];
	if ((_fSize select 0) > 0) then {
		_cargoGrp = createGroup _side;
		0=[(_fGroup select 0),_fSize,_cargoGrp,_faction,9] call eos_fnc_setcargo;
		0=[_cargoGrp,"INFskill"] call eos_fnc_grouphandlers;
		_cargoGrp setGroupId [format ["%1 HT %2-%3",_marker,_waves,_counter]];
		_troupsHT = _troupsHT + count units _cargoGrp;
		_fGroup set [count _fGroup,_cargoGrp];
		null = [_marker,_fGroup,_counter] execvm "scripts\esa\functions\TransportUnload_fnc.sqf";
	} else {
		_wp1 = (_fGroup select 2) addWaypoint [(markerpos _marker), 0];
		_wp1 setWaypointSpeed "FULL";
		_wp1 setWaypointType "SAD";
		_wp1 setWaypointBehaviour "COMBAT";
		_wp1 setWaypointCombatMode "RED";
	};
	if (_debug) then {
			systemChat format ["Chopper:%1",_counter];
			0= [_marker,_counter,"Chopper",(getpos leader (_fGroup select 2))] call EOS_debug;
	};
};
if (_debugLog) then {[[_marker,"Wave",_waves,"Total_Tropas_TranspotHeli",_troupsHT,_side]] call ESA_log;};

//SPAWN HELICOPTERS WITH PARATROOPERS (New)
_ptGrp=[];
_ptGroup=[];
_troupsPT = 0;
for "_counter" from 1 to _ptNumGroups do {
	_vehType=4;
	_dir_atk=_mkrAngle+(random _angle)-_angle/2;
	_Place=(_mkrX + _PTminDist + random 100);
	_newpos = [_markerPos, _Place, _dir_atk] call BIS_fnc_relPos;
	_ptGroup=[_newpos,_side,_faction,_vehType,"fly"] call EOS_fnc_spawnvehicle;
	_ptGrp set [count _ptGrp,_ptGroup];
	_cargoGrpPT = createGroup _side;
	0=[(_ptGroup select 0),_ptSize,_cargoGrpPT,_faction,9] call eos_fnc_setcargo;
	0=[_cargoGrpPT,"INFskill"] call eos_fnc_grouphandlers;
	_cargoGrpPT setGroupId [format ["%1 PT %2-%3",_marker,_waves,_counter]];
	_troupsPT = _troupsPT + count units _cargoGrpPT;
	_ptGroup set [count _ptGroup,_cargoGrpPT];
	null = [_marker,_ptGroup,_counter,_PTAltSalto] execvm "scripts\esa\functions\TransportParachute_fnc.sqf";
	if (_debug) then {
			systemChat format ["Chopper:%1",_counter];
			0= [_marker,_counter,"Chopper",(getpos leader (_ptGroup select 2))] call EOS_debug;
	};
};
if (_debugLog) then {[[_marker,"Wave",_waves,"Total_Tropas_ParatroopersHeli",_troupsPT,_side]] call ESA_log;};

// SPAWN HALO (New)
_HAGroup=[];
_troupsHA = 0;

for "_counter" from 1 to _HApatrols do {
	_dir_atk=_mkrAngle+(random _angle)-_angle/2;
	_Place=(_HAminDist + random 100);
	_pos = [_markerPos, _Place, _dir_atk] call BIS_fnc_relPos;
	while {(surfaceiswater _pos)} do {
		_dir_atk=_mkrAngle+(random _angle)-_angle/2;
		_pos = [_markerPos, _Place, _dir_atk] call BIS_fnc_relPos;
	};
	for "_counter" from 0 to 20 do {
	_newpos = [_pos,0,50,5,1,20,0] call BIS_fnc_findSafePos;
		if ((_pos distance _newpos) < 55)
			exitWith {
			_pos = [ _newpos select 0, _newpos select 1,_pos select 2];
		};
	};
	_pos = [ _pos select 0, _pos select 1, (_pos select 2) + _HAAltSalto];
	_grp=[_pos,_HAgroupSize,_faction,_side] call EOS_fnc_spawngroup;
	_grp setGroupId [format ["%1 HA %2-%3",_marker,_waves,_counter]];
	_troupsHA = _troupsHA + count units _grp;
	_HAGroup set [count _HAGroup,_grp];
	if (_debug) then {
		systemChat (format ["Spawned HALO: %1",_counter]);
		0= [_marker,_counter,"HALO",getpos (leader _grp)] call EOS_debug;
	};
	
	{
		_inv = name _x;// Get Unique name for Unit's loadout.
		[_x, [missionNamespace, format["%1%2", "Inventory",_inv]]] call BIS_fnc_saveInventory;// Save Loadout
		removeBackpack _x;
		_x allowdamage false;// Trying to prevent damage.
		_x addBackPack "B_parachute";
	} forEach units _grp;

	{
		[_x,50] spawn paraLandSafeHA;
	} forEach units _grp;
};
if (_debugLog) then {
	[[_marker,"Wave",_waves,"Total_Tropas_HALO",_troupsHA,_side]] call ESA_log;
	[[_marker,"Wave",_waves,"Total_Tropas_Desplegadas",_troupsPA+_troupsLV+_troupsAV+_troupsHT+_troupsPT+_troupsHA,_side]] call ESA_log;
};

// ADD WAYPOINTS PATROLS
{
	_getToMarker = _x addWaypoint [_markerPos, 0];
	_getToMarker setWaypointType "SAD";
	_getToMarker setWaypointSpeed "LIMITED";
	_getToMarker setWaypointBehaviour "AWARE";
	_getToMarker setWaypointFormation (["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND", "LINE"] call BIS_fnc_selectRandom);
	_getToMarker setWaypointCompletionRadius 15;
	_getToMarker setWaypointCombatMode "RED";
}foreach _aGroup;

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

waituntil {triggeractivated _bastActive};

_waves=(_waves - 1);
if (_waves >= 1) then {
	if (_debugLog) then {[[_marker,"Wave", _waves,"Inicio_Espera_proximo_ataque","-",_side]] call ESA_log;};
	
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
			_marker setmarkeralpha _multipleMarquerAlphaValue select _markerType;
			// TODO Revisar el tema de la EOS Zone
			if (_eosZone) then {
				null = [_marker,[_PApatrols,_PAgroupSize],[_PApatrols,_PAgroupSize],[_LVehGroups,_LVgroupSize],[_AVehGroups,0,0,0],[_faction,_markerType,350,_CHside]] execVM "scripts\esa\core\EOS_Core.sqf";
			};
			_waves=0;
		};
		time > _espera
	};
	if (_debugLog) then { [[_marker,"Wave", _waves,"Fin_Espera_proximo_ataque","-",_side]] call ESA_log;};
	// Busco todas las IAs inconcientes
	_unconscious = allUnits select {_x getVariable "ACE_isUnconscious" isEqualTo true && !isPlayer _x && (side _x == _side)};
	if (_debugLog) then {[[_marker,"Wave", _waves,"Inconscientes_2",count _unconscious,_side]] call ESA_log;};
	{
		_x setDamage 1;
	} forEach _unconscious;
	if (_debugLog) then {
		_unconscious = allUnits select {_x getVariable "ACE_isUnconscious" isEqualTo true && !isPlayer _x && (side _x == _side)};
		[[_marker,"Wave", _waves,"Inconscientes_2(Post)",count _unconscious,_side]] call ESA_log;
	};

	//Borro las unidades que estan a mas de una determinada distancia 
	_enemigos = allUnits select {side _x == _side && _x iskindof "Man" && (_markerPos distance2D _x) > DELETE_DISTANCE}; 
	if (_debugLog) then {[[_marker,"Wave", _waves,"IAs>DELETE_DISTANCE_2",count _enemigos,_side]] call ESA_log;};
	{ 
		if (!(isPlayer _x))then { 
			_x setDamage 1 
		} 
	}foreach _enemigos;
	if (_debugLog) then {
		_enemigos = allUnits select {side _x == _side && _x iskindof "Man" && (_markerPos distance2D _x) > DELETE_DISTANCE}; 
		[[_marker,"Wave", _waves,"IAs>DELETE_DISTANCE(Post)_2",count _enemigos,_side]] call DELETE_DISTANCE;
	}
};

if (triggeractivated _bastActive and triggeractivated _bastClear and (_waves < 1) ) then{
		if (_debugLog) then {[[_marker,"Wave", _waves,"Fin_ataques"]] call ESA_log;};
		if (_hints) then  {hint "Waves complete";};
		_marker setmarkercolor VictoryColor;
		_marker setmarkeralpha _multipleMarquerAlphaValue select _markerType;
}else{
	if (_waves >= 1) then {
		if (_hints) then  {hint "Reinforcements inbound";};
		//null = [_marker,[_PApatrols,_PAgroupSize],         [_LVehGroups,_LVgroupSize],           [_AVehGroups],           [_CHGroups,_fSize]                                                                                                      ,_settings,[_pause,_waves,_timeout,_eosZone,_hints],_angle,true] execVM "eos\core\b_core.sqf";
		null = [_marker,[_PApatrols,_PAgroupSize,_PAminDist],[_LVehGroups,_LVgroupSize,_LVminDist],[_AVehGroups,_AVminDist],[_CHGroups,_fSize,_CHminDist],[_ptNumGroups,_PTSize,_PTminDist,_PTAltSalto],[_HApatrols,_HAgroupSize,_HAminDist,_HAAltSalto],_settings,[_pause,_waves,_timeout,_eosZone,_hints],_angle,true] execVM "scripts\esa\core\b_core.sqf";
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
	[[_marker,"Wave", _waves,"_vehicle",_vehicle,_side,_crew]] call ESA_log;
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