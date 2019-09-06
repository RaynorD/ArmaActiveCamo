params [["_objectType","",["-"]]];

_pitchOffset = 0;
_fovOffset = 0;

_offsets = [
    ["LandVehicle",0,-0.3],
    ["Heli_Attack_01_base_F",10,0]
];

{
    _x params ["_type","_typePitchOffset","_typeFovOffset"];
    if (_objectType isKindOf [_type, configFile >> "CfgVehicles"]) exitWith {
        _pitchOffset = _typePitchOffset;
        _fovOffset = _typeFovOffset;
    };
} foreach _offsets;

[_pitchOffset,_fovOffset]
