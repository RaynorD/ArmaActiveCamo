params [
    ["_object",objNull,[objNull]],
    ["_type",0,[0]], // 0 - Projected, 1 - Refractive
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

if (!isNil {_object getVariable "RaynorActiveCamo_type"}) exitWith {
    [format ["Object already initialized: (%1)",_object],true] call RaynorActiveCamo_fnc_log;
};

private _textureConfig = getArray (configFile >> "CfgVehicles" >> typeOf _object >> "hiddenSelections");
if (count _textureConfig < 1) exitWith {
    [format ["Object has no hidden selection slots: (%1)",_object],true] call RaynorActiveCamo_fnc_log;
};

_object setVariable ["RaynorActiveCamo_type", _type];
_object setVariable ["RaynorActiveCamo_working", damage _object < 0.1];

private _originalTex = getObjectTextures _object;

private _textureSlots = [];
{
    if (_x find "camo" == 0) then {
        _textureSlots pushBack _forEachIndex;
    };
} forEach _textureConfig;

if (count _textureSlots < 1) exitWith {
    [format ["Object has no camo slots: (%1)",_object],true] call RaynorActiveCamo_fnc_log;
};


private _jipOn = _object getVariable ["RaynorActiveCamo_on",false];
if(isNil {_object getVariable "RaynorActiveCamo_on"}) then { // global, don't overwrite if JIP
    _object setVariable ["RaynorActiveCamo_on", false];
};
private _rttName = nil;
private _trackingType = 0;
private _success = true;
switch (_type) do {
    case (0): { // Projected
        if((getPosATL _object select 2) < (sizeOf typeOf _object / 2)) then {
            _trackingType = 1;
        };
        
        private _renderIndex = count RaynorActiveCamo_objects;
        _rttName = format ["raynoractivecamortt%1",_renderIndex];
        RaynorActiveCamo_objects pushBack [_object,nil,_rttName];
        
        //private _modelCenter = [0, ((getCenterOfMass _object) select 1), 0];
        _object setVariable ["RaynorActiveCamo_modelCenter", getCenterOfMass _object];
        
        ([typeOf _object] call RaynorActiveCamo_fnc_typeOffsets) params ["_pitchOffsetType","_fovOffsetType"];
        if(isNil "_pitchOffset") then {
            _pitchOffset = _pitchOffsetType;
        };
        if(isNil "_fovOffset") then {
            _fovOffset = _fovOffsetType;
        };
        
        _object setVariable ["RaynorActiveCamo_trackingType", _trackingType];
        _object setVariable ["RaynorActiveCamo_groundCamActual", 0];
        _object setVariable ["RaynorActiveCamo_groundCamUser", 0];
        _object setVariable ["RaynorActiveCamo_rttName", _rttName];
        _object setVariable ["RaynorActiveCamo_pitchOffset", _pitchOffset];
        _object setVariable ["RaynorActiveCamo_fovOffset", _fovOffset];
    };
    case (1): { // Refractive
        private _damageMats = getArray (configFile >> "CfgVehicles" >> typeOf _object >> "damage" >> "mat");
        
        [format ["initial _textureSlots: %1",_textureSlots]] call RaynorActiveCamo_fnc_log;
        
        if(count _damageMats == 0) exitWith {
            [format ["Object has no damage mat value: (%1)",_object],true] call RaynorActiveCamo_fnc_log;
            _success = false;
        };
        [format ["_damageMats: %1",_damageMats]] call RaynorActiveCamo_fnc_log;
        
        private _matchedTextures = [];
        private _originalMats = [];
        {
            [format ["_textureSlot: %1",_x]] call RaynorActiveCamo_fnc_log;
            if (count _damageMats >= (_x * 3) + 1) then {
                [format ["_matchedTextures pushing: %1", _x * 3]] call RaynorActiveCamo_fnc_log;
                _matchedTextures pushBack _x;
                _originalMats set [_x, (_damageMats select (_x * 3))];
            } else {
                [format ["_matchedTextures skipping: %1", _x * 3]] call RaynorActiveCamo_fnc_log;
            };
        } forEach _textureSlots;
        
        _textureSlots = _matchedTextures;
        [format ["final _textureSlots: %1",_textureSlots]] call RaynorActiveCamo_fnc_log;

        _object setVariable ["RaynorActiveCamo_originalMats", _originalMats];
        
        RaynorActiveCamo_objects pushBack [_object,nil,nil];
    };
};

if (!_success) exitWith {};

_object setVariable ["RaynorActiveCamo_originalTex", _originalTex];
_object setVariable ["RaynorActiveCamo_textureSlots", _textureSlots];

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

if (_type == 0) then {
    private _groundTrackingCond = _finalCondOff + " && (_target getVariable ['RaynorActiveCamo_trackingType',0] == 1)";
    
    _object addAction [format ["<t color='#%1'>Active Camo - Right Camera</t>",_actionColor], RaynorActiveCamo_fnc_actionSwitchCamera, [0], -9999, false, true, "", _groundTrackingCond];
    _object addAction [format ["<t color='#%1'>Active Camo - Left Camera</t>",_actionColor], RaynorActiveCamo_fnc_actionSwitchCamera, [1], -9999, false, true, "", _groundTrackingCond];
    _object addAction [format ["<t color='#%1'>Active Camo - Front Camera</t>",_actionColor], RaynorActiveCamo_fnc_actionSwitchCamera, [2], -9999, false, true, "", _groundTrackingCond];
    _object addAction [format ["<t color='#%1'>Active Camo - Rear Camera</t>",_actionColor], RaynorActiveCamo_fnc_actionSwitchCamera, [3], -9999, false, true, "", _groundTrackingCond];
};

[format ["Object added: %1",[_object,typeOf _object,_type,_trackingType,_rttName,_textureSlots,[_externalAllowed,_cargoAllowed,_gunnerAllowed,_turretAllowed,_commanderAllowed,_driverAllowed]]]] call RaynorActiveCamo_fnc_log;

if(_jipOn) then {
    [_object] call RaynorActiveCamo_fnc_on;
};
