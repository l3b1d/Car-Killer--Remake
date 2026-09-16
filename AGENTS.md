# AGENTS.md

This project is a compact Godot 4.7 survival-horror chase game called Car Killer: Remake. The core loop is simple and intentional: the player moves through a night map, the killer car pursues them, the player damages and slows it with a shotgun, and the player survives until reaching the safe zone at the end of the route.

The goal is not to turn this into a generic FPS or a large RPG. Preserve the chase-focused gameplay loop and keep the killer car as the central threat.

## Core game design constraints

- The killer car is the main antagonist and should remain the central gameplay pressure.
- The player is not a super soldier; the gameplay should reward distance, positioning, timing, movement, and controlling the car's speed.
- The shotgun is primarily a tool for damaging and slowing the killer car; it should not become a generic all-purpose weapon system.
- The map is a compact, linear route with a start area, pursuit phase, and safe finish zone.
- Victory is reaching the end of the route / safe area; defeat is being caught by the killer car.
- The visual tone should stay moody, night-time, isolated, and stylized / low-poly / indie rather than military-shooter realism.
- Do not add broad systems such as inventory, crafting, multiple weapon classes, deep RPG progression, quest systems, multiplayer, or open-world expansion unless the author explicitly asks for them.

## Architecture and gameplay conventions

Follow the existing structure instead of introducing new subsystems:

- The main world orchestration lives in scripts/base_game.gd and is responsible for HUD, pause state, death state, timer, and finish-zone flow.
- Player logic is split into focused components under scripts/player/, such as health, stamina, movement, and stats signals.
- Enemy logic lives under scripts/enemies/ and the killer car uses a component-style structure, with movement and contact damage separated from the root node.
- Weapon logic lives under scripts/weapons/ and the shotgun is built as a compact gameplay tool that exposes ammo and reload state through signals.
- The finish zone is a gameplay trigger, not an arbitrary scene object; it emits a level_completed signal that is handled by the base game loop.
- Keep changes minimal and consistent with the existing component approach. Prefer fixing or extending a current system instead of replacing it with a new framework.

## Required naming convention

Use snake_case for all custom identifiers, including:

- script files and scene files
- folder names
- variables and properties
- function names and methods
- parameters and local variables
- signals and signal handlers
- exported values and node references
- custom resource names and scene paths

Examples:

- good: player_health, shotgun_firing, max_stamina, _on_health_changed
- bad: playerHealth, shotgunFiring, maxStamina, _onHealthChanged

## Project-specific rules

- Prefer lowercase words separated by underscores.
- Do not introduce CamelCase or PascalCase in new code.
- Use snake_case even for acronyms when they are part of a custom identifier, for example: ui_menu, ammo_count, hit_reaction.
- Keep Godot engine-required names and built-in property names as they are when a specific API requires them.
- When creating new scenes or scripts, name them in snake_case and keep the file names descriptive and consistent with the existing project structure.
- If a file or symbol already exists with a naming pattern, follow that pattern rather than inventing a different convention.
- For gameplay changes, first inspect the related script and scene together. Do not rewrite the system or redesign the game without a clear reason.
- Preserve current behavior unless the task explicitly requires a change.
- Keep the gameplay loop focused on chase, distance, and survival.

## Editing rules for AI agents

Before finishing work, confirm that:

- no new identifiers use CamelCase
- file and folder names remain snake_case
- signal names, methods, and variables follow the existing repository convention
- the change fits the chase-survival loop instead of turning the project into a different genre
- the fix is minimal and respects current architecture
- no duplicate managers, systems, or gameplay layers were introduced unnecessarily

If you are unsure about a name or system boundary, match the style used in the nearest script or scene in the same domain instead of inventing a new pattern.

## Tooling and validation guidance

- Target Godot 4.7 features and project structure already defined in project.godot.
- Prefer incremental scene/script validation in the editor rather than broad refactors.
- If a change affects gameplay flow, verify the player, the killer car, and the finish trigger still work together.
- Keep scripts readable and deterministic; avoid overengineering simple mechanics.

This project is intentionally simple, focused, and compact. AI should act as an implementation assistant for the author's gameplay ideas rather than redesigning the game from a generic "best practice" angle.
