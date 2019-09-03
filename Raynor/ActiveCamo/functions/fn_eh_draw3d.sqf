private _eyePos = eyePos player;

{
    if (_x getVariable ["RaynorActiveCamo_on", false]) then {
        private _cam = _x getVariable ["RaynorActiveCamo_cam", nil];
        if (!isNil "_cam") then {
            private _modelCenter = _x getVariable ["RaynorActiveCamo_modelCenter", [0,0,0]];

            //find the camera position on the back side
            private _vec = (_eyePos vectorFromTo _modelCenter);
            _cam setPos ASLtoATL (_modelCenter vectorAdd (_vec vectorMultiply (sizeOf typeOf _x / 2)));
            
            // find the correct fov based on distance
            _cam camSetFov (1-((player distance _modelCenter) * 0.03) + 0.2) max 0.15;
            _cam camCommit 0;
            
            // set things up
            _cam setVectorDir [_vec#0, _vec#1 ,0];
            [
                _cam,
                ((_modelCenter select 2) - (_eyePos select 2)) atan2 (_eyePos distance2d _modelCenter),
                0
            ] call BIS_fnc_setPitchBank;
        } else {
            [format ["Cam is Nil: (%1)",_x],true] call RaynorActiveCamo_fnc_log;
        };
    };
} forEach RaynorActiveCamo_objects;
