#include <sourcemod>
#include <dhooks>

#include <neotokyo>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "0.1.0"

public Plugin myinfo = {
	name = "NT Observer PVS Bypass",
	description = "Allows spectators to bypass PVS filtering, which enables \
some observer tools to work properly.",
	author = "Rain",
	version = PLUGIN_VERSION,
	url = "https://github.com/Rainyan/sourcemod-nt-observer-pvs"
};

public void OnMapStart()
{
	DynamicHook dh = DHookCreate(175, HookType_Entity, ReturnType_Bool,
		ThisPointer_CBaseEntity);
	if (!dh)
	{
		SetFailState("Failed to setup dynamic hook");
	}
	DHookAddParam(dh, HookParamType_CBaseEntity);
	DHookAddParam(dh, HookParamType_CBaseEntity);

	int team = TEAM_SPECTATOR;
	int team_entity = GetTeamEntity(team);
	if (!IsValidEntity(team_entity))
	{
		SetFailState("Team entity is not valid: %d, %d", team, team_entity);
	}
	if (INVALID_HOOK_ID == dh.HookEntity(
		Hook_Pre, team_entity, ShouldTransmitToPlayer))
	{
		SetFailState("Failed to hook");
	}

	delete dh;
}

public MRESReturn ShouldTransmitToPlayer(int pThis, DHookReturn hReturn,
	DHookParam hParams)
{
	hReturn.Value = true;
	return MRES_Supercede;
}