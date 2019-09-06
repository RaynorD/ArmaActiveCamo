params ["_object", "_caller", "_actionId", "_arguments"];

_arguments params ["_state"];

switch (_state) do {
    case (true): {
        if(isMultiplayer) then {
            ["Active Camo - Deployed"] remoteExec ["vehicleChat",crew _object];
        } else {
            (vehicle player) vehicleChat "Active Camo - Online";
        };
        _object setVariable ["RaynorActiveCamo_on", true, true];
        [_object] call RaynorActiveCamo_fnc_on;
    };
    case (false): {
        if(isMultiplayer) then {
            ["Active Camo - Shut Down"] remoteExec ["vehicleChat",crew _object];
        } else {
            (vehicle player) vehicleChat "Active Camo - In Standby";
        };
        _object setVariable ["RaynorActiveCamo_on", false, true];
        [_object] call RaynorActiveCamo_fnc_off;
    };
};
