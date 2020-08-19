/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/

params ["_spawnGroup","_unitData","_marker"];

private ["_markerPosition","_mkrX","_mkrY","_markerSize","_position","_unitType","_kindOfTroop","_dir_atk","_getToMarker","_group"];
private ["_cargo","_wpRoute","_wpParameters"];

// format ["WP _spawnGroup: %1",_spawnGroup] call BIS_fnc_log;
// format ["WP _unitData: %1",_unitData] call BIS_fnc_log;
format ["WP _marker: %1",_marker] call BIS_fnc_log;
//format ["WP typeName marker: %1",typeName _marker] call BIS_fnc_log;


_unitType     = AES_WAYPOINT_TYPE select {(_x select 0) == (_unitData select 0) } select 0;
_unitType     = if (isNil "_unitType") then {[]} else {_unitType};
_kindOfTroop  = _unitType select 0;
_wpParameters = _unitType select 1;

//format ["WP _wpParameters: %1",_wpParameters] call BIS_fnc_log;
//format ['WP _kindOfTroop: %1',typeName _kindOfTroop]  call BIS_fnc_log;

_markerPosition = markerpos _marker;
getMarkerSize _marker params ["_mkrX","_mkrY"];
_markerSize = 0;
_position = _markerPosition;

//format ["WP Tipo: %1 _spawnGroup: %2",_unitData select 0,_spawnGroup] call BIS_fnc_log;

_dir_atk = 0;

{
	//format ["WP _x: %1",_x] call BIS_fnc_log;
	
	_group   = if (count(_x) > 2) then { _x select 2 } else {_x select 0};
	_cargo   = if (count(_x) > 3) then { _x select 3 } else { [] };
	_wpRoute = [];
	{
		//format ["WP _group _x: %1",_group] call BIS_fnc_log;
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
		if ((_kindOfTroop == "light vehicle" || _kindOfTroop == "armor") && _forEachIndex == 0) then {
			_dir_atk= _markerPosition getDir (leader _group);
			_position = [_markerPosition, (_mkrX + random 100), _dir_atk] call BIS_fnc_relPos;
		};
		if (_kindOfTroop == "light vehicle" && _forEachIndex == 1) then {
			_position = [_markerPosition, 150, _dir_atk] call BIS_fnc_relPos;
		};
		_getToMarker = _group addWaypoint [_position, 0];
		_getToMarker setWaypointType (_x select 1);
		_getToMarker setWaypointSpeed (_x select 2);
		_getToMarker setWaypointBehaviour (_x select 3);
		_getToMarker setWaypointFormation (_x select 4);
		_getToMarker setWaypointCompletionRadius (_x select 5);
		_getToMarker setWaypointCombatMode (_x select 6);
		/*if (count(_x) > 7) then {
			//_group setVariable ["EOS_GROUP_CARGO", _cargo];
			_unitCommand = format["[[thisList-[this]],['patrol',1],%2] call compile preprocessFileLineNumbers 'scripts\AES\functions\AES_setNewWaypoint.sqf'",_marker]; 
			//_unitCommand = "hint str(this getVariable 'EOS_GROUP_CARGO')";
			//_unitCommand = "hint format['%1 %2 %3',this, thisList,thisList-[this]]";
			_getToMarker setWaypointStatements ["true", _unitCommand];
			format ["WP _unitCommand: %1",_unitCommand] call BIS_fnc_log;
		};// */
		_wpRoute pushBack _getToMarker;
		//format ["WP Tipo: %1 _wpRoute: %2",_unitData select 0,_wpRoute] call BIS_fnc_log;
	} forEach (_wpParameters);
	if (count(_x) > 3) then {
		[[[_x select 3]],["patrol",1],_marker] call AES_setWaypoint;
	};
	units _group doFollow leader _group;
} forEach _spawnGroup;
	
/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/
