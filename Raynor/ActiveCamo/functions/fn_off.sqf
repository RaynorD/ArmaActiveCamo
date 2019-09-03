params ["_object"];

private _textureSlots = _object getVariable ["RaynorActiveCamo_textureSlots",[]];
private _rttName = _object getVariable ["RaynorActiveCamo_rttName",nil];
private _cam = _object getVariable ["RaynorActiveCamo_cam",nil];

_originalTex = getArray (configfile >> "CfgVehicles" >> typeOf _object >> "hiddenSelectionsTextures");
{
    _object setObjectTexture [_x,_originalTex select _x];
} forEach _textureSlots;

_cam cameraEffect ["terminate", "back", _rttName];
camDestroy _cam;

[format ["Active camo de-activated: (%1)",_object]] call RaynorActiveCamo_fnc_log;
