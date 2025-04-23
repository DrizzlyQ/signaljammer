# 📡 QBX Signal Jammer Script

An immersive, optimized signal jammer script built for **QBX / QBCore** servers with modern systems like `ox_inventory`, `pma-voice`, `ox_lib`, and `bl_ui`.

---

## ✨ Features

- 🧠 Hacking UI using [bl_ui](https://github.com/Byte-Labs-Studio/bl_ui)
- 📡 Signal jamming in a configurable radius (default: 50 meters)
- 🔋 Battery-based lifetime (default: 10 minutes)
- 🔇 Disrupts both phone (`lb-phone`) and radio (`pma-voice`)
- 🔊 Native GTA 5 sound effects (looped interference & power-down)
- 💡 Blinking prop + proximity zone with `ox_lib`
- ⚠️ Fully protected against exploits (inventory check, cooldowns, logs)
- 📜 Discord webhook logging for placement and hacking attempts

---

## 🧩 Dependencies

- [QBX/QBCore Framework](https://github.com/qbcore-framework)
- [`ox_lib`](https://overextended.dev/)
- [`ox_inventory`](https://github.com/overextended/ox_inventory)
- [`pma-voice`](https://github.com/AvarianKnight/pma-voice)
- [`bl_ui`](https://github.com/Byte-Labs-Studio/bl_ui)
- [`lb-phone`](https://github.com/project-error/lb-phone)

---

## 🧠 Hacking System (bl_ui - LightsOut)

The player must complete a minigame to activate the jammer:

```lua
local success = exports.bl_ui:LightsOut(3, {
    level = 2,
    duration = 5000,
})
```

---

## ⚙️ Installation

1. Place the resource in your server's `resources/` folder.

2. Ensure dependencies in `server.cfg`:

```cfg
ensure ox_lib
ensure ox_inventory
ensure pma-voice
ensure bl_ui
ensure qbx_signaljammer
```

3. Add the item in `ox_inventory/data/items.lua`:

```lua
['signal_jammer'] = {
    label = 'Signal Jammer',
    weight = 500,
    stack = false,
    close = true,
    description = 'Disrupts radio and phone signals in the area.'
}
```

4. Configure `config.lua`:
```lua
Config.JammerRange = 50.0
Config.BatteryLife = 10
Config.HackCooldownSeconds = 30
Config.MaxHackFails = 3
```

5. Add your Discord webhook URL in `server.lua`:
```lua
local Webhook = "https://discord.com/api/webhooks/...."
```

---

## 🔊 Sounds

This script uses **native GTA sounds** — no need for `interact-sound`.

- Activation: `Crackle` from `DLC_HEISTS_BIOLAB_FINALE_SOUNDS`
- Power Down: `ERROR` from `HUD_AMMO_SHOP_SOUNDSET`

---

## 🧪 Admin Commands

Disable all active jammers:
```bash
/disablejammers
```

---

## 🧷 Anti-Abuse

- Item check with `ox_inventory` or QBCore
- Hacking cooldowns
- Radio force disconnect via `pma-voice`
- Phone close via `lb-phone`
- Webhook logs for all actions

---

## 👤 Credits

- Script & logic: Drizzly + ChatGPT
- Hacking UI: Byte Labs [`bl_ui`](https://github.com/Byte-Labs-Studio/bl_ui)
- Voice support: [`pma-voice`](https://github.com/AvarianKnight/pma-voice)

---

## 📘 License

MIT – Free to use, modify, and publish.
