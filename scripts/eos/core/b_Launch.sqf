params ["_JIPmkr","_infantry","_LVeh","_AVeh","_SVeh","_PTrooper","_HAtrooper","_settings","_basSettings","_angle"];
//systemChat format["%1",_JIPmkr];
if (isServer) then {
	private ["_PAgroupArray","_LVgroupArray","_CHgroupArray","_PTgroupArray","_HAgroupArray"];

	_infantry params["_PApatrols","_PAgroupSize",["_PAminDist",500]];
	_LVeh params["_LVehGroups","_LVgroupSize",["_LVminDist",800]];
	_AVeh params["_AVehGroups",["_AVminDist",800]];
	_SVeh params["_CHGroups","_CHgroupSize",["_CHminDist",1400]];
	_PTrooper params["_PTGroups","_PTgroupSize",["_PTminDist",1400],["_PTAltSalto",400]];
	_HAtrooper params["_HAGroups","_HAgroupSize",["_HAminDist",200],["_HAAltSalto",600]];

	if (_PAgroupSize==0) then {_PAgroupArray=[1,1]};
	if (_PAgroupSize==1) then {_PAgroupArray=[2,4]};
	if (_PAgroupSize==2) then {_PAgroupArray=[4,8]};
	if (_PAgroupSize==3) then {_PAgroupArray=[8,12]};
	if (_PAgroupSize==4) then {_PAgroupArray=[12,16]};
	if (_PAgroupSize==5) then {_PAgroupArray=[16,20]};

	if (_LVgroupSize==0) then {_LVgroupArray=[1,1]};
	if (_LVgroupSize==1) then {_LVgroupArray=[2,4]};
	if (_LVgroupSize==2) then {_LVgroupArray=[4,8]};
	if (_LVgroupSize==3) then {_LVgroupArray=[8,12]};
	if (_LVgroupSize==4) then {_LVgroupArray=[12,16]};
	if (_LVgroupSize==5) then {_LVgroupArray=[16,20]};

	if (_CHgroupSize==0) then {_CHgroupArray=[0,0]};
	if (_CHgroupSize==1) then {_CHgroupArray=[2,4]};
	if (_CHgroupSize==2) then {_CHgroupArray=[4,8]};
	if (_CHgroupSize==3) then {_CHgroupArray=[8,12]};
	if (_CHgroupSize==4) then {_CHgroupArray=[12,16]};
	if (_CHgroupSize==5) then {_CHgroupArray=[16,20]};

	if (_PTgroupSize==0) then {_PTgroupArray=[1,1]};
	if (_PTgroupSize==1) then {_PTgroupArray=[2,4]};
	if (_PTgroupSize==2) then {_PTgroupArray=[4,8]};
	if (_PTgroupSize==3) then {_PTgroupArray=[8,12]};
	if (_PTgroupSize==4) then {_PTgroupArray=[12,16]};
	if (_PTgroupSize==5) then {_PTgroupArray=[16,20]};

	if (_HAgroupSize==0) then {_HAgroupArray=[1,1]};
	if (_HAgroupSize==1) then {_HAgroupArray=[2,4]};
	if (_HAgroupSize==2) then {_HAgroupArray=[4,8]};
	if (_HAgroupSize==3) then {_HAgroupArray=[8,12]};
	if (_HAgroupSize==4) then {_HAgroupArray=[12,16]};
	if (_HAgroupSize==5) then {_HAgroupArray=[16,20]};
	{
		_eosMarkers=server getvariable "EOSmarkers";
		if (isnil "_eosMarkers") then {_eosMarkers=[];};
		_eosMarkers set [count _eosMarkers,_x];
		server setvariable ["EOSmarkers",_eosMarkers,true];
		null = [_x,[_PApatrols,_PAgroupArray,_PAminDist],[_LVehGroups,_LVgroupArray,_LVminDist],[_AVehGroups,_AVminDist],[_CHGroups,_CHgroupArray,_CHminDist],[_PTGroups,_PTgroupArray,_PTminDist,_PTAltSalto],[_HAGroups,_HAgroupArray,_HAminDist,_HAAltSalto],_settings,_basSettings,_angle] execVM "scripts\eos\core\b_core.sqf";
	}foreach _JIPmkr;

};
