/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/

params ["_marker","_spawnDistance","_angle"];

private ["_place","_dir_atk","_position"];

private _markerPos    = getMarkerPos _marker;
private _mkrAngle     = markerDir _marker;

_dir_atk  = _mkrAngle + (random _angle) - _angle/2;
_place    = _spawnDistance + random 100;
_position = [_markerPos, _place, _dir_atk] call BIS_fnc_relPos;

_position

/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/