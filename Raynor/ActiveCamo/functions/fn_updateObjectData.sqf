private _eyePos = eyePos player;
private _cleanupNeeded = false;

_bisCam = false;
if(!isNull (missionnamespace getvariable ["BIS_fnc_camera_cam",objnull])) then {
    _bisCam = true;
};

{
    _x params ["_object","_cam","_rttName"];
    if(!isNil "_object") then {
        if(alive _object) then {
            if ((_object getVariable ["RaynorActiveCamo_type", 0]) == 0) then { // Projected
                if (_object getVariable ["RaynorActiveCamo_on", false]) then {
                    // check ground camera selection
                    if ((_object getVariable ["RaynorActiveCamo_trackingType", 0]) == 1) then {
                        if (
                        _object getVariable ["RaynorActiveCamo_groundCamUser", 0] !=
                        _object getVariable ["RaynorActiveCamo_groundCamActual", 0]
                        ) then {
                            [_object,_object getVariable ["RaynorActiveCamo_groundCamUser", 0]] call RaynorActiveCamo_fnc_switchGroundCamera;
                        };
                    };
                };
                
                // check altitude and change tracking type
                private _altitude = ((getPosATL _object) select 2);
                if(_altitude > (sizeOf typeOf _object / 2) && (_object getVariable ["RaynorActiveCamo_trackingType", 0]) == 1) then {
                    // switch from ground to air
                    _object setVariable ["RaynorActiveCamo_trackingType", 0];
                    if (_object getVariable ["RaynorActiveCamo_on", false]) then {
                        [format ["A vehicle is switching to ground mode: (%2)",_object,(crew _object) select 0]] call RaynorActiveCamo_fnc_log;
                        [_object] call RaynorActiveCamo_fnc_on;
                        if (player in _object) then {
                            (vehicle player) vehicleChat "Active Camo - switching to air mode";
                        };
                    };
                };
                if(_altitude < (sizeOf typeOf _object / 2) && (_object getVariable ["RaynorActiveCamo_trackingType", 0]) == 0) then {
                    // switch from air to ground
                    _object setVariable ["RaynorActiveCamo_trackingType", 1];
                    if (_object getVariable ["RaynorActiveCamo_on", false]) then {
                        [format ["A vehicle is switching to air mode: %1 (%2)",_object,(crew _object) select 0]] call RaynorActiveCamo_fnc_log;
                        [_object] call RaynorActiveCamo_fnc_on;
                        if (player in _object) then {
                            (vehicle player) vehicleChat "Active Camo - switching to ground mode";
                        };
                    };
                };
            };
            if (_object getVariable ["RaynorActiveCamo_working", true]) then {
                // check for damage
                if(damage _object > 0.1) then {
                    if (_object getVariable ["RaynorActiveCamo_on", false]) then {
                        _object setVariable ["RaynorActiveCamo_on", false];
                        [_object] call RaynorActiveCamo_fnc_off;
                        [format ["Vehicle is damaged: (%1)",_object]] call RaynorActiveCamo_fnc_log;
                        _object setVariable ["RaynorActiveCamo_working", false];
                        
                        if (player in _object) then {
                            (vehicle player) vehicleChat "Active Camo - system damaged and inoperable";
                        };
                    };
                };
            } else { // damaged
                // check if repaired
                if(damage _object < 0.1) then {
                    _object setVariable ["RaynorActiveCamo_working", true];
                    [format ["Vehicle is repaired: (%1)",_object]] call RaynorActiveCamo_fnc_log;
                    
                    if (player in _object) then {
                        (vehicle player) vehicleChat "Active Camo - system repaired and now operable";
                    };
                };
            };
        } else { // dead
            // Turn off, instant
            if (_object getVariable ["RaynorActiveCamo_on", false]) then {
                [format ["Vehicle is dead: (%1)",_object]] call RaynorActiveCamo_fnc_log;
                [_object,true] call RaynorActiveCamo_fnc_off;
            };
        };
    } else {
        [format ["Vehicle is Nil: %1",_x],true] call RaynorActiveCamo_fnc_log;
        // clear orphaned camera/rtt
        if(!isNil "_cam") then {
            _cam cameraEffect ["terminate","back",_rttName];
            camDestroy _cam;
        };
        _cleanupNeeded = true;
    };
} forEach RaynorActiveCamo_objects;

if (_cleanupNeeded) then {
    for "_i" from ((count RaynorActiveCamo_objects) - 1) to 0 step -1 do {
        if(isNil {RaynorActiveCamo_objects select _i select 0}) then {
            RaynorActiveCamo_objects deleteAt _i;
        };
    };
    _cleanupNeeded = false;
};
