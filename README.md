# QBX Signal Jammer 📡

An immersive signal jammer script for FiveM servers based on the QBX Framework. Players can place jammers that block phone and voice radio signals in a configurable area and duration. Includes hackable interaction and RP effects.

## 🔧 Features
- Blocks voice proximity and lb-phone within a configurable radius (default: 50m)
- 10-minute battery life per jammer
- Hackable using `bl_ui` LightsOut minigame
- Native 3D sound effects (no InteractSound)
- ox_lib Zones used (no while loops)
- Admin command to disable all active jammers
- Fully configurable and performant

## 📦 Requirements
- [QBX Framework](https://github.com/qbcore-framework)
- [ox_lib](https://github.com/overextended/ox_lib) (for zone system)
- [bl_ui](https://github.com/Byte-Labs-Studio/bl_ui) (for hacking minigame)
- A phone resource like `lb-phone`

## 🔌 Installation

1. Clone or download this repository into your resources folder:
```bash
git clone https://github.com/DrizzlyQ/signaljammer.git
```

2. Ensure dependencies in your `server.cfg`:
```cfg
ensure ox_lib
ensure bl_ui
ensure signaljammer
```

3. Add the item in `qb-core/shared/items.lua`:
```lua
['signal_jammer'] = {
    ['name'] = 'signal_jammer',
    ['label'] = 'Signal Jammer',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'jammer.png',
    ['unique'] = true,
    ['useable'] = true,
    ['description'] = 'Blocks signals for a short time.'
}
```

4. Optionally configure `config.lua`:
```lua
Config = {}
Config.JammerRange = 50.0
Config.BatteryLife = 10 -- minutes
Config.HackCooldownSeconds = 30
Config.MaxHackFails = 3
```

## 🛠 Tech Stack
- ✅ ox_lib zones (no while loops)
- ✅ bl_ui LightsOut hacking
- ✅ Native sound effects via `PlaySoundFromCoord`
- ✅ Compatible with both `qb-inventory` and `ox_inventory`

## 👥 Credits
Script by Drizzly & Sxetikos
 
Hacking UI by Byte-Labs `bl_ui`  
ox_lib Integration by Overextended
