// JIP player activate current camo objects

// server addPublicVariableEventHandler code

RaynorActiveCamo_eh_draw3d = addMissionEventHandler ["Draw3d", RaynorActiveCamo_fnc_eh_draw3d];

//[] spawn {
//    while{true} do {
//        [] call RaynorActiveCamo_fnc_eh_draw3d;
//    };
//};
