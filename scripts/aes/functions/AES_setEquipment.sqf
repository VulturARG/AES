/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/

if (!isServer) exitWith {};
// SINGLE INFANTRY GROUP
params ["_unit","_unitType"];

// Change for your units type and it's elementos with the export of BI Arsenal
// Cambiar los tipos de unidad y sus elementos con lo exportado del arsenal BI

if (leader _unit == _unit) then {
    comment "Lider";
    comment "Remove existing items";
    removeAllWeapons _unit;
    removeAllItems _unit;
    removeAllAssignedItems _unit;
    removeUniform _unit;
    removeVest _unit;
    removeBackpack _unit;
    removeHeadgear _unit;
    removeGoggles _unit;

    comment "Add containers";
    _unit forceAddUniform "LOP_U_CHR_Citizen_07";
    _unit addItemToUniform "ACE_epinephrine";
    _unit addItemToUniform "ACE_morphine";
    _unit addItemToUniform "ACE_EarPlugs";
    for "_i" from 1 to 4 do {_unit addItemToUniform "ACE_elasticBandage";};
    for "_i" from 1 to 4 do {_unit addItemToUniform "ACE_packingBandage";};
    _unit addVest "V_BandollierB_cbr";
    for "_i" from 1 to 8 do {_unit addItemToVest "rhs_30Rnd_545x39_AK";};
    _unit addHeadgear "LOP_H_Villager_cap";

    comment "Add weapons";
    _unit addWeapon "rhs_weap_ak74";
    _unit addPrimaryWeaponItem "rhs_acc_dtk1983";
    _unit addPrimaryWeaponItem "rhs_acc_2dpZenit"; //Linterna
    _unit enableGunLights "ForceOn";
} else {
    if (floor random 7 == 5) then {
      comment "Ametrallador";
      comment "Remove existing items";
      removeAllWeapons _unit;
      removeAllItems _unit;
      removeAllAssignedItems _unit;
      removeUniform _unit;
      removeVest _unit;
      removeBackpack _unit;
      removeHeadgear _unit;
      removeGoggles _unit;

      comment "Add containers";
      _unit forceAddUniform "LOP_U_CHR_Citizen_05";
      _unit addVest "V_BandollierB_blk";
      _unit addItemToVest "rhs_100Rnd_762x54mmR";
      _unit addBackpack "B_FieldPack_blk";
      for "_i" from 1 to 3 do {_unit addItemToBackpack "rhs_100Rnd_762x54mmR";};
      _unit addHeadgear "LOP_H_Villager_cap";

      comment "Add weapons";
      _unit addWeapon "rhs_weap_pkm";
    } else {
      comment "Fusilero";
      comment "Remove existing items";
      removeAllWeapons _unit;
      removeAllItems _unit;
      removeAllAssignedItems _unit;
      removeUniform _unit;
      removeVest _unit;
      removeBackpack _unit;
      removeHeadgear _unit;
      removeGoggles _unit;

      comment "Add containers";
      _unit forceAddUniform "LOP_U_CHR_Citizen_05";
      _unit addItemToUniform "rhs_30Rnd_545x39_AK";
      _unit addVest "V_BandollierB_blk";
      for "_i" from 1 to 8 do {_unit addItemToVest "rhs_30Rnd_545x39_AK";};
      _unit addHeadgear "LOP_H_Villager_cap";

      comment "Add weapons";
      _unit addWeapon "rhs_weap_ak74";
      _unit addPrimaryWeaponItem "rhs_acc_dtk1983";
      _unit addPrimaryWeaponItem "rhs_acc_2dpZenit"; //Linterna
    };
};
_unit

/*******************************************************************************
                            Created by |ArgA|Vultur|Cbo¹
*******************************************************************************/