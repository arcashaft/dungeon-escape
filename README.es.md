# Dungeon Escape

Dungeon Escape es una experiencia de _escape room_ y exploración ambientada en una tenebrosa mazmorra.
Explora sus salas, resuelve acertijos, supera trampas y descubre cómo avanzar mientras el propio entorno intenta engañarte.
La mazmorra es un mundo prefabricado y diseñado para ofrecer una experiencia fija: cada partida transcurre en el mismo complejo de salas y desafíos.

## Características

 - Mazmorra fabricada y diseñada a mano.
 - Exploración y resolución de acertijos.
 - Trampas, mecanismos y desafíos que juegan con el lenguaje visual del entorno.
 - Música y sonidos ambientales.
 - Hasta 3 modos de juego con distinta dificultad.
 - Sistema de checkpoints y puntos de reaparición.

## Modos de juego

Dungeon Escape viene con 3 modos de juego incluidos para aumentar la dificultad:

 1. Normal
 2. Hardcore
 3. Permadeath

|  | Normal | Hardcore | Permadeath |
|--|--|--|--|
| Vida inicial | 20 HP | 2 HP | 2 HP |
| Daño de los monstruos | 100 % | 150 % | 200 % |
| Regeneración | +0,25 HP/s | No | No |
| Checkpoints | Sí | No | No |
| Al morir | Reinicias el dungeon | Reinicias el dungeon | Fin de la partida |

### Normal

La experiencia estándar de Dungeon Escape.

### Hardcore

Menos vida, monstruos más peligrosos y sin regeneración.

### Permadeath

Una única oportunidad. Si mueres, la partida termina.

## Requisitos

- Luanti 5.17.0 o posterior.
- No requiere instalar mods adicionales.

## Cómo jugar

Dungeon Escape incluye un tutorial inicial que explica los controles y las mecánicas básicas del juego.
Explora las salas, observa cuidadosamente tu entorno y busca pistas que te permitan avanzar. No todo es lo que parece.

## Instalación

Dungeon Escape puede instalarse directamente desde ContentDB mediante el navegador de contenido de Luanti.
También puedes descargar el juego desde su repositorio de GitHub.

## Dependencias

Dungeon Escape no requiere mods adicionales para funcionar.

## Para curiosos, _modders_ y traductores

El texto que aparece en los letreros del juego se gestiona en
`mods/dungeon_core/src/signs.lua`.

Cada letrero se identifica por sus coordenadas en el mundo, y su texto puede tener versiones en distintos idiomas. Siéntete libre de explorar el archivo, traducir los letreros a tu idioma o personalizar sus mensajes.

Para añadir un nuevo idioma, incorpora sus traducciones al catálogo de letreros y actualiza la función de selección de idioma en el mismo archivo para que el juego lo reconozca.

Mantén intactas las coordenadas originales, los códigos de formato y los saltos de línea, a menos que quieras cambiar deliberadamente la disposición del letrero.

## Créditos y licencias

Dungeon Escape ha sido desarrollado por **Arcashaft**.

Parte del código original se desarrolló con la ayuda de herramientas de IA generativa:
- `custom_pointer`: asistencia en el desarrollo mediante Google Gemini.
- `chat_blocker`, `dungeon_checkpoint`, `dungeon_core` y `dungeon_mechanics`: asistencia en el desarrollo mediante OpenAI ChatGPT.

El juego también incluye software, bibliotecas, texturas, fuentes, música y otros recursos creados por autores y proyectos de terceros.

Las licencias y atribuciones del contenido original y de todos los componentes de terceros incluidos en Dungeon Escape se detallan en [`LICENSES.md`](LICENSES.md).

El proyecto también incluye contenido del motor Luanti. Luanti es software libre bajo la licencia GNU Lesser General Public License v2.1 o posterior.

## Problemas y sugerencias

¿Has encontrado un error o tienes alguna sugerencia para mejorar Dungeon Escape?
Puedes comunicarlo mediante los problemas del repositorio de GitHub.

## Repositorio

[GitHub](AQUÍ_PONDREMOS_LA_URL)
