params ["_message",["_error",false]];

private _type = if(_error) then {"ERROR"} else {"INFO"};

diag_log text format ["[Raynor] (Active Camo) %1: %2",_type,_message];
