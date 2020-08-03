/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/

AES_enemiesPosition = compile preprocessFileLineNumbers "scripts\AES\functions\AES_enemiesPosition.sqf";
AES_HALO            = compile preprocessFileLineNumbers "scripts\AES\functions\AES_HALO.sqf";


params ["_marker","_unitData","_angle","_side","_faction"];

//AES_UNIT_TYPE [["patrol",0,"PA",findSafePos(default true)]
//      "_vehType","_cargoType","_typeMessage"

// _unitData -> ["patrol",3,500,[2,4]]

//format ["afuera %1 %2 %3",_marker,_unitData,_angle] call BIS_fnc_log;

private ["_vehType","_cargoType","_typeMessage","_findSafePosition"];

private _groups       = [];
private _grp          = [];
private _troupsNumber = 0;
private _position     = [];
//TODO estudiar que pasa con _cargoGrp
private _cargoGrp = [];

_unitType = AES_UNIT_TYPE select {(_x select 0) == (_unitData select 0) } select 0;
_unitType = if (isNil "_unitType") then {[]} else {_unitType};

format ["SU _unitType: %1",_unitType] call BIS_fnc_log;
format ['SU _unitData: %1',_unitData]  call BIS_fnc_log;

if (count(_unitType) > 0) then {
	_vehType     = _unitType select 0;
	_cargoType   = _unitType select 1;
	_typeMessage = _unitType select 2;
	_findSafePosition = if (count(_unitType) > 3 ) then {_unitType select 3} else {true};
};

for "_counter" from 1 to (_unitData select 1) do {
	_position = [_marker,_unitData select 2,_angle] call AES_enemiesPosition;
    if (_findSafePosition) then {
        while {(surfaceiswater _position)} do {
            _position = [_marker,_unitData select 2,_angle] call AES_enemiesPosition;
        };		
		for "_counter" from 0 to 20 do {
			_newPosition = [_position,0,50,5,0,20,0] call BIS_fnc_findSafePos;
			if ((_position distance _newPosition) < 55) exitWith {
				_position = _newPosition;
			};
		};
	};
	if (_vehType == "patrol" || _vehType == "halo") then {
		if (_vehType == "halo") then { 
			private _HAAltSalto = AES_DEFAULT_JUMP_PARA select {(_x select 0) == _vehType} select 0 select 1;
			_HAAltSalto = if (isNil "_HAAltSalto") then {0} else {_HAAltSalto};
			_position = [ _position select 0, _position select 1, (_position select 2) + _HAAltSalto];
		};
		
		//format ['SU |%1|%2|%3|%4|',_position,_unitData select 3,_faction,_side]  call BIS_fnc_log;
        _grp=[_position,_unitData select 3,_faction,_side] call EOS_fnc_spawngroup;
        _grp setGroupId [format ["%1 %2 %3-%4",_marker,_typeMessage,_waves,_counter]];
        _troupsNumber = _troupsNumber + count units _grp;
		_groups pushBack _grp;
		if (_vehType == "halo") then {[_grp] call AES_HALO;};
		
    };
	if (_vehType == "light vehicle" || _vehType == "cargo helo" || _vehType == "para helo") then {
        
		private _special = if (["helo",_vehType]call BIS_fnc_inString) then {"FLY"} else {"CAN_COLLIDE"};
		_groups = [_position,_vehType,_faction,_side,_special]call EOS_fnc_spawnvehicle;

		_cargoGrp = createGroup _side;		
		0 = [_groups select 0,_unitData select 3,_cargoGrp,_faction,_cargoType] call eos_fnc_setcargo;

		// TODO ver esta linea -> 0 = [(_groups select 2),"LIGskill"] call eos_fnc_grouphandlers;
		_cargoGrp setGroupId [format ["%1 %2 %3-%4",_marker,_typeMessage,_waves,_counter]];
		_troupsNumber = _troupsNumber + count units _cargoGrp;
		_groups pushBack _cargoGrp;
		if (_vehType == "cargo helo") then {
			format ['SU _groups: %1',_groups]  call BIS_fnc_log;
			[_marker,_groups,_counter] execvm "scripts\AES\functions\TransportUnload_fnc.sqf";
		};
		// Formato de LV
		//0 = [(_grp select 0),_unitData select 3,(_grp select 2),_faction,_cargoType] call eos_fnc_setcargo;
		//(_grp select 2) setGroupId [format ["%1 %2 %3-%4",_marker,_typeMessage,_waves,_counter]];
		//_troupsNumber = _troupsNumber + count units (_grp select 2);
		//_groups pushBack _grp;

		
	}
	
};
_groups
/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/
//	format ['SU _grp: %1',_grp]  call BIS_fnc_log;

/*
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
		null = [_marker,_fGroup,_counter] execvm "scripts\AES\functions\TransportUnload_fnc.sqf";
	} else {// attack wp
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
if (_debugLog) then {[[_marker,"Wave",_waves,"Total_Tropas_TranspotHeli",_troupsHT,_side]] call AES_log;};

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
	null = [_marker,_ptGroup,_counter,_PTAltSalto] execvm "scripts\AES\functions\TransportParachute_fnc.sqf";
	if (_debug) then {
			systemChat format ["Chopper:%1",_counter];
			0= [_marker,_counter,"Chopper",(getpos leader (_ptGroup select 2))] call EOS_debug;
	};
};
if (_debugLog) then {[[_marker,"Wave",_waves,"Total_Tropas_ParatroopersHeli",_troupsPT,_side]] call AES_log;};


// */
