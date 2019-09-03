
params ["_object"];

private _textureSlots = _object getVariable "RaynorActiveCamo_textureSlots";
private _rttName = _object getVariable "RaynorActiveCamo_rttName";

if (isNil "_textureSlots") exitWith {
    [format ["Object had no texture slots: %1",_object],true] call RaynorActiveCamo_fnc_log;
};
if (isNil "_rttName") exitWith {
    [format ["Object had no rttName: %1",_object],true] call RaynorActiveCamo_fnc_log;
};

_cam = "camera" camCreate [0,0,0];
_cam cameraEffect ["Internal", "Back", _rttName];

_object setVariable ["RaynorActiveCamo_cam",_cam];

{
    _object setObjectTexture [_x, format ["#(argb,512,512,1)r2t(%1,1)",_rttName]];
} forEach _textureSlots;

[format ["Active camo activated: (%1)",_object]] call RaynorActiveCamo_fnc_log;
