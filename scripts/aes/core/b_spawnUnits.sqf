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
private _troupsNumber = 0;
private _position     = [];

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
	if (_vehType == "light vehicle" ) then {
        
		_grp = [_position,_vehType,_faction,_side]call EOS_fnc_spawnvehicle;

		0 = [(_grp select 0),unitData select 3,(_grp select 2),_faction,_cargoType] call eos_fnc_setcargo;

		0 = [(_grp select 2),"LIGskill"] call eos_fnc_grouphandlers;
		(_grp select 2) setGroupId [format ["%1 LV %2-%3",_marker,_waves,_counter]];
		_troupsNumber = _troupsNumber + count units (_grp select 2);
		_groups set [count _groups,_grp];

		/*if (_debug) then {
			systemChat format ["Light Vehicle:%1 - r%2",_counter,_unitData select 0];
			0= [_marker,_counter,"Light Veh",(getpos leader (_grp select 2))] call EOS_debug;
		};*/
	}
};
_groups
/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/
// SPAWN HALO (New)
/*
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
	[[_marker,"Wave",_waves,"Total_Tropas_HALO",_troupsHA,_side]] call AES_log;
	[[_marker,"Wave",_waves,"Total_Tropas_Desplegadas",_troupsPA+_troupsLV+_troupsAV+_troupsHT+_troupsPT+_troupsHA,_side]] call AES_log;
};
// */