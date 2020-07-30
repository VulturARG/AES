params ["_mkr","_HouseInfantry","_infantry","_LVeh","_vehicles","_settings",["_cache",false]];
if (!isServer) exitWith {};
private ["_newpos","_cargoType","_vehType","_dGrp","_mkrAgl","_bGroup","_civZone","_bGrp",
		 "_eGrp","_fGrp","_aMin","_aGrp","_bMin","_units","_trig","_cache","_grp","_crew",
		 "_vehicle","_actCond","_mAN","_mAH","_mA","_cGrp","_taken","_clear","_enemyFaction",
		 "_n","_eosAct","_eosActivated","_mPos","_mkrX","_mkrY"
		];

_HouseInfantry params["_aGrps","_aSize"];
_infantry params["_bGrps","_bSize"];
_LVeh params["_cGrps","_cSize"];
_vehicles params["_dGrps","_eGrps","_fGrps","_fSize"];
_settings params["_faction","_mA","_distance","_side",["_heightLimit",false],["_debug",false]];

_mPos=markerpos _mkr;
getMarkerSize _mkr params ["_mkrX","_mkrY"];
_mkrAgl=markerDir _mkr;

_aMin=_aSize select 0;
_bMin=_bSize select 0;

if (_side==EAST) then {_enemyFaction="east";_civZone=false;};
if (_side==WEST) then {_enemyFaction="west";_civZone=false;};
if (_side==INDEPENDENT) then {_enemyFaction="GUER";_civZone=false;};
if (_side==CIVILIAN) then {_enemyFaction="civ";_civZone=true;};

if (_mA==0) then {_mAH = 1;_mAN = 0.5;};
if (_mA==1) then {_mAH = 0;_mAN = 0;};
if (_mA==2) then {_mAH = 0.5;_mAN = 0.5;};

// INITIATE ZONE
_trig=format ["EOSTrigger%1",_mkr];

if (!_cache) then {
    if ismultiplayer then {
        if (_heightLimit) then {
            _actCond = "{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count playableunits > 0";
        } else {
            _actCond = "{vehicle _x in thisList && isplayer _x} count playableunits > 0";
        };
    } else {
        if (_heightLimit) then {
            _actCond = "{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count allUnits > 0";
        } else {
            _actCond = "{vehicle _x in thisList && isplayer _x} count allUnits > 0";
        };
    };

    _eosActivated = createTrigger["EmptyDetector", _mPos];
    _eosActivated setTriggerArea[(_distance + _mkrX), (_distance + _mkrY), _mkrAgl, FALSE];
    _eosActivated setTriggerActivation["ANY", "PRESENT", true];
    _eosActivated setTriggerTimeout[1, 1, 1, true];
    _eosActivated setTriggerStatements[_actCond, "", ""];

    server setvariable[_trig, _eosActivated];
} else {
    _eosActivated = server getvariable _trig;
};

_mkr setmarkerAlpha _mAN;
if (!(getmarkercolor _mkr == VictoryColor)) then { //IF MARKER IS GREEN DO NOT CHANGE COLOUR
    _mkr setmarkercolor hostileColor;
};

waituntil {
    triggeractivated _eosActivated
}; //WAIT UNTIL PLAYERS IN ZONE
if (!(getmarkercolor _mkr == "colorblack")) then {
    if (!(getmarkercolor _mkr == VictoryColor)) then {
        _mkr setmarkerAlpha _mAH;
    };

    // SPAWN HOUSE PATROLS
    for "_counter"
    from 1 to _aGrps do {
        if (isnil "_aGrp") then {
            _aGrp = [];
        };
        if (_cache) then {
            _cacheGrp = format["HP%1", _counter];
            _units = _eosActivated getvariable _cacheGrp;
            _aSize = [_units, _units];
            _aMin = _aSize select 0;
            if (_debug) then {
                player sidechat format["ID:%1,restore - %2", _cacheGrp, _units];
            };
        };
        if (_aMin > 0) then {
            _aGroup = [_mPos, _aSize, _faction, _side] call EOS_fnc_spawngroup;
            if (!surfaceiswater _mPos) then {
                0 = [_mPos, units _aGroup, _mkrX, 0, [0, 20], true, true] call shk_fnc_fillhouse;
            } else {
                0 = [_aGroup, _mkr] call EOS_fnc_taskpatrol;
            };
            _aGroup setGroupId[format["%1 HP %2", _mkr, _counter]];
            _aGrp set[count _aGrp, _aGroup];
            0 = [_aGroup, "INFskill"] call eos_fnc_grouphandlers;
            if (_debug) then {
                PLAYER SIDECHAT(format["Spawned House Patrol: %1", _counter]);
                0 = [_mkr, _counter, "House Patrol", getpos(leader _aGroup)] call EOS_debug
            };
        };
    };

    // SPAWN PATROLS
    for "_counter"
    from 1 to _bGrps do {
        if (isnil "_bGrp") then {
            _bGrp = [];
        };
        if (_cache) then {
            _cacheGrp = format["PA%1", _counter];
            _units = _eosActivated getvariable _cacheGrp;
            _bSize = [_units, _units];
            _bMin = _bSize select 0;
            if (_debug) then {
                player sidechat format["ID:%1,restore - %2", _cacheGrp, _units];
            };
        };
        if (_bMin > 0) then {
            _pos = [_mkr, true] call SHK_pos;
            //_pos = [[_mkr], []] call BIS_fnc_randomPos;	//	maff.
            _bGroup = [_pos, _bSize, _faction, _side] call EOS_fnc_spawngroup;
            0 = [_bGroup, _mkr] call EOS_fnc_taskpatrol;
            _bGroup setGroupId[format["%1 MP %2", _mkr, _counter]]; //MP Mobil Patrol
            _bGrp set[count _bGrp, _bGroup];

            0 = [_bGroup, "INFskill"] call eos_fnc_grouphandlers;
            if (_debug) then {
                PLAYER SIDECHAT(format["Spawned Patrol: %1", _counter]);
                0 = [_mkr, _counter, "patrol", getpos(leader _bGroup)] call EOS_debug
            };
        };
    };

    //SPAWN LIGHT VEHICLES
    for "_counter"
    from 1 to _cGrps do {
        if (isnil "_cGrp") then {
            _cGrp = [];
        };

        _newpos = [_mkr, 50] call EOS_fnc_findSafePos;
        if (surfaceiswater _newpos) then {
            _vehType = 8;
            _cargoType = 10;
        } else {
            _vehType = 7;
            _cargoType = 9;
        };

        _cGroup = [_newpos, _side, _faction, _vehType] call EOS_fnc_spawnvehicle;
        if ((_cSize select 0) > 0) then {
            0 = [(_cGroup select 0), _cSize, (_cGroup select 2), _faction, _cargoType] call eos_fnc_setcargo;
        };

        0 = [(_cGroup select 2), "LIGskill"] call eos_fnc_grouphandlers;
        0 = [(_cGroup select 2), _mkr] call EOS_fnc_taskpatrol;
		[format ["_cGroup: %1", _cGroup]] call BIS_fnc_logFormat;
        (_cGroup select 2) setGroupId[format["%1 LV %2", _mkr, _counter]]; //LV Light vehicles
        _cGrp set[count _cGrp, _cGroup];

        if (_debug) then {
            player sidechat format["Light Vehicle:%1 - r%2", _counter, _cGrps];
            0 = [_mkr, _counter, "Light Veh", (getpos leader(_cGroup select 2))] call EOS_debug
        };
    };

    //SPAWN ARMOURED VEHICLES
    for "_counter"
    from 1 to _dGrps do {
        if (isnil "_dGrp") then {
            _dGrp = [];
        };

        _newpos = [_mkr, 50] call EOS_fnc_findSafePos;
        if (surfaceiswater _newpos) then {
            _vehType = 8;
        } else {
            _vehType = 2;
        };

        _dGroup = [_newpos, _side, _faction, _vehType] call EOS_fnc_spawnvehicle;

        0 = [(_dGroup select 2), "ARMskill"] call eos_fnc_grouphandlers;
        0 = [(_dGroup select 2), _mkr] call EOS_fnc_taskpatrol;
        (_dGroup select 2) setGroupId[format["%1 AV %2", _mkr, _counter]]; //AV Armoured vehicles
        _dGrp set[count _dGrp, _dGroup];

        if (_debug) then {
            player sidechat format["Armoured:%1 - r%2", _counter, _dGrps];
            0 = [_mkr, _counter, "Armour", (getpos leader(_dGroup select 2))] call EOS_debug
        };
    };

    //SPAWN STATIC PLACEMENTS
    for "_counter"
    from 1 to _eGrps do {
        if (surfaceiswater _mPos) exitwith {};
        if (isnil "_eGrp") then {
            _eGrp = [];
        };

        _newpos = [_mkr, 50] call EOS_fnc_findSafePos;

        _eGroup = [_newpos, _side, _faction, 5] call EOS_fnc_spawnvehicle;

        0 = [(_eGroup select 2), "STAskill"] call eos_fnc_grouphandlers;
        (_eGroup select 2) setGroupId[format["%1 SP %2", _mkr, _counter]]; //AV Static Placements
        _eGrp set[count _eGrp, _eGroup];

        if (_debug) then {
            player sidechat format["Static:%1", _counter];
            0 = [_mkr, _counter, "Static", (getpos leader(_eGroup select 2))] call EOS_debug
        };
    };

    //SPAWN CHOPPER
    for "_counter"
    from 1 to _fGrps do {
        if (isnil "_fGrp") then {
            _fGrp = [];
        };
        if ((_fSize select 0) > 0) then {
            _vehType = 4
        } else {
            _vehType = 3
        };
        _newpos = [(markerpos _mkr), 1500, random 360] call BIS_fnc_relPos;
        _fGroup = [_newpos, _side, _faction, _vehType, "fly"] call EOS_fnc_spawnvehicle;
        _fGrp set[count _fGrp, _fGroup];


        if ((_fSize select 0) > 0) then {
            _cargoGrp = createGroup _side;
            0 = [(_fGroup select 0), _fSize, _cargoGrp, _faction, 9] call eos_fnc_setcargo;
            0 = [_cargoGrp, "INFskill"] call eos_fnc_grouphandlers;
            _cargoGrp setGroupId[format["%1 CP %2", _mkr, _counter]]; //AV Chopper patrol
            _fGroup set[count _fGroup, _cargoGrp];
            null = [_mkr, _fGroup, _counter] execvm "scripts\eos\functions\TransportUnload_fnc.sqf";
        } else {
            _wp1 = (_fGroup select 2) addWaypoint[(markerpos _mkr), 0];
            _wp1 setWaypointSpeed "FULL";
            _wp1 setWaypointType "SAD";
        };

        0 = [(_fGroup select 2), "AIRskill"] call eos_fnc_grouphandlers;

        if (_debug) then {
            player sidechat format["Chopper:%1", _counter];
            0 = [_mkr, _counter, "Chopper", (getpos leader(_fGroup select 2))] call EOS_debug
        };
    };

    //SPAWN ALT TRIGGERS
    _clear = createTrigger["EmptyDetector", _mPos];
    _clear setTriggerArea[_mkrX, _mkrY, _mkrAgl, FALSE];
    _clear setTriggerActivation[_enemyFaction, "NOT PRESENT", true];
    _clear setTriggerStatements["this", "", ""];
    _taken = createTrigger["EmptyDetector", _mPos];
    _taken setTriggerArea[_mkrX, _mkrY, _mkrAgl, FALSE];
    _taken setTriggerActivation["ANY", "PRESENT", true];
    _taken setTriggerStatements["{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count allUnits > 0", "", ""];
    _eosAct = true;
    while {
        _eosAct
    }
    do {
        // IF PLAYER LEAVES THE AREA OR ZONE DEACTIVATED
        if (!triggeractivated _eosActivated || getmarkercolor _mkr == "colorblack") exitwith {
            if (_debug) then {
                if (!(getmarkercolor _mkr == "colorblack")) then {
                    hint "Restarting Zone AND deleting units";
                } else {
                    hint "EOS zone deactivated";
                };
            };
            //CACHE LIGHT VEHICLES
            if (!isnil "_cGrp") then {
                {
                    _vehicle = _x select 0;
                    _crew = _x select 1;
                    _grp = _x select 2;
                    if (!alive _vehicle || {!alive _x
                        }
                        foreach _crew) then {
                        _cGrps = _cGrps - 1;
                    }; {
                        deleteVehicle _x
                    }
                    forEach(_crew);
                    if (!(vehicle player == _vehicle)) then {
                        {
                            deleteVehicle _x
                        }
                        forEach[_vehicle];
                    }; {
                        deleteVehicle _x
                    }
                    foreach units _grp;
                    deleteGroup _grp;
                }
                foreach _cGrp;
                if (_debug) then {
                    player sidechat format["ID:c%1", _cGrps];
                };
            };

            // CACHE ARMOURED VEHICLES
            if (!isnil "_dGrp") then {
                {
                    _vehicle = _x select 0;
                    _crew = _x select 1;
                    _grp = _x select 2;
                    if (!alive _vehicle || {!alive _x
                        }
                        foreach _crew) then {
                        _dGrps = _dGrps - 1;
                    }; {
                        deleteVehicle _x
                    }
                    forEach(_crew);
                    if (!(vehicle player == _vehicle)) then {
                        {
                            deleteVehicle _x
                        }
                        forEach[_vehicle];
                    }; {
                        deleteVehicle _x
                    }
                    foreach units _grp;
                    deleteGroup _grp;
                }
                foreach _dGrp;
                if (_debug) then {
                    player sidechat format["ID:c%1", _dGrps];
                };
            };

            // CACHE PATROL INFANTRY
            if (!isnil "_bGrp") then {
                _n = 0; {
                    _n = _n + 1;
                    _units = {
                        alive _x
                    }
                    count units _x;
                    _cacheGrp = format["PA%1", _n];
                    if (_debug) then {
                        player sidechat format["ID:%1,cache - %2", _cacheGrp, _units];
                    };
                    _eosActivated setvariable[_cacheGrp, _units]; {
                        deleteVehicle _x
                    }
                    foreach units _x;
                    deleteGroup _x;
                }
                foreach _bGrp;
            };

            // CACHE HOUSE INFANTRY
            if (!isnil "_aGrp") then {
                _n = 0; {
                    _n = _n + 1;
                    _units = {
                        alive _x
                    }
                    count units _x;
                    _cacheGrp = format["HP%1", _n];
                    if (_debug) then {
                        player sidechat format["ID:%1,cache - %2", _cacheGrp, _units];
                    };
                    _eosActivated setvariable[_cacheGrp, _units]; {
                        deleteVehicle _x
                    }
                    foreach units _x;
                    deleteGroup _x;
                }
                foreach _aGrp;
            };

            // CACHE MORTARS
            if (!isnil "_eGrp") then {
                {
                    _vehicle = _x select 0;
                    _crew = _x select 1;
                    _grp = _x select 2;
                    if (!alive _vehicle || {!alive _x
                        }
                        foreach _crew) then {
                        _eGrps = _eGrps - 1;
                    }; {
                        deleteVehicle _x
                    }
                    forEach(_crew);
                    if (!(vehicle player == _vehicle)) then {
                        {
                            deleteVehicle _x
                        }
                        forEach[_vehicle];
                    }; {
                        deleteVehicle _x
                    }
                    foreach units _grp;
                    deleteGroup _grp;
                }
                foreach _eGrp;
            };

            // CACHE HELICOPTER TRANSPORT
            if (!isnil "_fGrp") then {
                {
                    _vehicle = _x select 0;
                    _crew = _x select 1;
                    _grp = _x select 2;
                    _cargoGrp = _x select 3;
                    if (!alive _vehicle || {!alive _x
                        }
                        foreach _crew) then {
                        _fGrps = _fGrps - 1;
                    }; {
                        deleteVehicle _x
                    }
                    forEach(_crew);
                    if (!(vehicle player == _vehicle)) then {
                        {
                            deleteVehicle _x
                        }
                        forEach[_vehicle];
                    }; {
                        deleteVehicle _x
                    }
                    foreach units _grp;
                    deleteGroup _grp;
                    if (!isnil "_cargoGrp") then {
                        {
                            deleteVehicle _x
                        }
                        foreach units _cargoGrp;
                        deleteGroup _cargoGrp;
                    };

                }
                foreach _fGrp;
            };

            _eosAct = false;
            if (_debug) then {
                hint "Zone Cached";
            };
        };
        if (triggeractivated _clear and triggeractivated _taken and!_civZone) exitwith { // IF ZONE CAPTURED BEGIN CHECKING FOR ENEMIES
            _cGrps = 0;
            _aGrps = 0;
            _bGrps = 0;
            _dGrps = 0;
            _eGrps = 0;
            _fGrps = 0;
            while {
                triggeractivated _eosActivated AND!(getmarkercolor _mkr == "colorblack")
            }
            do {
                if (!triggeractivated _clear) then {
                    _mkr setmarkercolor hostileColor;
                    _mkr setmarkerAlpha _mAH;
                    if (_debug) then {
                        hint "Zone Lost";
                    };
                } else {
                    _mkr setmarkercolor VictoryColor;
                    _mkr setmarkerAlpha _mAN;
                    if (_debug) then {
                        hint "Zone Captured";
                    };
                };
                sleep 1;
            };
            // PLAYER LEFT ZONE
            _eosAct = false;
        };
        sleep 0.5;
    };

    deletevehicle _clear;
    deletevehicle _taken;

    if (!(getmarkercolor _mkr == "colorblack")) then {
        null = [_mkr, [_aGrps, _aSize],
            [_bGrps, _bSize],
            [_cGrps, _cSize],
            [_dGrps, _eGrps, _fGrps, _fSize], _settings, true
        ] execVM "scripts\eos\core\eos_core.sqf";
    } else {
        _Mkr setmarkeralpha 0;
    };
};