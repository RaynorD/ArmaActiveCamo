// JIP player activate current camo objects

// server addPublicVariableEventHandler code

RaynorActiveCamo_eh_draw3d = addMissionEventHandler ["Draw3d", RaynorActiveCamo_fnc_eh_draw3d];

RaynorActiveCamo_pveh_groundCamera = "RaynorActiveCamo_update" addPublicVariableEventHandler {
    params ["_varName","_payload"];
    _payload call RaynorActiveCamo_fnc_switchGroundCamera;
};

MISSION_ROOT = str missionConfigFile select [0, count str missionConfigFile - 15];

if(!isDedicated) then {
    [] spawn {
        while {true} do {
            [] call RaynorActiveCamo_fnc_updateObjectData;
            sleep 0.5;
        };
    };
};
