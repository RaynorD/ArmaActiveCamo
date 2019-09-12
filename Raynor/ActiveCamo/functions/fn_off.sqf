params [["_object",objNull,[objNull]],["_silent",false,[true]]];

private _textureSlots = _object getVariable ["RaynorActiveCamo_textureSlots",[]];
_originalTex = getArray (configfile >> "CfgVehicles" >> typeOf _object >> "hiddenSelectionsTextures");

private _type = _object getVariable "RaynorActiveCamo_type";

switch (_type) do {
    case (0): { // Projected
        private _rttName = _object getVariable ["RaynorActiveCamo_rttName",nil];
        private _cam = _object getVariable ["RaynorActiveCamo_cam",nil];
        
        {
            _object setObjectTexture [_x, _originalTex select _x];
        } forEach _textureSlots;
        
        if(!isNil "_cam") then {
            _cam cameraEffect ["terminate", "back", _rttName];
            camDestroy _cam;
        };
        
        for "_i" from 0 to count RaynorActiveCamo_objects - 1 do {
            (RaynorActiveCamo_objects select _i) params ["_arrObject","_arrCam","_arrRttName"];
            if(_arrObject == _object) exitWith {
                (RaynorActiveCamo_objects select _i) set [1,nil];
            };
        };
    };
    case (1): { // Refractive
        _originalMats = _object getVariable "RaynorActiveCamo_originalMats";
        {
            _object setObjectTexture [_x,_originalTex select _x];
            _object setObjectMaterial [_x,_originalMats select _x];
        } foreach _textureSlots;
    };
};

if(!_silent) then {
    [_object,false] call RaynorActiveCamo_fnc_camoSound;
    [format ["Active camo de-activated: (%1)",_object]] call RaynorActiveCamo_fnc_log;
};
