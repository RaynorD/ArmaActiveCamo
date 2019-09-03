params ["_object", "_caller", "_actionId", "_arguments"];

_arguments params ["_state"];

switch (_state) do {
    case (true): {
        systemChat format ["Activating active camo"];
        _object setVariable ["RaynorActiveCamo_on", true, true];
        [_object] call RaynorActiveCamo_fnc_on;
        publicVariable "RaynorActiveCamo_update"; // trigger other clients to update
    };
    case (false): {
        systemChat format ["De-activating active camo"];
        _object setVariable ["RaynorActiveCamo_on", false, true];
        [_object] call RaynorActiveCamo_fnc_off;
        publicVariable "RaynorActiveCamo_update"; // trigger other clients to update
    };
};
