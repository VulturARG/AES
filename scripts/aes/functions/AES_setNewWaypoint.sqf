/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/

params ["_group","_marker",["_destination","center"],["_wpType","SAD"],["_wpSpeed","LIMITED"],["_wpBehaviourVehicle","SAFE"],["_wpBehaviourUnit","AWARE"],["_wpFormation","NO CHANGE"],["_wpCombatMode","RED"]];
    
private ["_markerPosition","_mkrX","_mkrY","_markerSize","_position","_getToMarker"];

_markerPosition = markerpos _marker;
getMarkerSize _marker params ["_mkrX","_mkrY"];
_markerSize = 0;
_position = _markerPosition;

if (_destination=="random") then {
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
  
_getToMarker = _group addWaypoint [_position, 0];
_getToMarker setWaypointType _wpType;
_getToMarker setWaypointSpeed _wpSpeed;
if (vehicle (leader _group) != (leader _group)) then {
  _getToMarker setWaypointBehaviour _wpBehaviourVehicle;
} else {
  _getToMarker setWaypointBehaviour _wpBehaviourUnit;
};
_getToMarker setWaypointFormation _wpFormation;
_getToMarker setWaypointCombatMode _wpCombatMode;
_getToMarker