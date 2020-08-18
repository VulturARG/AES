params ["_vehicle","_grpSize","_grp","_faction","_cargoType"];

if (!isServer) exitWith {};
	
	private ["_cargoPool","_emptySeats","_debug"];

	_debug=false;

	_cargoPool=[_faction,_cargoType] call eos_fnc_getUnitPool;
	//_side=side (leader _grp);

//systemChat format ["%1, %2, %3, %4, %5", _vehicle, _grpSize, _grp, _faction, _cargoType];
//[format ["%1, %2, %3, %4, %5", _vehicle, _grpSize, _grp, _faction, _cargoType]]  call BIS_fnc_logFormat;


// FILL EMPTY SEATS
	_emptySeats=_vehicle emptyPositions "cargo";
	if (_debug) then {hint format ["%1",_emptySeats];};

//["CF _grpSize: %1",_grpSize] call BIS_fnc_logFormat;

//GET MIN MAX GROUP
	_grpSize params["_grpMin","_grpMax"];
	_difference = _grpMax-_grpMin;
	_randomDifference = floor(random _difference);
	_grpSize = _randomDifference + _grpMin;

// IF VEHICLE HAS SEATS
	if (_emptySeats > 0) then {

		// LIMIT SEATS TO FILL TO GROUP SIZE
		if 	(_grpSize > _emptySeats) then {_grpSize = _emptySeats};
		if (_debug) then {hint format ["Seats Filled : %1",_grpSize];};

		for "_x" from 1 to _grpSize do {
			_unit=_cargoPool select (floor(random(count _cargoPool)));
			_unit=_unit createUnit [GETPOS _vehicle, _grp];
		};

		{
			_x moveInCargo _vehicle
		}foreach units _grp;
	};
