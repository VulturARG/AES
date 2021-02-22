/*******************************************************************************
                          Realizado por |ArgA|Vultur|Cbo¹
*******************************************************************************/
params [["_nuevosWP",""],["_redirigidos",["",0,""]],["_lado",EAST]];

private _todos = allGroups select {side _x isEqualTo _lado};//returns all groups of _lado
private _coincidentes = [];
private _listaApoyo = [];
private _remanentes = [];

{
  _x params["_marker","_porcentaje","_secundarioWP"];
  _escuadronIA = _todos select {[_marker, groupId _x] call BIS_fnc_inString};
  _nroEscuadrones = count _escuadronIA;
  _escRedirigidos = round (_nroEscuadrones * _porcentaje / 100);
  _coincidentes set [count _coincidentes,_escuadronIA];
  {
      _listaApoyo set [count _listaApoyo,_x]; //Guardo una lista con todas las unidades que coinciden con los _redirigidos
      if (_forEachIndex < _escRedirigidos) then {
        for "_i" from count waypoints _x - 1 to 0 step -1 do{
          deleteWaypoint [_x, _i];
        };
        /*{
          doStop _x;
        }forEach units _x;*/
        _azarMarker = _nuevosWP call BIS_fnc_selectRandom;
        [_x,_azarMarker,"random"] call AES_fnc_setNewWaypoint;
        //units _x doFollow leader _x;
      }else{
        if (count _secundarioWP > 0) then {
          //[format ["count _secundarioWP: %1",count _secundarioWP]] call BIS_fnc_logFormat;
          [_x,_secundarioWP,"random"] call AES_fnc_setNewWaypoint;
        };
      };
  } forEach _escuadronIA; // */
}forEach _redirigidos;

// Borro los wp de las unidades libres y los redirijo
_remanentes = _todos - _listaApoyo;
{
  for "_i" from count waypoints _x - 1 to 0 step -1 do{
    deleteWaypoint [_x, _i];
  };
  /*{
    doStop _x;
  }forEach units _x;
  */
  _azarMarker = _nuevosWP call BIS_fnc_selectRandom;
  [_x,_azarMarker,"random"] call AES_fnc_setNewWaypoint;
  //units _x doFollow leader _x;
}forEach _remanentes;

/*
[format ["_todos: %1", _todos]] call BIS_fnc_logFormat;
[format ["_listaApoyo: %1", _listaApoyo]] call BIS_fnc_logFormat;
[format ["_coincidentes: %1", _coincidentes]] call BIS_fnc_logFormat;
[format ["_remanentes: %1",_remanentes]] call BIS_fnc_logFormat;

// */
