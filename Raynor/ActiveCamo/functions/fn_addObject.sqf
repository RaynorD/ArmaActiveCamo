#include "includes.hpp"

params [["_object",objNull],["_textures",[0,1]],["_driverAllowed",true],["_crewAllowed",true],["_externalAllowed",true]];

if (isNull _object) exitWith {
    ["Object was null",true] call RaynorActiveCamo_fnc_log;
};

private _previousTextures = getObjectTextures _object;

if(isNil "RaynorActiveCamo_db") then {
    RaynorActiveCamo_objects = [_object];
} else {
    RaynorActiveCamo_objects pushBack _object;
};

private _renderIndex = count RaynorActiveCamo_db;
private _rttName = format ["RaynorActiveCamo_rtt%1",_renderIndex];

{
    _target setObjectTexture [_x, format ["#(argb,512,512,1)r2t(%1,1)",_rttName]];
} forEach _textures;

_cam = "camera" camCreate [0,0,0];
_cam cameraEffect ["Internal", "Back", _rttName];

private _data = [_rttName,_cam,];
