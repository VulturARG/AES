/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/

params ["_marker","_heightLimit","_multipleMarquerAlphaValue","_bastionMarquerAlphaValue","_enemyFaction"];

private ["_markerPos","_mkrAngle","_actCond"];

_markerPos = getMarkerPos _marker;
getMarkerSize _marker params ["_mkrX","_mkrY"];
_mkrAngle = markerDir _marker;

_Placement=(_mkrX + 500);

if ismultiplayer then {
	if (_heightLimit) then{
		_actCond="{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count playableunits > 0";
	} else	{
		_actCond="{vehicle _x in thisList && isplayer _x} count playableunits > 0";
	};
} else {
	if (_heightLimit) then {
		_actCond="{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count allUnits > 0";
	}else {
		_actCond="{vehicle _x in thisList && isplayer _x} count allUnits > 0";
	};
};

_basActivated = createTrigger ["EmptyDetector",_markerPos];
_basActivated setTriggerArea [_mkrX,_mkrY,_mkrAngle,false];
_basActivated setTriggerActivation ["ANY","PRESENT",true];
_basActivated setTriggerStatements [_actCond,"",""];

_marker setmarkercolor bastionColor;
_marker setmarkeralpha _multipleMarquerAlphaValue;

waituntil {triggeractivated _basActivated};
_marker setmarkercolor bastionColor;
_marker setmarkeralpha _bastionMarquerAlphaValue;

_bastActive = createTrigger ["EmptyDetector",_markerPos];
_bastActive setTriggerArea [_mkrX,_mkrY,_mkrAngle,false];
_bastActive setTriggerActivation ["any","PRESENT",true];
_bastActive setTriggerTimeout [1, 1, 1, true];
_bastActive setTriggerStatements [_actCond,"",""];

_bastClear = createTrigger ["EmptyDetector",_markerPos];
_bastClear setTriggerArea [(_mkrX+(_Placement*0.3)),(_mkrY+(_Placement*0.3)),_mkrAngle,false];
_bastClear setTriggerActivation [_enemyFaction,"NOT PRESENT",true];
_bastClear setTriggerStatements ["this","",""];

[_bastActive,_bastclear,_basActivated]

/*******************************************************************************
                            Modify by |ArgA|Vultur|Cbo¹
*******************************************************************************/