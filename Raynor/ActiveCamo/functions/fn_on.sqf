params [["_object",objNull,[objNull]]];

if(isNil "_object") exitWith {
    [format ["_object was Nil: (%1)",_this],true] call RaynorActiveCamo_fnc_log;
};

_type = _object getVariable "RaynorActiveCamo_type";
if(isNil "_type") exitWith {
    [format ["_type was Nil: (%1)",_this],true] call RaynorActiveCamo_fnc_log;
};

private _textureSlots = _object getVariable ["RaynorActiveCamo_textureSlots",nil];
if(isNil "_textureSlots") exitWith {
    [format ["_textureSlots was Nil: (%1)",_this],true] call RaynorActiveCamo_fnc_log;
};

switch (_type) do {
    case (0): { // Projected
        private _trackingType = _object getVariable "RaynorActiveCamo_trackingType";
        if(isNil "_trackingType") exitWith {
            [format ["trackingType was Nil: (%1)",_this],true] call RaynorActiveCamo_fnc_log;
        };
        
        private _rttName = _object getVariable ["RaynorActiveCamo_rttName",nil];
        if(isNil "_rttName") exitWith {
            [format ["_rttName was Nil: (%1)",_object],true] call RaynorActiveCamo_fnc_log;
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
        
        if(_trackingType == 1) then {
            [_object,0,true] call RaynorActiveCamo_fnc_switchGroundCamera;
        };
        
        if (_object getVariable ["RaynorActiveCamo_on",false]) then {
            {
                _object setObjectTexture [_x, format ["#(argb,512,512,1)r2t(%1,1)",_rttName]];
            } forEach _textureSlots;
            
            [_object,true] call RaynorActiveCamo_fnc_camoSound;
            [format ["Active camo activated: (%1, mode %2, tracking %3)", _object, _type, _trackingType]] call RaynorActiveCamo_fnc_log;
        };
    };
    case (1): { // Refractive
        if (_object getVariable ["RaynorActiveCamo_on",false]) then {
            {
                _object setObjectTexture [_x,"#(argb,8,8,3)color(0.5,0.5,0.5,1)"];
                _object setObjectMaterial [_x,"camo.rvmat"];
            } foreach _textureSlots;
            
            [_object,true] call RaynorActiveCamo_fnc_camoSound;
            [format ["Active camo activated: (%1, mode %2)", _object, _type]] call RaynorActiveCamo_fnc_log;
        };
    };
};
