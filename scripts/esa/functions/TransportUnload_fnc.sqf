params ["_mkr","_veh","_counter"];

private ["_pad","_getToMarker","_cargoGrp","_vehicle"];
_mPos=getMarkerPos _mkr;

_debug=false;
_veh params ["_vehicle","_nada","_grp","_cargoGrp"];

//Modificado por Vultur
_dir_atk= _mPos getDir _vehicle;
_minDist = 200;
_Place=(_minDist + random 200);
_pos = [_mPos, _Place, _dir_atk] call BIS_fnc_relPos;
/////////////////////////////////////////////////////////////////////////////////

_pad = createVehicle ["Land_HelipadEmpty_F", _pos, [], 0, "NONE"];
if (_debug) then {0= [_mkr,_counter,"Unload Pad",(getpos _pad)] call EOS_debug;};

{_x allowFleeing 0} forEach units _grp;
{_x allowFleeing 0} forEach units _cargoGrp;

_wp1 = _grp addWaypoint [_pos, 0];
_wp1 setWaypointSpeed "FULL";
_wp1 setWaypointType "UNLOAD";
_wp1 setWaypointStatements ["true", "(vehicle this) LAND 'GET IN';"];

 waituntil {_vehicle distance _pad < 30};
_cargoGrp leaveVehicle _vehicle;

waitUntil{sleep 0.2; {_x in _vehicle} count units _cargoGrp == 0};
if (_debug) then {hint "Transport unloaded";};

[_cargoGrp,_mkr,"center","SAD","LIMITED","SAFE","COMBAT"] call FNC_newWaypoint;

_dir_atk=random 360;
_Place= 1300;
_newpos = [_Pos, _Place, _dir_atk] call BIS_fnc_relPos;
_wp2 = _grp addWaypoint [_newpos, 0];
_wp2 setWaypointSpeed "FULL";
_wp2 setWaypointType "MOVE";
_wp2 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew (vehicle this) + [vehicle this];"];

units _grp doFollow leader _grp;

deletevehicle _pad;
