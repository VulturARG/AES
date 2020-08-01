/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/

_enemiesPosition = {
	params ["_marker","_spawnDistance","_angle"];

	private ["_place","_dir_atk","_position"];

	private _markerPos    = getMarkerPos _marker;
	private _mkrAngle     = markerDir _marker;
	getMarkerSize _marker params ["_mkrX","_mkrY"];

	_dir_atk  = _mkrAngle + (random _angle) - _angle/2;
	_place    = _mkrX + _spawnDistance + random 100;
	_position = [_markerPos, _place, _dir_atk] call BIS_fnc_relPos;

	_position
};

params ["_marker","_unitData","_angle","_vehType","_cargoType","_index","_side","_faction","_typeMessage"];

//format ["afuera %1 %2 %3",_marker,_unitData,_angle] call BIS_fnc_log;

private _groups       = [];
private _troupsNumber = 0;

//format ["%1",_unitData select 2] call BIS_fnc_log;

for "_counter" from 1 to (_unitData select 0) do {
	format ["_counter %1",_counter] call BIS_fnc_log;
	_position = [_marker,_unitData select 2,_angle] call _enemiesPosition;

    if (_index < 3) then {
        while {(surfaceiswater _position)} do {
            _position = [_marker,_unitData,_angle] call _enemiesPosition;
        };
    };
    
	if (_index == 0 || _index == 6) then {
        for "_counter" from 0 to 20 do {
            _newPosition = [_position,0,50,5,0,20,0] call BIS_fnc_findSafePos;
            if ((_position distance _newPosition) < 55) exitWith {
                _position = _newPosition;
            };
        };	
        _grp=[_position,_unitData select 1,_faction,_side] call EOS_fnc_spawngroup;
        _grp setGroupId [format ["%1 %2 %3-%4",_marker,_typeMessage,_waves,_counter]];
        _troupsNumber = _troupsNumber + count units _grp;
		_groups pushBack _grp;
    };
    /*    
	_bGroup=[_position,_side,_faction,_vehType]call EOS_fnc_spawnvehicle;

	if ((_LVgroupSize select 0) > 0) then{
		0=[(_bGroup select 0),_LVgroupSize,(_bGroup select 2),_faction,_cargoType] call eos_fnc_setcargo;
	};

	0 = [(_bGroup select 2),"LIGskill"] call eos_fnc_grouphandlers;
	(_bGroup select 2) setGroupId [format ["%1 LV %2-%3",_marker,_waves,_counter]];
	_troupsLV = _troupsLV + count units (_bGroup select 2);
	_groups set [count _groups,_bGroup];

	if (_debug) then {
		systemChat format ["Light Vehicle:%1 - r%2",_counter,_unitData select 0];
		0= [_marker,_counter,"Light Veh",(getpos leader (_bGroup select 2))] call EOS_debug;
	};
	*/
};
_groups
/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/
/*
_aGroup=[];
_troupsPA = 0;
for "_counter" from 1 to _PApatrols do {
	_dir_atk =_mkrAngle + (random _angle) - _angle/2;
	_Place=(_PAminDist + random 75);
	_pos = [_markerPos, _Place, _dir_atk] call BIS_fnc_relPos;
	while {(surfaceiswater _pos)} do {
		_dir_atk=_mkrAngle+(random _angle)-_angle/2;
		_pos = [_markerPos, _Place, _dir_atk] call BIS_fnc_relPos;
	};
	for "_counter" from 0 to 20 do {
		_position = [_pos,0,50,5,1,20,0] call BIS_fnc_findSafePos;
		if ((_pos distance _position) < 55)
			exitWith {
			_pos = _position;
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
*/