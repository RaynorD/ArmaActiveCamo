_eyePos = positionCameraToWorld [0,0,0]; // PositionAGL

{
    _x params ["_object","_cam","_rttName"];
    if(!isNil "_object") then {
        if(!isNull _object) then {
            if(alive _object) then {
                if (_object getVariable ["RaynorActiveCamo_on", false]) then {
                    if (_object getVariable ["RaynorActiveCamo_type",0] == 0) then { // Projected
                        if (_object getVariable ["RaynorActiveCamo_trackingType",0] == 0) then { // Air
                            if (!isNil "_cam") then {
                                private _comOffset = _object getVariable ["RaynorActiveCamo_modelCenter", nil];
                                
                                private _posComWorld = _object modelToWorldVisual _comOffset;

                                private _vecEyeCom = _eyePos vectorFromTo _posComWorld;
                                private _camVec = _vecEyeCom vectorMultiply (sizeOf typeOf _object);
                                private _camPos = _posComWorld vectorAdd _camVec;
                                _cam setPos _camPos;
                                
                                /*
                                private _modelEyePos = ((getPos _object vectorAdd _comOffset) vectorDiff _eyePos);
                                private _modelCamPos = (vectorNormalized (_modelEyePos vectorMultiply -1)) vectorMultiply (sizeOf typeOf _object);
                                private _camPos = (_object modelToWorldVisual _modelCamPos);
                                _cam setPos _camPos;
                                */
                                
                                private _cameraDir = getCameraViewDirection player;
                                systemChat format ["_cameraDir: %1",_cameraDir];
                                private _zVec = _cameraDir vectorCrossProduct [0,0,1];
                                private _camUp = _zVec vectorCrossProduct _cameraDir;
                                _cam setVectorDir _cameraDir;
                                _cam setVectorUp _camUp;
                                
                                // adjust fov based on distance
                                private _fovOffset = _object getVariable ["RaynorActiveCamo_fovOffset",0];
                                private _fov = ((1-((_eyePos distance _object) * 0.02) + -0.5) max 0.01) + _fovOffset;
                                _cam camSetFov _fov;
                                _cam camCommit 0;
                                
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
    };
} forEach RaynorActiveCamo_objects;
