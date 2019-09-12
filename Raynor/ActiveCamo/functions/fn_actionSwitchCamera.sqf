params ["_target", "_caller", "_actionId", "_arguments"];
_arguments params [["_position",0,[0]]];

_target setVariable ["RaynorActiveCamo_groundCamUser", _position, true];

[format ["Initiating ground camera change: %1",[_target,_position]]] call RaynorActiveCamo_fnc_log;
