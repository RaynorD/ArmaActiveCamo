private _eyePos = eyePos player;
private _cleanupNeeded = false;

{
    _x params ["_object","_cam","_rttName"];
    if(!isNil "_object") then {
        if(alive _object) then {
            if (_object getVariable ["RaynorActiveCamo_working", true]) then {
                // check for damage
                if(damage _object > 0.1) then {
                    if (_object getVariable ["RaynorActiveCamo_on", false]) then {
                        [_object] call RaynorActiveCamo_fnc_off;
                        [format ["Vehicle is damaged: (%1)",_object]] call RaynorActiveCamo_fnc_log;
                        _object setVariable ["RaynorActiveCamo_working", false];
                        if(isMultiplayer) then {
                            ["Active Camo - system damaged and inoperable"] remoteExec ["vehicleChat",crew _object];
                        } else {
                            (vehicle player) vehicleChat "Active Camo - system damaged and inoperable";
                        };
                    };
                };
            } else { // damaged
                // check if repaired
                if(damage _object < 0.1) then {
                    _object setVariable ["RaynorActiveCamo_working", true];
                    [format ["Vehicle is repaired: (%1)",_object]] call RaynorActiveCamo_fnc_log;
                    if(isMultiplayer) then {
                        ["Active Camo - system repaired and now operable"] remoteExec ["vehicleChat",crew _object];
                    } else {
                        (vehicle player) vehicleChat "Active Camo - system repaired and now operable";
                    };
                };
            };
            
            // check altitude and change tracking type
            private _altitude = ((getPosATL _object) select 2);
            if(_altitude > (sizeOf typeOf _object / 2) && (_object getVariable ["RaynorActiveCamo_trackingType", 0]) == 1) then {
                // switch from ground to air
                _object setVariable ["RaynorActiveCamo_trackingType", 0, true];
                if (_object getVariable ["RaynorActiveCamo_on", false]) then {
                    [_object, 0] call RaynorActiveCamo_fnc_setTracking;
                    if(isMultiplayer) then {
                        ["Active Camo - switching to air mode"] remoteExec ["vehicleChat",crew _object];
                    } else {
                        (vehicle player) vehicleChat "Active Camo - switching to air mode";
                    };
                };
            };
            if(_altitude < (sizeOf typeOf _object / 2) && (_object getVariable ["RaynorActiveCamo_trackingType", 0]) == 0) then {
                // switch from air to ground
                _object setVariable ["RaynorActiveCamo_trackingType", 1, true];
                if (_object getVariable ["RaynorActiveCamo_on", false]) then {
                    [_object, 1] call RaynorActiveCamo_fnc_setTracking;
                    if(isMultiplayer) then {
                        ["Active Camo - switching to ground mode"] remoteExec ["vehicleChat",crew _object];
                    } else {
                        (vehicle player) vehicleChat "Active Camo - switching to ground mode";
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
