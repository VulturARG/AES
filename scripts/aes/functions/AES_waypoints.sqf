/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/

params ["_spawnGroup","_unitData","_marker"];

private ["_markerPosition","_mkrX","_mkrY","_markerSize","_position","_getToMarker","_unitType","_kindOfTroop","_dir_atk"];

_unitType = AES_WAYPOINT_TYPE select {(_x select 0) == (_unitData select 0) } select 0;
_unitType = if (isNil "_unitType") then {[]} else {_unitType};
_kindOfTroop = _unitType select 0;

//format ["WP _spawnGroup: %1",_spawnGroup] call BIS_fnc_log;
//format ["WP _unitType: %1",_unitType select 1] call BIS_fnc_log;
format ['WP _kindOfTroop: %1',typeName _kindOfTroop]  call BIS_fnc_log;

_markerPosition = markerpos _marker;
getMarkerSize _marker params ["_mkrX","_mkrY"];
_markerSize = 0;
_position = _markerPosition;

{
	format ["WP _spawnGroup _x: %1",_x] call BIS_fnc_log;
	_dir_atk = 0;
	_unit = _x select 2;
	{
		format ["WP unitType select 1 _x: %1",_x] call BIS_fnc_log;
		if (_x select 0 == "random") then {
			if (_mkrX > _mkrY) then {
				_markerSize = _mkrY;
			} else {
				_markerSize = _mkrX;
			};
			_position = [_markerPosition, random _markerSize, random 360] call BIS_fnc_relPos;
			while {(surfaceiswater _position)} do {
				_position = [_markerPosition, random _markerSize, random 360] call BIS_fnc_relPos;
			};
		};
		if (_kindOfTroop == "light vehicle" && _forEachIndex == 0) then {
			_dir_atk= _markerPosition getDir (_unit);
			_position = [_markerPosition, (_mkrX + random 100), _dir_atk] call BIS_fnc_relPos;
		};
		if (_kindOfTroop == "light vehicle" && _forEachIndex == 1) then {
			_position = [_markerPosition, 150, _dir_atk] call BIS_fnc_relPos;
		};
		_getToMarker = _unit addWaypoint [_position, 0];
		_getToMarker setWaypointType (_x select 1);
		_getToMarker setWaypointSpeed (_x select 2);
		_getToMarker setWaypointBehaviour (_x select 3);
		_getToMarker setWaypointFormation (_x select 4);
		_getToMarker setWaypointCompletionRadius (_x select 5);
		_getToMarker setWaypointCombatMode (_x select 6);	
	} forEach (_unitType select 1);
} forEach _spawnGroup;


/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/