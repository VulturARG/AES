/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/

params ["_strData"];
_strData = _this;

hint "AES Log";

private _data = "";

if (typeName _strData != "ARRAY") then {
	_strData = [_strData];
};

_strData = _strData apply {
						if (isNil "_x") then {
							"isNil";
						} else {
							if (typeName _x != "STRING") then { str _x } else { _x };
						};
					};

{
	_data = _data + " " + _x;
} forEach _strData;

_data call BIS_fnc_log;

/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/