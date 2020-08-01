/*******************************************************************************
                          Realizado por |ArgA|Vultur|Cbo¹
*******************************************************************************/
params ["_group","_marker",["_destination","center"],["_wpType","SAD"],["_wpSpeed","LIMITED"],["_wpBehaviourVehicle","SAFE"],["_wpBehaviourUnit","AWARE"],["_wpFormation","NO CHANGE"],["_wpCombatMode","RED"]];
    
  private ["_mPos","_mkrX","_mkrY","_mkrSize","_pos","_getToMarker"];
  
  _mPos = markerpos _marker;
  getMarkerSize _marker params ["_mkrX","_mkrY"];
  _mkrSize = 0;
	_pos = _mPos;
	if (_destination=="random") then {
		if (_mkrX > _mkrY) then {
			_mkrSize = _mkrY;
		} else {
			_mkrSize = _mkrX;
		};
		_pos = [_mPos, random _mkrSize, random 360] call BIS_fnc_relPos;
		while {(surfaceiswater _pos)} do {
			_pos = [_mPos, random _mkrSize, random 360] call BIS_fnc_relPos;
		};
	};
    
  _getToMarker = _group addWaypoint [_pos, 0];
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