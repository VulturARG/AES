/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/

AES_enemiesPosition = compile preprocessFileLineNumbers "scripts\AES\functions\AES_enemiesPosition.sqf";
AES_HALO            = compile preprocessFileLineNumbers "scripts\AES\functions\AES_HALO.sqf";

params ["_marker","_unitData","_angle","_side","_faction"];

// AES_UNIT_TYPE [["patrol",0,"PA",findSafePos(default true)]
//      "_vehType","_cargoType","_typeMessage"
// _unitData -> ["patrol",3,500,[2,4]]

private ["_vehType","_cargoType","_typeMessage","_findSafePosition"];

private _groups       = [];
private _grp          = [];
private _troupsNumber =  0;
private _position     = [];
private _cargoGrp     = [];

_unitType = AES_UNIT_TYPE select {(_x select 0) == (_unitData select 0) } select 0;
_unitType = if (isNil "_unitType") then {[]} else {_unitType};

if (count(_unitType) > 0) then {
	_vehType     = _unitType select 0;
	_cargoType   = _unitType select 1;
	_typeMessage = _unitType select 2;
	_findSafePosition = if (count(_unitType) > 3 ) then {_unitType select 3} else {true};
};

for "_counter" from 1 to (_unitData select 1) do {
	_position = [_marker, _unitData select 2, _angle] call AES_enemiesPosition;
    if (_findSafePosition) then {
        private _safeDistance = (_unitData select 2);
		while { count (allPlayers select { _x distance _position <= (_unitData select 2) }) > 0} do {
			_safeDistance  = _safeDistance + 25;
			_newData       = [_marker ,(_unitData select 2) + _safeDistance, _angle];
			_position      = _newData call AES_enemiesPosition;
		};
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
		
		_grp = [_position,_unitData select 3,_faction,_side] call AES_fnc_spawnInfantry;
        _grp setGroupIdGlobal [format ["%1 %2 %3-%4",_marker,_typeMessage,_waves,_counter]];
		_grp setVariable ["AES_GROUP_NAME", format ["%1 %2 %3-%4",_marker,_typeMessage,_waves,_counter], true];

        _troupsNumber = _troupsNumber + count units _grp;
		if (_debugLog) then {[["[AES_log]",groupId _grp,"_troupsNumber", _troupsNumber]] call AES_log;};

		_groups pushBack [[],[],_grp];

		if (_vehType == "halo") then {[_grp] call AES_HALO;};
		
    } else {
		private _special = if (["chopper",_vehType]call BIS_fnc_inString) then {"FLY"} else {"CAN_COLLIDE"};
		_grp = [_position,_vehType,_faction,_side,_special]call eos_fnc_spawnVehicle;
		_grp setGroupIdGlobal [format ["%1 %2 %3-%4",_marker,_typeMessage,_waves,_counter]];
		_grp setVariable ["AES_GROUP_NAME", format ["%1 %2 %3-%4",_marker,_typeMessage,_waves,_counter], true];

		if (_vehType == "light vehicle" || _vehType == "cargo chopper" || _vehType == "para chopper") then {
			_cargoGrp = createGroup _side;		
			[_grp select 0,_unitData select 3,_cargoGrp,_faction,_cargoType] call eos_fnc_setCargo;

			// TODO ver esta linea -> [(_grp select 2),"LIGskill"] call eos_fnc_setSkill;
			_cargoGrp setGroupId [format ["%1 %2 %3-%4",_marker,_typeMessage,_waves,_counter]];
			_troupsNumber = _troupsNumber + count units _cargoGrp;
			if (_debugLog) then {[["[AES_log]",groupId _grp,"_troupsNumber", _troupsNumber]] call AES_log;};
			
			_grp pushBack _cargoGrp;

			if (_vehType == "cargo chopper") then {
				[_marker,_grp,_counter] execVM "scripts\AES\functions\TransportUnload_fnc.sqf";
			};
			if (_vehType == "para chopper") then {
				[_marker,_grp,_counter,_unitData select 4] execVM "scripts\AES\functions\TransportParachute_fnc.sqf";
			};
		};
		_groups pushBack _grp;
	};
	sleep UNIT_SPAWN_WAIT_TIME;
};

_groups
/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/
