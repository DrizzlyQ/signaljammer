# QBX Signal Jammer 📡

A highly immersive signal jammer script for QBX-based FiveM servers. Players can place jammers that block phone and radio signals in a configurable radius and can be hacked by others.

## 🔧 Features
- Signal blocking within a 50m radius
- 10-minute battery life
- Hacking minigame to activate or disable (via [bl_ui](https://github.com/Byte-Labs-Studio/bl_ui))
- Blinking lights and noise for RP visibility
- Fully configurable & optimized

## 📦 Requirements
- [QBCore Framework](https://github.com/qbcore-framework/qb-core](https://github.com/Qbox-project)
- [InteractSound](https://github.com/plunkettscott/interact-sound)
- A phone resource like `lb-phone`
- [bl_ui](https://github.com/Byte-Labs-Studio/bl_ui) for the hacking minigame

## 🔊 Sound Setup

1. Make sure you have [InteractSound](https://github.com/plunkettscott/interact-sound) installed and ensured in your server.cfg:
```cfg
ensure interact-sound
```

2. Place the following sound files in this folder:
```
resources/[standalone]/interact-sound/client/html/sounds/
```
- `jammer_noise.ogg` – looped static noise when jammer is active
- `jammer_powerdown.ogg` – shutdown sound when jammer battery dies

3. Optional: Test them by triggering manually with:
```lua
TriggerServerEvent('InteractSound_CL:PlayOnCoords', -1, GetEntityCoords(PlayerPedId()), 'jammer_noise.ogg', 0.7)
```

---

## 🔌 Installation

1. Clone or download this repository into your resources folder:
```bash
git clone https://github.com/yourname/qb-signaljammer.git
```

2. Add it to your `server.cfg`:
```cfg
ensure bl_ui
ensure qb-signaljammer
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

4. Optionally configure `config.lua` for radius and battery time.

## 📷 Preview

![jammer preview](https://i.imgur.com/vTK2wu9.png)

## 🪪 License

This resource is licensed under the MIT License. You are free to modify, distribute, and use it in private or public servers with attribution.

---

## 👥 Credits
Script by Drizzly 
Hacking UI by Byte-Labs `bl_ui`
