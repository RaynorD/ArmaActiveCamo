params [["_object",objNull,[objNull]],"_trackingType"];

if(isNil "_object") exitWith {
    [format ["_object was Nil: (%1)",_trackingType],true] call RaynorActiveCamo_fnc_log;
};
if(isNil "_trackingType") exitWith {
    [format ["trackingType was Nil: (%1)",_object],true] call RaynorActiveCamo_fnc_log;
};

private _rttName = _object getVariable ["RaynorActiveCamo_rttName",nil];
if(isNil "_rttName") exitWith {
    [format ["_rttName was Nil: (%1)",_object],true] call RaynorActiveCamo_fnc_log;
};

private _textureSlots = _object getVariable ["RaynorActiveCamo_textureSlots",nil];
if(isNil "_textureSlots") exitWith {
    [format ["_textureSlots was Nil: (%1)",_object],true] call RaynorActiveCamo_fnc_log;
};

private _cam = _object getVariable ["RaynorActiveCamo_cam",objNull];
if(isNull _cam) then {
    _cam = "camera" camCreate [0,0,0];
    _cam cameraEffect ["Internal", "Back", _rttName];
    _arrayRef = nil;
    for "_i" from 0 to count RaynorActiveCamo_objects - 1 do {
        (RaynorActiveCamo_objects select _i) params ["_arrObject","_arrCam","_arrRttName"];
        if(_arrObject == _object) exitWith {
            if(!isNil "_arrCam") then {
                if(!isNil "_arrRttName") then {
                    _arrCam cameraEffect ["terminate", "back", _arrRttName];
                };
                camDestroy _arrCam;
            };
            (RaynorActiveCamo_objects select _i) set [1,_cam];
        };
    };
} else {
    detach _cam;
};
_object setVariable ["RaynorActiveCamo_cam",_cam];

switch (_trackingType) do {
    case (0): { // air/3d
        _object setVariable ["RaynorActiveCamo_trackingType",0];
    };
    case (1): { // ground
        _object setVariable ["RaynorActiveCamo_trackingType",1];
        [_object,0,true] call RaynorActiveCamo_fnc_switchGroundCamera;
    };
};

if (_object getVariable ["RaynorActiveCamo_on",false]) then {
    {
        _object setObjectTexture [_x, format ["#(argb,512,512,1)r2t(%1,1)",_rttName]];
    } forEach _textureSlots;
    
    if(player in _object) then {
        playSound "RaynorActiveCamo_on_int";
    } else {
        _object say3d "RaynorActiveCamo_on_ext";
    };
    
    _object setVariable ["RaynorActiveCamo_on",true];
    [format ["Active camo activated: (%1, %2)",_object, _trackingType]] call RaynorActiveCamo_fnc_log;
};
