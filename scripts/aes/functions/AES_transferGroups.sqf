/*******************************************************************************
                             Realizado por |ArgA|Vultur|Sgt
*******************************************************************************/

params["_group"];

private _dataHC = call compile preprocessFileLineNumbers 'scripts\aes\functions\AES_getHCSmalledUnits.sqf';

if (_dataHC select 1 != 11111) then {
	_group setGroupOwner (owner (_dataHC select 2));
};

/*******************************************************************************
                             Realizado por |ArgA|Vultur|Sgt
*******************************************************************************/