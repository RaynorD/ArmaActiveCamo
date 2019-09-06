params [["_object",objNull,[objNull]],["_instant",false,[true]]];

private _textureSlots = _object getVariable ["RaynorActiveCamo_textureSlots",[]];
private _rttName = _object getVariable ["RaynorActiveCamo_rttName",nil];
private _cam = _object getVariable ["RaynorActiveCamo_cam",nil];

_originalTex = getArray (configfile >> "CfgVehicles" >> typeOf _object >> "hiddenSelectionsTextures");
{
    _object setObjectTexture [_x,_originalTex select _x];
} forEach _textureSlots;

if(!isNil "_cam") then {
    _cam cameraEffect ["terminate", "back", _rttName];
    camDestroy _cam;
};

for "_i" from 0 to count RaynorActiveCamo_objects - 1 do {
    (RaynorActiveCamo_objects select _i) params ["_arrObject","_arrCam","_arrRttName"];
    if(_arrObject == _object) exitWith {
        (RaynorActiveCamo_objects select _i) set [1,nil];
    };
};

_object setVariable ["RaynorActiveCamo_on", false];

if(!_instant) then {
    if(player in _object) then {
        playSound "RaynorActiveCamo_off_int";
    } else {
        _object say3d "RaynorActiveCamo_off_ext";
    };
    [format ["Active camo de-activated: (%1)",_object]] call RaynorActiveCamo_fnc_log;
};
