/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

//TransportUnload_fnc.sqf modificado para largar paracaidas
params ["_mkr","_veh","_counter","_PTAltSalto"];

private ["_pad","_getToMarker"];
private _mPos=getMarkerPos _mkr;
private _debug=false;
_veh params ["_vehicle","_nada","_grp","_cargoGrp"];

private _dir_atk= _mPos getDir _vehicle;
private _minDist = 200;
private _Place=(_minDist + random 200);
private _pos = [_mPos, _Place, _dir_atk] call BIS_fnc_relPos;
_pos = [ _pos select 0, _pos select 1, (_pos select 2) + _PTAltSalto];

if (_debug) then {[_mkr,_counter,"Lanzamiento Paracaidas", _pos] call EOS_debug;};

{_x allowFleeing 0} forEach units _grp;
{_x allowFleeing 0} forEach units _cargoGrp;

private _wp1 = _grp addWaypoint [_pos, 0];
_wp1 setWaypointSpeed "FULL";
_wp1 setWaypointType "MOVE";
_wp1 setWaypointStatements ["true", "[(vehicle this),150] execvm 'scripts\AES\functions\eject_paratrooper.sqf'"];

if (_debug) then {hint "Transport unloaded";};

[_cargoGrp,_mkr,"center"] call AES_setNewWaypoint;

_dir_atk=random 360;
_Place= 1300;
_newpos = [_Pos, _Place, _dir_atk] call BIS_fnc_relPos;
private _wp2 = _grp addWaypoint [_newpos, 0];
_wp2 setWaypointSpeed "FULL";
_wp2 setWaypointType "MOVE";
_wp2 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew (vehicle this) + [vehicle this];"];

units _grp doFollow leader _grp;

/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/