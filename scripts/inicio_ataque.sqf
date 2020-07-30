/*******************************************************************************
                          Realizado por |ArgA|Vultur|Cbo¹
*******************************************************************************/

private _Nro_Jugadores = 0;
//Cuento los jugadores a los 10 minutos de iniciado la partida
waitUntil { time > 1};
private _headlessClients = entities "HeadlessClient_F";
private _humanPlayers = allPlayers - _headlessClients;
_Nro_Jugadores = count _humanPlayers;
// Activo la zona EOS
//_markers,_waves,_jugadores,_angle
[["marker_2"],1,_Nro_Jugadores,180] execVM "scripts\eos\OpenMe.sqf";

