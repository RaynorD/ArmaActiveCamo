params [["_object",objNull,[objNull]],["_driverOnly",true,[true]],["_externalAllowed",true,[true]]];

if (isNull _object) exitWith {
    [format ["Object was null: %1",_this],true] call RaynorActiveCamo_fnc_log;
};

private _renderIndex = count RaynorActiveCamo_objects;
RaynorActiveCamo_objects pushBack _object;

private _rttName = format ["RaynorActiveCamo_rtt%1",_renderIndex];

private _textureConfig = getArray (configFile >> "CfgVehicles" >> typeOf _object >> "hiddenSelections");
if (count _textureConfig < 1) exitWith {
    [format ["Object has no hidden selection slots: (%1)",_object],true] call RaynorActiveCamo_fnc_log;
};

private _textureSlots = [];
{
    if (_x find "camo" == 0) then {
        _textureSlots pushBack _forEachIndex;
    };
} forEach _textureConfig;

if (count _textureSlots < 1) exitWith {
    [format ["Object has camo slots: (%1)",_object],true] call RaynorActiveCamo_fnc_log;
};

private _modelCenter = getPosASL _object;
_modelCenter set [2,_modelCenter#2 + ((boundingCenter _object) select 2)];

// save data locally
if(isNil {_object getVariable "RaynorActiveCamo_on"}) then { // global, don't overwrite if JIP
    _object setVariable ["RaynorActiveCamo_on", false];
};
_object setVariable ["RaynorActiveCamo_rttName", _rttName];
_object setVariable ["RaynorActiveCamo_textureSlots", _textureSlots];
_object setVariable ["RaynorActiveCamo_modelCenter", _modelCenter];
_object setVariable ["RaynorActiveCamo_localState", false];

private _conditionOff = "_target getVariable ['RaynorActiveCamo_on',false]";
private _conditionOn = format ["!(%1)",_conditionOff];

if(_driverOnly) then {
    private _driverOnlyCond = "driver _target == _this";
    _conditionOff = format ["%1; %2;", _conditionOff, _driverOnly];
    _conditionOn = format ["%1; %2;", _conditionOn, _driverOnly];
} else {
    if(!_externalAllowed) then {
        private _externalAllowedCond = "_this in crew _target";
        _conditionOff = format ["%1; %2;", _conditionOff, _externalAllowedCond];
        _conditionOn = format ["%1; %2;", _conditionOn, _externalAllowedCond];
    };
};

_object addAction ["Active Camo Off", RaynorActiveCamo_fnc_userAction, [false], 1.5, false, true, "", _conditionOff];
_object addAction ["Active Camo On", RaynorActiveCamo_fnc_userAction, [true], 1.5, false, true, "", _conditionOn];

[format ["Object added: %1",[_object,typeOf _object,_rttName,_textureSlots,[_driverOnly,_externalAllowed]]]] call RaynorActiveCamo_fnc_log;
