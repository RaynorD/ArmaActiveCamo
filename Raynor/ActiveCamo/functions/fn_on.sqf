
params [["_object",objNull,[objNull]],["_sound",true,[true]],["_instant",false,[true]]];

private _textureSlots = _object getVariable "RaynorActiveCamo_textureSlots";
private _rttName = _object getVariable "RaynorActiveCamo_rttName";

if (isNil "_object") exitWith {
    ["Object was nil",true] call RaynorActiveCamo_fnc_log;
};
if (isNull _object) exitWith {
    ["Object was null",true] call RaynorActiveCamo_fnc_log;
};
if (isNil "_textureSlots") exitWith {
    [format ["Object had no texture slots: %1",_object],true] call RaynorActiveCamo_fnc_log;
};
if (isNil "_rttName") exitWith {
    [format ["Object had no rttName: %1",_object],true] call RaynorActiveCamo_fnc_log;
};

if((getPosATL _object select 2) > 5) then {
    [_object,0] call RaynorActiveCamo_fnc_setTracking;
} else {
    [_object,1] call RaynorActiveCamo_fnc_setTracking;
};
