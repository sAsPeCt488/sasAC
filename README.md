
# sasAC

An Anticheat for the **[FiveM](https://fivem.net/)** Framework.

## Features

- LUA Injection Detection.
- Blacklisted Props/Peds.
- Blacklisted Steam Names (Anti-XSS).
- Blacklisted Events.
- Blacklisted Commands.
- Explosion Detection.
- VPN-Proxy Blocker.
- Anti Car Kick.
- Anti Spectate.
- Anti Godmode.
- Anti Infinite Reload.
- Anti Give/Remove Weapons.
- Discord Integration ( Webhooks ).
- [FiveM-Bansql](https://github.com/RedAlex/FiveM-BanSql) Integration.
- ACE Integration - Moderator Bypass.

## Installation

- Step 1: `git clone REPO`

- Step 2: Drop the sasAC folder into your resource folder.

- Step 3: Add `start sasAC` in your `server.cfg`

  

## Configuration

### LUA Injection
To enable LUA Injection Detection add this to all your resources `fxmanifest.lua`
```
client_script '@sasAC/client/check.lua'
```

### Client:

In `config/config.lua`

- Config.BlacklistWeapons: [Boolean] - Enable Weapon Blacklist.
	- Config.BlacklistedWeapons: [Array] - Contains the Blacklisted Weapons.
- Config.BlacklistVehicles: [Boolean] - Enable Vehicle Blacklist.
	- Config.BlacklistedVehicles: [Array] - Contains the Blacklisted Vehicles
- Config.DetectGodmode: [Boolean] - Enable Godmode Detection.
- Config.AntiExplosiveWeapons: [Boolean] - Enable Explosive Weapon Detection.

### Server:

In `config/config.lua`

- Config.BlacklistEvents: [Boolean] - Enable Event Blacklisting.
	- Config.BlacklistedEvents: [Array] - Contains the Blacklisted Events.
- Config.AntiCarKick: [Boolean] - Enable Car Kick Detection.
- Config.AntiRemovePlayersWeapons: [Boolean] - Enable Remove Player Weapons Detection.
- Config.ExplosionProtection: [Boolean]  - Enable Explosion Protection.
- Config.EnableVPNBlocker: [Boolean] - Enable the VPN/Proxy Blocker.
- Config.BlacklistNames: [Boolean] - Enable Name Blacklisting.
	- Config.BlacklistedNames: [Array] - Contains Blacklisted Names or substrings of them.
- Config.EnableSQLBan: [Boolean]  - Enable [FiveM-Bansql](https://github.com/RedAlex/FiveM-BanSql) Integration.
- Config.BlacklistedCommands: [Array] - Contains Blacklisted Console Commands.

### Discord Integration (Webhooks)
In `config/sconfig.lua`
#### There are 3 different Webhooks which should point to 3 different discord channels.
- Config.WebhookSOS: [String] - Your SOS Channel.
- Config.WebhookAnticheat: [String] - Your Main Anticheat channel.
- Config.WebhookNoDiscord: [String] - Your channel for No Linked Discord alerts.

### ACE Permissions - Moderator Bypass
You can exclude your staff - moderators from AC Detection by adding  them the `sAsPeCt.Anticheat.Bypass`ACE.
You can learn more about ACE [here](https://www.youtube.com/watch?v=EQBs1NFmCaw&ab_channel=Jeva).
You can also use the  `sAsPeCt.Anticheat.VPNBypass` ACE to exclude from VPN/Proxy Detection.


