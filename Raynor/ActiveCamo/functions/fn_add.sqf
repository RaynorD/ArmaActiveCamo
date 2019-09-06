params [
    ["_object",objNull,[objNull]],
    ["_externalAllowed",false,[true]],
    ["_cargoAllowed",false,[true]],
    ["_gunnerAllowed",false,[true]],
    ["_turretAllowed",false,[true]],
    ["_commanderAllowed",false,[true]],
    ["_driverAllowed",true,[true]],
    "_pitchOffset",
    "_fovOffset"
];

if (isNull _object) exitWith {
    [format ["Object was null: %1",_this],true] call RaynorActiveCamo_fnc_log;
};

private _renderIndex = count RaynorActiveCamo_objects;
private _rttName = format ["raynoractivecamortt%1",_renderIndex];
RaynorActiveCamo_objects pushBack [_object,nil,_rttName];

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
    [format ["Object has no camo slots: (%1)",_object],true] call RaynorActiveCamo_fnc_log;
};

private _modelCenter = [0, ((boundingCenter _object) select 2), 0];

([typeOf _object] call RaynorActiveCamo_fnc_typeOffsets) params ["_pitchOffsetType","_fovOffsetType"];
if(isNil "_pitchOffset") then {
    _pitchOffset = _pitchOffsetType;
};
if(isNil "_fovOffset") then {
    _fovOffset = _fovOffsetType;
};

// 0 = 3d
// 1 = ground
private _trackingType = 0;
if((getPosATL _object select 2) < 5) then {
    _trackingType = 1;
};

// save data locally
if(isNil {_object getVariable "RaynorActiveCamo_on"}) then { // global, don't overwrite if JIP
    _object setVariable ["RaynorActiveCamo_on", false];
};
_object setVariable ["RaynorActiveCamo_trackingType", _trackingType];
_object setVariable ["RaynorActiveCamo_rttName", _rttName];
_object setVariable ["RaynorActiveCamo_textureSlots", _textureSlots];
_object setVariable ["RaynorActiveCamo_modelCenter", _modelCenter];
_object setVariable ["RaynorActiveCamo_pitchOffset", _pitchOffset];
_object setVariable ["RaynorActiveCamo_fovOffset", _fovOffset];
_object setVariable ["RaynorActiveCamo_localState", false];
_object setVariable ["RaynorActiveCamo_working", true];

// check if the system is damaged
private _workingCond = "_target getVariable ['RaynorActiveCamo_working',true]";

// check if in a crew position that is allowed to operate active camo

private _allowedPositions = [];
if(_driverAllowed) then {_allowedPositions pushBack "driver"};
if(_commanderAllowed) then {_allowedPositions pushBack "commander"};
if(_gunnerAllowed) then {_allowedPositions pushBack "gunner"};
if(_turretAllowed) then {_allowedPositions pushBack "turret"};
if(_cargoAllowed) then {_allowedPositions pushBack "cargo"};
private _positionCond = format ["({if(_x#0 == _this) exitWith {_x#1}} count (fullCrew _target) in %1)",_allowedPositions];

if(_externalAllowed) then {
    private _extAllowedCond = "!(_this in _target)";
    _positionCond = format ["(%1 || %2)",_extAllowedCond,_positionCond];
};

// separate on/off actions
private _condOff = "_target getVariable ['RaynorActiveCamo_on',false]";
private _condOn = "!(_target getVariable ['RaynorActiveCamo_on',false])";

_finalCondOff = [_workingCond,_positionCond,_condOff] joinString " && ";
_finalCondOn = [_workingCond,_positionCond,_condOn] joinString " && ";

private _actionColor = "0044FF";
_object addAction [format ["<t color='#%1'>Active Camo Off</t>",_actionColor], RaynorActiveCamo_fnc_actionOnOff, [false], 1.5, false, true, "", _finalCondOff];
_object addAction [format ["<t color='#%1'>Active Camo On</t>",_actionColor], RaynorActiveCamo_fnc_actionOnOff, [true], 1.5, false, true, "", _finalCondOn];

private _groundTrackingCond = _finalCondOff + " && (_target getVariable ['RaynorActiveCamo_trackingType',0] == 1)";

_object addAction [format ["<t color='#%1'>Active Camo - Right Camera</t>",_actionColor], RaynorActiveCamo_fnc_actionSwitchCamera, [0], -9999, false, true, "", _groundTrackingCond];
_object addAction [format ["<t color='#%1'>Active Camo - Left Camera</t>",_actionColor], RaynorActiveCamo_fnc_actionSwitchCamera, [1], -9999, false, true, "", _groundTrackingCond];
_object addAction [format ["<t color='#%1'>Active Camo - Front Camera</t>",_actionColor], RaynorActiveCamo_fnc_actionSwitchCamera, [2], -9999, false, true, "", _groundTrackingCond];
_object addAction [format ["<t color='#%1'>Active Camo - Rear Camera</t>",_actionColor], RaynorActiveCamo_fnc_actionSwitchCamera, [3], -9999, false, true, "", _groundTrackingCond];

[format ["Object added: %1",[_object,typeOf _object,_trackingType,_rttName,_textureSlots,[_externalAllowed,_cargoAllowed,_gunnerAllowed,_turretAllowed,_commanderAllowed,_driverAllowed]]]] call RaynorActiveCamo_fnc_log;
