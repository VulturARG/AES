/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

params ["_typeMission","_JIPmkr","_unitsArrays","_settings",["_basSettings",[]],["_angle",360]];

private _defaultMinDistance = [
	["patrol",DEFAULT_INFANTERY_MIN_DIST],
	["light vehicles",DEFAULT_VEHICLES_MIN_DIST],
	["armor",DEFAULT_ARMOR_MIN_DIST],
	["attack helo",DEFAULT_ATTACK_CHOPPER_MIN_DIST],
	["cargo helo",DEFAULT_CHOPPER_MIN_DIST],
	["para helo",DEFAULT_CHOPPER_JUMP_MIN_DIST],
	["halo",DEFAULT_HALO_MIN_DIST]];

private _defaultJumpHeight = [["para helo",DEFAULT_CHOPPER_JUMP_HEIGHT],["halo",DEFAULT_HALO_JUMP_HEIGHT]];
private _groupArray        = [[1,1],[2,4],[4,8],[8,12],[12,16],[16,20]];
private _isJump            = false;
private _jumpType          = [];
private _typeUnit          = "";

if (isServer) then {
	format ['%1',_unitsArrays]  call BIS_fnc_log;
	{
		_typeUnit = toLower(_x select 0);
		if (count(_x) < 2) then { 
			_defaultDistance = _defaultMinDistance select {(_x select 0) == _typeUnit} select 0 select 1;
			_defaultDistance = if (isNil "_defaultDistance") then {500} else {_defaultDistance};
			_x append [_defaultDistance];
			_x append [1];
		};
		_jumpType = _defaultJumpHeight select {(_x select 0) == _typeUnit} select 0;
		_jumpType = if (isNil "_jumpType") then {_isJump = false;[]} else {_isJump = true;_jumpType};
		if (count(_x) < 4 && _isJump) then {
			 _x append [_jumpType select 1]; 
		};
		_x set [1,_groupArray select (_x select 1)];
	} forEach _unitsArrays;

	{
		_eosMarkers=server getvariable "EOSmarkers";
		if (isnil "_eosMarkers") then {_eosMarkers=[];};
		_eosMarkers set [count _eosMarkers,_x];
		server setvariable ["EOSmarkers",_eosMarkers,true];
		_typeMission = format["scripts\AES\core\%1.sqf",_typeMission];
		null = [_x,_unitsArrays,_settings,_basSettings,_angle] execVM _typeMission;
	}foreach _JIPmkr;

};

/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/
//format ['%1',_unitsArrays]  call BIS_fnc_log;

