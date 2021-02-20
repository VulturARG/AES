params["_grp","_skillArray"];

_skillset = server getvariable _skillArray;
{
	_unit = _x;
	{
		//_skillvalue = (_skillset select _forEachIndex) + (random 0.2) - (random 0.2);
		_skillvalue = _skillset  select _forEachIndex;
		_unit setSkill [_x,_skillvalue];
	} forEach ['aimingAccuracy','aimingShake','aimingSpeed','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];

	if (AES_DAMAGE_MULTIPLIER != 1) then {
		_unit removeAllEventHandlers "HandleDamage";
		_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*AES_DAMAGE_MULTIPLIER;_damage}];
	};
	if (AES_KILLCOUNTER) then {
		_unit addEventHandler ["killed", "null=[] execVM ""eos\functions\AES_KILLCOUNTER.sqf"""]
	};
	// ADD CUSTOM SCRIPTS TO UNIT HERE
} forEach (units _grp);
