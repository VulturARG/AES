params ["_position","_side","_faction","_type",["_special","CAN_COLLIDE"]];
//systemchat format ["_newpos: %1, _side: %2, _faction: %3, _vehType: %4",_position,_side,_faction,_type];

private ["_vehicleType","_grp","_vehPositions","_vehicle","_vehCrew"];
_vehicleType=[_faction,_type] call eos_fnc_getunitpool;
//systemchat format ["_vehicleType: %1, _faction: %2, _vehType: %3",_vehicleType,_faction,_type];
_grp = createGroup _side;
_vehPositions=[(_vehicleType select 0)] call BIS_fnc_vehicleRoles;
_vehicle = createVehicle [(_vehicleType select 0), _position, [], 0, _special];
_vehCrew=[];

{
	//["_currentPosition: %1",_x] call BIS_fnc_logFormat;
	_currentPosition=_x;
	if (_currentPosition select 0 == "driver")then {
		_unit = _grp createUnit [(_vehicleType select 1), _position, [], 0, "CAN_COLLIDE"];
		_unit assignAsDriver _vehicle;
		_unit moveInDriver _vehicle;
		_vehCrew set [count _vehCrew,_unit];
	};

	//["_vehicleType %1, _estado: %2",_vehicleType,_estado] call BIS_fnc_logFormat;
	if (_currentPosition select 0 == "turret") then {
		_compara1 = 1; _compara2 = 1;
		switch (_vehicleType select 0) do {
			case "rhs_btr60_msv": { _compara1 = 2; _compara2 = 1; };
		  //case 2: { hint "2" };
		  //default { _compara1 = 1; _compara2 = 2; };
		};
		//PLAYER SIDECHAT (format ["_compara2: %1",_compara2]);
		_largo = count (_currentPosition select 1);
		_estado = false;
		if (_largo == 1) then {
			_posicion = (_currentPosition select 1) select 0;
			if (_posicion < _compara1) then { _estado = true};
		} else {
			_posicion = (_currentPosition select 1) select 1;
			if (_posicion < _compara2) then { _estado = true};
		};
		if (_estado) then {//*/
			_unit = _grp createUnit [(_vehicleType select 1), _position, [], 0, "CAN_COLLIDE"];
			_unit assignAsGunner _vehicle;
			_unit MoveInTurret [_vehicle,_currentPosition select 1];
			_vehCrew set [count _vehCrew,_unit];
		};
	};
}foreach _vehPositions;

_return=[_vehicle,_vehCrew,_grp];

_return
