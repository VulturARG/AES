/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/

params ["_side","_debugLog","_marker","_waves"];

private ["_unconscious","_enemies"];

hint "Borro unidades wave: "+str _waves;

// Delete all unconscious IAs
	_unconscious = allUnits select {_x getVariable "ACE_isUnconscious" isEqualTo true && !isPlayer _x && (side _x == _side)};
	if (_debugLog) then {[[_marker,"Wave", _waves,"Inconscientes",count _unconscious,_side]] call ESA_log;};
	{
		_x setDamage 1;
	} forEach _unconscious;
	if (_debugLog) then {
		_unconscious = allUnits select {_x getVariable "ACE_isUnconscious" isEqualTo true && !isPlayer _x && (side _x == _side)};
		[[_marker,"Wave", _waves,"Inconscientes(Post)",count _unconscious,_side]] call ESA_log;
	};

	//Borro las unidades que estan a mas de una determinada distancia 
	_enemies = allUnits select {side _x == _side && _x iskindof "Man" && (_markerPos distance2D _x) > DELETE_DISTANCE}; 
	if (_debugLog) then {[[_marker,"Wave", _waves,"IAs>DELETE_DISTANCE",count _enemies,_side]] call ESA_log;};
	{ 
		if (!(isPlayer _x))then { 
			_x setDamage 1 
		} 
	}foreach _enemies;
	if (_debugLog) then {
		_enemies = allUnits select {side _x == _side && _x iskindof "Man" && (_markerPos distance2D _x) > DELETE_DISTANCE}; 
		[[_marker,"Wave", _waves,"IAs>DELETE_DISTANCE(Post)",count _enemies,_side]] call ESA_log;
	}

/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/