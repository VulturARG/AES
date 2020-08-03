/*******************************************************************************
                          Realizado por |ArgA|Vultur|Cbo¹
*******************************************************************************/

private _playersNumber          = 0;
private _markers                = ["marker_2"]; //["m_1","m_2",...,"m_n"]
private _waves                  = 1;
private _angle                  = 360;
private _waitTimeToCountPlayers = 1;

waitUntil { time > _waitTimeToCountPlayers};
private _headlessClients = entities "HeadlessClient_F";
private _humanPlayers = allPlayers - _headlessClients;
_playersNumber = count _humanPlayers;

[_markers,_waves,_playersNumber,_angle] execVM "scripts\AES\OpenMe.sqf";

