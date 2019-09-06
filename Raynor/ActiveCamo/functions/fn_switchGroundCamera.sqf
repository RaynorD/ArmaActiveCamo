params ["_object", ["_position",0,[0]], ["_silent",false,[true]]];

_object setVariable ["RaynorActiveCamo_cameraPosition", _position];

if(isNull _object) exitWith {
    [format ["Object null, can't update camera position: %1",_position],true] call RaynorActiveCamo_fnc_log;
};

private _cam = _object getVariable ["RaynorActiveCamo_cam",objNull];

if(isNull _cam) exitWith {
    [format ["Camera null, can't update camera position: %1 > %2",_object,_position],true] call RaynorActiveCamo_fnc_log;
};

_attachObjs = [_cam];

private _debugSphere = _object getVariable ["RaynorActiveCamo_debugSphere", objNull];
if(!isNil "RaynorActiveCamo_debug") then {
    if(RaynorActiveCamo_debug) then {
        if(isNull _debugSphere) then {
            _debugSphere = createVehicle ["Sign_Arrow_Direction_F",[0,0,0]];
            _object setVariable ["RaynorActiveCamo_debugSphere", _debugSphere];
        };
        _attachObjs pushBack _debugSphere;
    };
};

private _camPos = [];
private _objDir = direction _object;
private _dirOffset = 0;
private _pitchDown = -50;
private _text = "";

switch (_position) do {
    case (0): { // right
        _camPos = [
            ((boundingBoxReal _object)#1#0) * 1.3,
            0,
            ((boundingBoxReal _object)#1#2) * 0.5
        ];
        _dirOffset = 90;
        _text = "Active Camo - switched to Right Camera";
    };
    case (1): { // left
        _camPos = [
            ((boundingBoxReal _object)#0#0) * 1.3,
            0,
            ((boundingBoxReal _object)#1#2) * 0.5
        ];
        _dirOffset = -90;
        _text = "Active Camo - switched to Left Camera";
    };
    case (2): { // front
        _camPos = [
            0,
            ((boundingBoxReal _object)#1#1) * 1.3,
            ((boundingBoxReal _object)#1#2) * 0.5
        ];
        _text = "Active Camo - switched to Front Camera";
    };
    case (3): { //  rear
        _camPos = [
            0,
            ((boundingBoxReal _object)#0#1) * 1.3,
            ((boundingBoxReal _object)#1#2) * 0.5
        ];
        _dirOffset = 180;
        _text = "Active Camo - switched to Rear Camera";
    };
};

private _finalDir = _objDir + _dirOffset;

{
    _x attachTo [_object, _camPos];
    _x setDir _finalDir;
    sleep 0.03;
    [_x,-90,0] call BIS_fnc_setPitchBank;
} forEach _attachObjs;

_cam camSetFov 0.3;
_cam camCommit 0;

if(!_silent) then {
    if(isMultiplayer) then {
        [_text] remoteExec ["vehicleChat",crew _object];
    } else {
        (vehicle player) vehicleChat _text;
    };
};

RaynorActiveCamo_update = [_object,_position];
publicVariable "RaynorActiveCamo_update";

// broadcast message to vehicle chat
