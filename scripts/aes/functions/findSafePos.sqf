params ["_mrk","_radveh"];

_pos = [_mkr,true] call SHK_pos;
// TODO Maff modificacion
//_pos = [[_mkr],[]] call BIS_fnc_randomPos; //	Maff.

for "_counter" from 0 to 20 do {
_newpos = [_pos,0,_radveh,5,1,20,0] call BIS_fnc_findSafePos;
	if ((_pos distance _newpos) < (_radveh + 5))
		exitWith {
		_pos = _newpos;
	};
};
_newpos
