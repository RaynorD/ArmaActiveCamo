

params ["_varName","_varValue","_target"];

systemChat format ["Received RaynorActiveCamo_update publicVariable", _this];

// update render list
{
    //code
} forEach RaynorActiveCamo_objects;
