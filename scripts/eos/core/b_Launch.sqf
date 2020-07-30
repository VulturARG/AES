/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

params ["_JIPmkr","_unitsArrays","_settings","_basSettings","_angle"];

private _defaultMinDistance = [DEFAULT_INFANTERY_MIN_DIST,DEFAULT_VEHICLES_MIN_DIST,DEFAULT_ARMOR_MIN_DIST,DEFAULT_ATTACK_CHOPPER_MIN_DIST,DEFAULT_CHOPPER_MIN_DIST,DEFAULT_CHOPPER_JUMP_MIN_DIST,DEFAULT_HALO_MIN_DIST];
private _defaultJumpHeight  = [DEFAULT_CHOPPER_JUMP_HEIGHT,DEFAULT_HALO_JUMP_HEIGHT];
private _groupArray=[[1,1],[2,4],[4,8],[8,12],[12,16],[16,20]];

if (isServer) then {
	{
		if (count(_x) < 3) then { _x append [_defaultMinDistance select _forEachIndex]; };
		if (count(_x) < 4 && _forEachIndex > 4) then { _x append [_defaultJumpHeight select (_forEachIndex-5)]; };
		_x set [1,_groupArray select (_x select 1)];
	} forEach _unitsArrays;

	{
		_eosMarkers=server getvariable "EOSmarkers";
		if (isnil "_eosMarkers") then {_eosMarkers=[];};
		_eosMarkers set [count _eosMarkers,_x];
		server setvariable ["EOSmarkers",_eosMarkers,true];
		null = [_x,_unitsArrays,_settings,_basSettings,_angle] execVM "scripts\eos\core\b_core.sqf";
	}foreach _JIPmkr;

};

/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/
//format ['%1',_unitsArrays]  call BIS_fnc_log;
