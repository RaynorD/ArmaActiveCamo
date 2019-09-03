params [["_object",objNull,[objNull]],["_textureSlots",[0,1],[[]]],["_driverOnly",true,[true]],["_externalAllowed",true,[true]]];

if (isNull _object) exitWith {
    ["Object was null",true] call RaynorActiveCamo_fnc_log;
};

private _originalTextures = getObjectTextures _object;

private _renderIndex = count RaynorActiveCamo_db;
RaynorActiveCamo_objects pushBack _object;

private _rttName = format ["RaynorActiveCamo_rtt%1",_renderIndex];

//{
//    _target setObjectTexture [_x, format ["#(argb,512,512,1)r2t(%1,1)",_rttName]];
//} forEach _textureSlots;

// save data locally
RaynorActiveCamo_update = true; // public variable event handler, value doesn't matter
_object setVariable ["RaynorActiveCamo_on", false];
_object setVariable ["RaynorActiveCamo_rttName", _rttName];
_object setVariable ["RaynorActiveCamo_originalTextures", _originalTextures];
_object setVariable ["RaynorActiveCamo_textureSlots", _textureSlots];
_object setVariable ["RaynorActiveCamo_cam", nil];

_conditionOff = "_target getVariable ['RaynorActiveCamo_on',false]";
_conditionOn = format ["!(%1)",_conditionOff];

if(_driverOnly) then {
    _driverOnlyCond = "driver _target == _this";
    _conditionOff = format ["%1; %2;", _conditionOff, _driverOnly];
    _conditionOn = format ["%1; %2;", _conditionOn, _driverOnly];
} else {
    if(!_externalAllowed) then {
        _externalAllowedCond = "_this in crew _target";
        _conditionOff = format ["%1; %2;", _conditionOff, _externalAllowedCond];
        _conditionOn = format ["%1; %2;", _conditionOn, _externalAllowedCond];
    };
};

_object addAction ["Active Camo On", RaynorActiveCamo_fnc_userAction, [true], 1.5, false, true, "", _conditionOn];
_object addAction ["Active Camo Off", RaynorActiveCamo_fnc_userAction, [false], 1.5, false, true, "", _conditionOff];
