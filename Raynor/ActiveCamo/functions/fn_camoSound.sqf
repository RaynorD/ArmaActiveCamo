params [
    ["_object",objNull,[objNull]],
    ["_on",true,[true]]
];

if (_on) then {
    if(player in _object) then {
        playSound "RaynorActiveCamo_on_int";
    } else {
        _object say3d "RaynorActiveCamo_on_ext";
    };
} else {
    if(player in _object) then {
        playSound "RaynorActiveCamo_off_int";
    } else {
        _object say3d "RaynorActiveCamo_off_ext";
    };
};
