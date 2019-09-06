_eyePos = positionCameraToWorld [0,0,0]; // PositionAGL

{
    _x params ["_object","_cam","_rttName"];
    if(!isNil "_object") then {
        if(!isNull _object) then {
            if(alive _object) then {
                if (_object getVariable ["RaynorActiveCamo_on", false]) then {
                    if (_object getVariable ["RaynorActiveCamo_trackingType",0] == 0) then {
                        if (!isNil "_cam") then {
                            private _modelCenter = _object getVariable ["RaynorActiveCamo_modelCenter", [0,0,0]];
                            private _modelEyePos = _object worldToModelVisual _eyePos;
                            private _modelCamPos = (vectorNormalized (_modelEyePos vectorMultiply -1)) vectorMultiply (sizeOf typeOf _object / 2);
                            private _camPos = (_object modelToWorldVisual _modelCamPos);
                            _cam setPos _camPos;
                            
                            private _cameraDir = getCameraViewDirection player;
                            private _zVec = _cameraDir vectorCrossProduct [0,0,1];
                            private _sideVec = _zVec vectorCrossProduct _cameraDir;
                            private _camUp = _cameraDir vectorCrossProduct _sideVec;
                            _cam setVectorDir _cameraDir;
                            _cam setVectorUp _sideVec;
                            
                            //systemChat format ["_camPos: %1",_camPos];
                            //systemChat format ["distance: %1",_camPos distance _object];
                            //systemChat format ["_modelEyePos: %1",_modelEyePos];
                            //systemChat format ["_modelCamPos: %1",_modelCamPos];
                            //systemChat format ["getCameraViewDirection: %1", getCameraViewDirection player];
                            //systemChat format ["_zVec: %1",_zVec];
                            //systemChat format ["_sideVec: %1",_sideVec];
                            //systemChat format ["_camUp: %1",_camUp];
                            //systemChat format ["positionCameraToWorld: %1", _eyePos];
                            
                            // find the correct fov based on distance
                            private _fovOffset = _object getVariable ["RaynorActiveCamo_fovOffset",0];
                            private _fov = ((1-((_eyePos distance _object) * 0.02) + -0.2) max 0.01) + _fovOffset;
                            _cam camSetFov _fov;
                            _cam camCommit 0;
                            //systemChat format ["_fov: %1",_fov];
                            
                            /*
                            // World reference
                            //find the camera position on the back side
                            private _worldPos = (_object modelToWorldVisual _modelCenter); // PositionAGL
                            private _vec = (_eyePos vectorFromTo _worldPos); // PositionAGL
                            private _pos = AGLToASL (_worldPos vectorAdd (_vec vectorMultiply (sizeOf typeOf _object / 2)));
                            _cam setPosASL _pos;
                            systemChat format ["ASL: %1",_pos select 2];
                            systemChat format ["ATL: %1", ((ASLToATL _pos) select 2)];
                            
                            // find the correct fov based on distance
                            private _fovOffset = _object getVariable ["RaynorActiveCamo_fovOffset",0];
                            private _fov = ((1-((_eyePos distance _worldPos) * 0.02) + -0.2) max 0.01) + _fovOffset;
                            _cam camSetFov _fov;
                            _cam camCommit 0;
                            //systemChat format ["_fov: %1",_fov];
                            
                            // set things up
                            private _pitchOffset = _object getVariable ["RaynorActiveCamo_pitchOffset",0];
                            _cam setVectorDir [_vec#0, _vec#1,0];
                            private _objPitchBank = _object call BIS_fnc_getPitchBank;
                            [
                                _cam,
                                ((_worldPos select 2) - (_eyePos select 2)) atan2 (_eyePos distance2d _worldPos) + _pitchOffset,
                                0
                            ] call BIS_fnc_setPitchBank;
                            */
                            
                            if(!isNil "RaynorActiveCamo_debug") then {
                                if(RaynorActiveCamo_debug) then {
                                    private _debugSphere = _object getVariable ["RaynorActiveCamo_debugSphere", objNull];
                                    if(isNull _debugSphere) then {
                                        _debugSphere = createVehicle ["Sign_Sphere200cm_F",[0,0,0]];
                                        _object setVariable ["RaynorActiveCamo_debugSphere", _debugSphere];
                                    };
                                    _debugSphere setPos _pos;
                                };
                            };
                        } else {
                            [format ["Cam is Nil: (%1)",_object],true] call RaynorActiveCamo_fnc_log;
                        };
                    };
                };
            };
        };
    };
} forEach RaynorActiveCamo_objects;
