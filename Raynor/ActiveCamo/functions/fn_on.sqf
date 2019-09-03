
params ["_object"];

private _textureSlots = _object getVariable "RaynorActiveCamo_textureSlots";
private _rttName = _object getVariable "RaynorActiveCamo_rttName";

if (isNil "_textureSlots") exitWith {
    [format ["Object had no texture slots: %1",_object],true] call RaynorActiveCamo_fnc_log;
};
if (isNil "_rttName") exitWith {
    [format ["Object had no rttName: %1",_object],true] call RaynorActiveCamo_fnc_log;
};

//{
//    _target setObjectTexture [_x, format ["#(argb,512,512,1)r2t(%1,1)",_rttName]];
//} forEach _textureSlots;
