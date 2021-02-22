/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

params ["_typeMission","_JIPmkr","_unitsArrays","_settings",["_basSettings",[]],["_angle",360]];

private _isJump   = false;
private _jumpType = [];
private _typeUnit = "";

//'launch' call BIS_fnc_log;

if (!isServer) exitWith {};

//format ['%1',_unitsArrays]  call BIS_fnc_log;

{
	if (_typeMission isEqualTo "playerDefend") then {
		_typeUnit = toLower(_x select 0);
		if (count(_x) < 2) then { 
			_defaultDistance = AES_DEFAULT_MINIMUM_DISTANCE select {(_x select 0) == _typeUnit} select 0 select 1;
			_defaultDistance = if (isNil "_defaultDistance") then {500} else {_defaultDistance};
			_x append [_defaultDistance];
			_x append [1];
		};
		_jumpType = AES_DEFAULT_JUMP_PARA select {(_x select 0) == _typeUnit} select 0;
		_jumpType = if (isNil "_jumpType") then {_isJump = false;[]} else {_isJump = true;_jumpType};
		if (count(_x) < 5 && _isJump) then {
				_x append [_jumpType select 1]; 
		};
	};

	if (count(_x) >= 4 && count(AES_MIN_MAX_SIZE_GROUP) > _x select 3) then {
		//format ['%1',_x select 3]  call BIS_fnc_log;
		_x set [3,AES_MIN_MAX_SIZE_GROUP select (_x select 3)];
	};
	
} forEach _unitsArrays;
	//format ['%1',_unitsArrays]  call BIS_fnc_log;

{
	_eosMarkers=server getvariable "EOSmarkers";
	if (isnil "_eosMarkers") then {_eosMarkers=[];};
	_eosMarkers set [count _eosMarkers,_x];
	server setvariable ["EOSmarkers",_eosMarkers,true];
	_typeMission = format["scripts\AES\core\%1.sqf",_typeMission];
	null = [_x,_unitsArrays,_settings,_basSettings,_angle] execVM _typeMission;
} foreach _JIPmkr;

/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/
//format ['%1',_unitsArrays]  call BIS_fnc_log;
// */

