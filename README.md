# Dungeon Escape

Dungeon Escape is an escape room and exploration experience set in a dark, eerie dungeon.
Explore its rooms, solve puzzles, overcome traps, and figure out how to progress while the environment itself tries to deceive you.
The dungeon is a pre-built world designed to offer a fixed experience: every playthrough takes place within the same complex of rooms and challenges.

## Features

- Hand-crafted and custom-designed dungeon. 
- Exploration and puzzle-solving. 
- Traps, mechanisms, and challenges that play with the environment's visual language. 
- Atmospheric music and sound effects. 
- Up to 3 game modes with varying difficulty levels. 
- Checkpoint and respawn system.

## Game Modes

Dungeon Escape includes 3 game modes with increasing difficulty:

1. Normal
2. Hardcore
3. Permadeath

| | Normal | Hardcore | Permadeath |
|--|--|--|--|
| Starting Health | 20 HP | 2 HP | 2 HP |
| Monster Damage | 100% | 150% | 200% |
| Regeneration | +0.25 HP/s | None | None |
| Checkpoints | Yes | No | No |
| On Death | Restart dungeon | Restart dungeon | Game Over |

### Normal

The standard Dungeon Escape experience.

### Hardcore

Lower health, more dangerous monsters, and no regeneration.

### Permadeath

A single chance. If you die, the game ends.

## Requirements

- Luanti 5.17.0 or later.
- No additional mods required.

## How to Play

Dungeon Escape includes an introductory tutorial that explains the controls and basic game mechanics.
Explore the rooms, observe your surroundings carefully, and look for clues to help you progress. Not everything is as it seems. ## Installation

Dungeon Escape can be installed directly from ContentDB using the Luanti content browser.
You can also download the game from its GitHub repository.

## Dependencies

Dungeon Escape does not require additional mods to run.

## For Curious people, Modders and Translators

The text displayed on in-game signs is managed in
`mods/dungeon_core/src/signs.lua`.

Each sign is identified by its world coordinates, and its text can have different language versions. Feel free to explore the file, translate the signs into your own language, or customize their messages.

To add a new language, add its translations to the sign catalog and update the language-selection helper in the same file so the game recognizes it.

Keep the original coordinates, formatting codes and line breaks intact unless you deliberately want to change the sign's layout.

## Credits and Licenses

Dungeon Escape is developed by **Arcashaft**.

Some of the original code was developed with assistance from generative AI tools:
- `custom_pointer`: development assistance from Google Gemini.
- `chat_blocker`, `dungeon_checkpoint`, `dungeon_core`, and `dungeon_mechanics`: development assistance from OpenAI ChatGPT.

The game also includes software, libraries, textures, fonts, music, and other assets created by third-party authors and projects.

The licenses and attributions for the original content and all third-party components included in Dungeon Escape are listed in [`LICENSES.md`](LICENSES.md).

The project also includes content from the Luanti engine. Luanti is free software licensed under the GNU Lesser General Public License v2.1 or later.

## Issues and Suggestions

Have you found a bug or do you have any suggestions to improve Dungeon Escape?
You can report them via the GitHub repository's issue tracker.

## Repository

[GitHub](https://github.com/arcashaft/dungeon-escape.git)
