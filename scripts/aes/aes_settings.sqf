/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/

//Distances (DIST) in meters
private _AES_DEFAULT_INFANTERY_MIN_DIST      =  500;  
private _AES_DEFAULT_VEHICLES_MIN_DIST       =  800;
private _AES_DEFAULT_ARMOR_MIN_DIST          =  800;
private _AES_DEFAULT_ATTACK_CHOPPER_MIN_DIST = 1400;
private _AES_DEFAULT_CHOPPER_MIN_DIST        = 1400;
private _AES_DEFAULT_CHOPPER_JUMP_MIN_DIST   = 1400;
private _AES_DEFAULT_CHOPPER_JUMP_HEIGHT     =  200;
private _AES_DEFAULT_HALO_MIN_DIST           =  200;
private _AES_DEFAULT_HALO_JUMP_HEIGHT        =  600;
////////////////////////////////////////////////////////////////////////////////

AES_DELETE_DISTANCE                          =  950;  //Delete units outside this distance from marker's center 
////////////////////////////////////////////////////////////////////////////////

// [["name unit", cargo type, "Short Name",findSafePos(default true)],...]
AES_UNIT_TYPE = [["patrol","troop","PA"],["light vehicle","cargo","LV"],["armor","crew","AV"],["attack chopper","crew","AH",false],["cargo chopper","cargo","TH",false],["para chopper","cargo","PT",false],["halo","troop","HA",false]]; 
////////////////////////////////////////////////////////////////////////////////

private _troopFormation = ["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND", "LINE"] call BIS_fnc_selectRandom;

AES_WAYPOINT_TYPE = [
                        ["patrol",[["center","SAD","LIMITED","AWARE",_troopFormation,15,"RED"]]],
                        ["light vehicle",[["center","UNLOAD","LIMITED","SAFE","NO CHANGE",15,"RED"],["center","SAD","LIMITED","AWARE","NO CHANGE",15,"RED"]]],
                        ["armor",[["center","SAD","LIMITED","AWARE","NO CHANGE",15,"RED"]]],
                        ["attack chopper",[]],
                        ["cargo chopper",[]],
                        ["para chopper",[]],
                        ["halo",[["center","SAD","LIMITED","AWARE",_troopFormation,15,"RED"]]]
                    ];
////////////////////////////////////////////////////////////////////////////////

AES_DEFAULT_MINIMUM_DISTANCE = [["patrol",_AES_DEFAULT_INFANTERY_MIN_DIST],["light vehicle",_AES_DEFAULT_VEHICLES_MIN_DIST],["armor",_AES_DEFAULT_ARMOR_MIN_DIST],["attack chopper",_AES_DEFAULT_ATTACK_CHOPPER_MIN_DIST],["cargo chopper",_AES_DEFAULT_CHOPPER_MIN_DIST],["para chopper",_AES_DEFAULT_CHOPPER_JUMP_MIN_DIST],["halo",_AES_DEFAULT_HALO_MIN_DIST]];
AES_DEFAULT_JUMP_PARA        = [["para chopper",_AES_DEFAULT_CHOPPER_JUMP_HEIGHT],["halo",_AES_DEFAULT_HALO_JUMP_HEIGHT]];
////////////////////////////////////////////////////////////////////////////////

AES_MIN_MAX_SIZE_GROUP = [[1,1],[2,4],[4,8],[8,12],[12,16],[16,20]];
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/
/*
["_destination","center"],["_wpType","SAD"],["_wpSpeed","LIMITED"],["_wpBehaviourVehicle","SAFE"],["_wpBehaviourUnit","AWARE"],["_wpFormation","NO CHANGE"],["_wpCombatMode","RED"]
	["center","SAD","LIMITED","AWARE","NO CHANGE",15,"RED"]

	_getToMarker setWaypointType ;
	_getToMarker setWaypointSpeed ;
	_getToMarker setWaypointBehaviour ;
	_getToMarker setWaypointFormation ;
	_getToMarker setWaypointCompletionRadius ;
	_getToMarker setWaypointCombatMode ;

    // ADD WAYPOINTS LIGHT VEHICLES
{
	_dir_atk= _markerPos getDir (_x select 0);
	_pos = [_markerPos, (_mkrX + random 100), _dir_atk] call BIS_fnc_relPos;
	_
	_pos = [_markerPos, 150, _dir_atk] call BIS_fnc_relPos;
	_
}foreach _bGrp;

// ADD WAYPOINTS ARMOURED VEHICLES
{
	_dir_atk= _markerPos getDir (_x select 0);
	_pos = [_markerPos, (_mkrX + random 100), _dir_atk] call BIS_fnc_relPos;
	_group = (_x select 2);
	_leader = leader _group;
	_leader doMove _pos;
	_getToMarker = (_x select 2) addWaypoint [_pos, 0];

}foreach _cGrp;

// ADD WAYPOINTS HALO
{
	_getToMarker = _x addWaypoint [_markerPos, 0];

}foreach _HAGroup;
// */