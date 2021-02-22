/*******************************************************************************
                            Realizado por |ArgA|MIV
*******************************************************************************/

if (getMissionConfigValue ["RECOLECTOR_BASURA",  1] == 0) exitWith {};

params ["_enemyUnit"];

private["_isMan","_waitTime","_coordX","_coordY","_coordZ","_waitTimeUnit"];

private _waitTimeMan     = getMissionConfigValue ["RB_TIEMPO_ESPERA_HOMBRES", 120];
private _waitTimeVehicle = getMissionConfigValue ["RB_TIEMPO_ESPERA_VEHICULOS", 0];
private _waitTimeArmor   = getMissionConfigValue ["RB_TIEMPO_ESPERA_BLINDADOS", 0];
private _waitTimeAir     = getMissionConfigValue ["RB_TIEMPO_ESPERA_AEREOS", 0];
private _minimunDistance = getMissionConfigValue ["RB_DISTANCIA_JUGADORES", 0];
private _enemyUnitType   = ["MAN","CAR","TANK","AIR"];
private _waitTimeArray   = [_waitTimeMan,_waitTimeVehicle,_waitTimeArmor,_waitTimeAir];
private _position        = GetPosAsl _enemyUnit;
private _deleteUnit      = false;

_position params ["_coordX","_coordY","_coordZ"];

_isMan = false;

{
	if (_enemyUnit isKindOf _x) exitWith {
		_waitTimeUnit = _waitTimeArray select _forEachIndex;
		if ((_waitTimeUnit) != 0) then {
			_waitTime   = _waitTimeUnit;
			_deleteUnit = true;
			if (_x == "MAN") then { _isMan = true };
		};
	};
} forEach _enemyUnitType;

if (_deleteUnit) then {
	waitUntil { (velocity _enemyUnit select 0) + (velocity _enemyUnit select 1) + (velocity _enemyUnit select 2) == 0 };

	if (_minimunDistance != 0 ) then {
		waitUntil {	count(allPlayers select {sleep 5; (_position distance _x) < _minimunDistance }) == 0 };
	};

	sleep _waitTime;

	if (_minimunDistance != 0 ) then {
		waitUntil {	count(allPlayers select {sleep 5; (_position distance _x) < _minimunDistance }) == 0 };
	};

	if (_isMan) then {
		_enemyUnit SetPosASL [_coordX, _coordY, 0];
		hidebody _enemyUnit;
	};

	deletevehicle _enemyUnit;
};

/*******************************************************************************
                            Realizado por |ArgA|MIV
*******************************************************************************/

//[_playersNear, count(_playersNear)] call MIV_fnc_log;