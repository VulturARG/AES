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

private _AES_DELETE_DISTANCE                 =  950;  //Delete units outside this distance from marker's center 
////////////////////////////////////////////////////////////////////////////////

// [["name unit", cargo type, "Short Name"],...]
AES_TYPE_UNIT = [["patrol",0,"PA"],["light vehicles",9,"LV"],["armor",0,"AV"],["attack helo",0,"AH"],["cargo helo",9,"TH"],["para helo",9,"PT"],["halo",0,"HA"]]; 
////////////////////////////////////////////////////////////////////////////////

AES_DEFAULT_MINIMUM_DISTANCE = [["patrol",_AES_DEFAULT_INFANTERY_MIN_DIST],["light vehicles",_AES_DEFAULT_VEHICLES_MIN_DIST],["armor",_AES_DEFAULT_ARMOR_MIN_DIST],["attack helo",_AES_DEFAULT_ATTACK_CHOPPER_MIN_DIST],["cargo helo",_AES_DEFAULT_CHOPPER_MIN_DIST],["para helo",_AES_DEFAULT_CHOPPER_JUMP_MIN_DIST],["halo",_AES_DEFAULT_HALO_MIN_DIST]];
AES_DEFAULT_JUMP_HELO        = [["para helo",_AES_DEFAULT_CHOPPER_JUMP_HEIGHT],["halo",_AES_DEFAULT_HALO_JUMP_HEIGHT]];
//DEFAULT_MINIMUM_DISTANCE = [["patrol",500],["light vehicles",800],["armor",800],["attack helo",1400],["cargo helo",1400],["para helo",1400],["halo",200]];
//DEFAULT_JUMP_HELO        = [["para helo",200],["halo",600]];
////////////////////////////////////////////////////////////////////////////////

AES_MIN_MAX_SIZE_GROUP = [[1,1],[2,4],[4,8],[8,12],[12,16],[16,20]];
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/