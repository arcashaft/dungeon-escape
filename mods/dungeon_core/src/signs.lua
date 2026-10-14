-- =========================================================
-- MODULO: dungeon_core / signs
-- Gestiona la restauración de carteles de signs_lib.
-- =========================================================

local M = {}


-- =========================================================
-- CATÁLOGO DE TEXTOS PARA SEÑALES
-- Las coordenadas utilizan posiciones globales.
-- =========================================================


-- =========================================================
-- FOR CURIOUS EXPLORERS, MODDERS AND TRANSLATORS
--
-- In-game sign texts are catalogued below, using world
-- coordinates to identify each sign.
--
-- To translate a sign, add the corresponding language entry
-- to sign_texts. To support a new language, also update
-- get_player_language() so the language can be detected.
--
-- Preserve formatting codes and line breaks where possible.
-- Changes to sign text do not require re-exporting the map.
--
-- Have fun exploring the code!
-- =========================================================


-- Text is stored in the map, but signs_lib does not translate it.
-- Each entry overrides the sign text for English and Spanish.
-- Coordinates are global world coordinates: "x,y,z".
-- Keep # color codes, ^ arrow codes, and intentional line breaks.
local sign_texts = {
    -- 01. (-74,-79,-110)
    ["-74,-79,-110"] = {
        text = {
            en = "\n\nHow's it going?",
            es = "\n\n¿Qué tal?",
        },
    },
    -- 02. (-73,-79,-107)
    ["-73,-79,-107"] = {
        text = {
            en = "\n\nOpen your eyes",
            es = "\n\nAbre los ojos",
        },
    },
    -- 03. (-73,-79,-99)
    ["-73,-79,-99"] = {
        text = { both = "\n\nNo" },
    },
    -- 04. (-73,-79,-81)
    ["-73,-79,-81"] = {
        text = {
            en = "\n\nNot this way",
            es = "\n\nPor aquí no",
        },
    },
    -- 05. (-72,-168,-123)
    ["-72,-168,-123"] = {
        text = { both = "\n\n+ 1" },
    },
    -- 06. (-72,-168,-121)
    ["-72,-168,-121"] = {
        text = { both = "\n\n+ 4" },
    },
    -- 07. (-72,-168,-119)
    ["-72,-168,-119"] = {
        text = { both = "\n\n+ 16" },
    },
    -- 08. (-72,-168,-113)
    ["-72,-168,-113"] = {
        text = {
            en = "\n\n#bIce#0: 8",
            es = "\n\n#bHielo#0: 8",
        },
    },
    -- 09. (-72,-168,-111)
    ["-72,-168,-111"] = {
        text = {
            en = "\n\n#9Water#0: 10",
            es = "\n\n#9Agua#0: 10",
        },
    },
    -- 10. (-71,-166,-112)
    ["-71,-166,-112"] = {
        text = {
            en = "\n\n#8Silver#0: 77",
            es = "\n\n#8Plata#0: 77",
        },
    },
    -- 11. (-70,-170,-114)
    ["-70,-170,-114"] = {
        text = { both = "\n\n#62" },
    },
    -- 12. (-70,-170,-112)
    ["-70,-170,-112"] = {
        text = { both = "\n\n#b2" },
    },
    -- 13. (-69,-166,-112)
    ["-69,-166,-112"] = {
        text = {
            en = "\n\n#eGold#0: 88",
            es = "\n\n#eOro#0: 88",
        },
    },
    -- 14. (-69,-79,-75)
    ["-69,-79,-75"] = {
        text = {
            en = "\n\nNot this way either",
            es = "\n\nPor aquí tampoco",
        },
    },
    -- 15. (-68,-170,-114)
    ["-68,-170,-114"] = {
        text = { both = "\n\n#e?" },
    },
    -- 16. (-68,-170,-112)
    ["-68,-170,-112"] = {
        text = { both = "\n\n#41" },
    },
    -- 17. (-68,-79,-58)
    ["-68,-79,-58"] = {
        text = {
            en = "\n\nTry again",
            es = "\n\nInténtalo de nuevo",
        },
    },
    -- 18. (-67,-166,-112)
    ["-67,-166,-112"] = {
        text = {
            en = "\n\n#6Bronze#0: 66",
            es = "\n\n#6Bronce#0: 66",
        },
    },
    -- 19. (-66,-170,-113)
    ["-66,-170,-113"] = {
        text = {
            en = "#6SOLUTION\n-------------------\n#4Multiply#0 the\nresults and\n#eactivate#0 the\nmatching levers",
            es = "#6SOLUCIÓN\n-------------------\n#4Multiplica#0 los\nresultados y\n#eactiva#0 las palancas\ncorrespondientes",
        },
    },
    -- 20. (-66,-168,-113)
    ["-66,-168,-113"] = {
        text = {
            en = "\n\n#6Wood#0: 13",
            es = "\n\n#6Madera#0: 13",
        },
    },
    -- 21. (-66,-168,-111)
    ["-66,-168,-111"] = {
        text = {
            en = "\n\n#4Apple#0: 9",
            es = "\n\n#4Manzana#0: 9",
        },
    },
    -- 22. (-66,-79,-98)
    ["-66,-79,-98"] = {
        text = {
            en = "\n\nAre you messing with me?",
            es = "\n\nMe estás vacilando",
        },
    },
    -- 23. (-65,-149,-114)
    ["-65,-149,-114"] = {
        text = {
            en = "\nNow you're\n#4trapped\nhere with me\n\n^e",
            es = "\nAhora estás\n#4atrapado\naquí conmigo\n\n^e",
        },
    },
    -- 24. (-65,-148,-114)
    ["-65,-148,-114"] = {
        text = {
            en = "\nThat's why I've\nforbidden you to jump\nfrom now on\n\n^e",
            es = "\nPor eso te he\nprohibido saltar\na partir de ahora\n\n^e",
        },
    },
    -- 25. (-65,-147,-114)
    ["-65,-147,-114"] = {
        text = {
            en = "Nice jump!\n\nSeriously,\nget that checked out\n\n^e",
            es = "¡Buen salto!\n\nEn serio,\nháztelo mirar\n\n^e",
        },
    },
    -- 26. (-64,-193,-199)
    ["-64,-193,-199"] = {
        text = {
            en = "\nPart 2\n\nComing soon...",
            es = "\nParte 2\n\nPróximamente...",
        },
    },
    -- 27. (-64,-170,-113)
    ["-64,-170,-113"] = {
        text = {
            en = "#6SOLUTION\n-------------------\n#4Multiply#0 the\nresults and\n#eactivate#0 the\nmatching levers",
            es = "#6SOLUCIÓN\n-------------------\n#4Multiplica#0 los\nresultados y\n#eactiva#0 las palancas\ncorrespondientes",
        },
    },
    -- 28. (-63,-170,-113)
    ["-63,-170,-113"] = {
        text = {
            en = "#41\n\nThe bomb is in\nthis box",
            es = "#41\n\nLa bomba está en\nesta caja",
        },
    },
    -- 29. (-61,-170,-113)
    ["-61,-170,-113"] = {
        text = {
            en = "#82\n\nThe bomb is not\nin box 1",
            es = "#82\n\nLa bomba no está\nen la caja 1",
        },
    },
    -- 30. (-61,-166,-112)
    ["-61,-166,-112"] = {
        text = {
            en = "#6WARNING\n-------------------\n2 of the signs\n#4are lying\n1 tells the\n#8truth",
            es = "#6ADVERTENCIA\n-------------------\n2 de los carteles\n#4mienten\n1 dice la\n#8verdad",
        },
    },
    -- 31. (-61,-79,-53)
    ["-61,-79,-53"] = {
        text = {
            en = "\nSorry,\ndo we know each other?",
            es = "\nPerdona,\n¿nos conocemos?",
        },
    },
    -- 32. (-59,-170,-113)
    ["-59,-170,-113"] = {
        text = {
            en = "#13\n\nThe bomb is not\nhere",
            es = "#13\n\nLa bomba no está\naquí",
        },
    },
    -- 33. (-58,-168,-123)
    ["-58,-168,-123"] = {
        text = { both = "\n\n+ 2" },
    },
    -- 34. (-58,-168,-121)
    ["-58,-168,-121"] = {
        text = { both = "\n\n+ 8" },
    },
    -- 35. (-58,-168,-119)
    ["-58,-168,-119"] = {
        text = { both = "\n\n+ 32" },
    },
    -- 36. (-58,-79,-54)
    ["-58,-79,-54"] = {
        text = { both = "\n\nNo" },
    },
    -- 37. (-53,-79,-105)
    ["-53,-79,-105"] = {
        text = {
            en = "\n\nYou're almost there",
            es = "\n\nTe queda poco",
        },
    },
    -- 38. (-53,-79,-65)
    ["-53,-79,-65"] = {
        text = {
            en = "\n\nHello there",
            es = "\n\nHola buenas",
        },
    },
    -- 39. (-52,-79,-94)
    ["-52,-79,-94"] = {
        text = {
            en = "\n\nNot here",
            es = "\n\nAquí no",
        },
    },
    -- 40. (-49,-79,-81)
    ["-49,-79,-81"] = {
        text = {
            en = "\n\nAlmost there",
            es = "\n\nCasi lo tienes",
        },
    },
    -- 41. (-48,-79,-62)
    ["-48,-79,-62"] = {
        text = {
            en = "\n\nNot here",
            es = "\n\nAquí no",
        },
    },
    -- 42. (-42,-79,-90)
    ["-42,-79,-90"] = {
        text = {
            en = "\n\nGood afternoon",
            es = "\n\nBuenas tardes",
        },
    },
    -- 43. (-42,-79,-50)
    ["-42,-79,-50"] = {
        text = {
            en = "\n\nThis isn't the way",
            es = "\n\nPor aquí no es",
        },
    },
    -- 44. (-41,-79,-111)
    ["-41,-79,-111"] = {
        text = {
            en = "\n\nNope.",
            es = "\n\nNoup.",
        },
    },
    -- 45. (-40,-79,-102)
    ["-40,-79,-102"] = {
        text = {
            en = "\n\nAlmost",
            es = "\n\nCasi",
        },
    },
    -- 46. (-34,-79,-110)
    ["-34,-79,-110"] = {
        text = {
            en = "\n\nNuh-uh.",
            es = "\n\nNopi",
        },
    },
    -- 47. (-26,-79,-58)
    ["-26,-79,-58"] = {
        text = {
            en = "\n\nNot here",
            es = "\n\nAquí no",
        },
    },
    -- 48. (-13,-79,-79)
    ["-13,-79,-79"] = {
        text = {
            en = "\n\nWhat are you looking at?",
            es = "\n\n¿Qué miras?",
        },
    },
    -- 49. (-6,-13,30)
    ["-6,-13,30"] = {
        text = {
            en = "How did you get\nall the way here?\n\nHere's your\nreward:\n^e",
            es = "¿Cómo lograste\nllegar hasta aquí?\n\nHe aquí tu\nrecompensa:\n^e",
        },
    },
    -- 50. (0,-95,-7)
    ["0,-95,-7"] = {
        text = {
            en = "#eATTENTION\n---------------------\n^g Key\nDoor ^c",
            es = "#eATENCIÓN\n---------------------\n^g Llave\nPuerta ^c",
        },
    },
    -- 51. (0,-76,-43)
    ["0,-76,-43"] = {
        text = {
            en = "#4CAUTION!\n---------------------\nLearn from your\nmistakes",
            es = "#4¡CUIDADO!\n---------------------\nAprende de tus\nerrores",
        },
    },
    -- 52. (101,202,147)
    ["101,202,147"] = {
        text = {
            en = "Movement:\n     - Use W, A, S, D to move in all directions.\n     - Spacebar to jump or climb stairs.\n     - Press E to sprint.\n     - Left Shift to crouch. It lets you move slowly and avoid falling off edges.\n\nInteraction:\n     - Left mouse button to hit or attack.\n     - Right mouse button to use things like chests and furnaces.\n     - Mouse wheel to change the item in your hand.\n\nPress Esc to leave the game.\n\n\nIMPORTANT:\nGet into a comfortable, ergonomic position before playing.",
            es = "Movimiento:\n     - Teclas W, A, S, D para moverte en todas las direcciones.\n     - Barra espaciadora para saltar o subir escaleras.\n     - Tecla E para correr.\n     - Tecla Shift izquierdo para agacharse. Sirve para ir despacio y no caerse de los bordes.\n\nInteracción:\n     - Click izquierdo para golpear o atacar.\n     - Click derecho para usar cosas como cofres y hornos.\n     - Rueda del ratón para cambiar de objeto en tu mano.\n\nTecla Esc para salir del juego.\n\n\nIMPORTANTE:\nColócate en una postura cómoda y ergonómica para jugar.",
        },
        display_text = {
            en = "Controls",
            es = "Controles",
        },
    },
    -- 53. (101,203,145)
    ["101,203,145"] = {
        text = {
            en = "\nI know how to play\n\n^e",
            es = "\nYa sé jugar\n\n^e",
        },
    },
    -- 54. (103,201,120)
    ["103,201,120"] = {
        text = {
            en = "\n\nRun!",
            es = "\n\n¡Corre!",
        },
    },
    -- 55. (103,201,141)
    ["103,201,141"] = {
        text = {
            en = "\nTry\nthese platforms",
            es = "\nPrueba\nestas plataformas",
        },
    },
    -- 56. (103,202,149)
    ["103,202,149"] = {
        text = {
            en = "Welcome\nto the tutorial\n\nRight-click the posters\nto read them",
            es = "Bienvenid@\nal tutorial\n\nHaz click derecho\nen los pósters\npara leerlos",
        },
    },
    -- 57. (107,203,138)
    ["107,203,138"] = {
        text = {
            en = "To avoid overshooting\nsome jumps,\npress Left Shift\nbefore landing",
            es = "Para no pasarte\nen algunos saltos,\npulsa Shift izq.\nantes de caer",
        },
    },
    -- 58. (109,201,129)
    ["109,201,129"] = {
        text = {
            en = "^a\n\nThis is a chest",
            es = "^a\n\nEsto es un cofre",
        },
    },
    -- 59. (109,202,134)
    ["109,202,134"] = {
        text = {
            en = "Inside a\nchest, there may be\nitems\n\nOpen this chest",
            es = "Dentro de un\ncofre puede haber\ncosas\n\nAbre este cofre",
        },
    },
    -- 60. (116,202,138)
    ["116,202,138"] = {
        text = {
            en = "Sprint with E to\njump farther",
            es = "Corre con E para\nllegar más lejos",
        },
    },
    -- 61. (122,202,102)
    ["122,202,102"] = {
        text = {
            en = "Press the button\nto leave the\ntutorial\n\n^c",
            es = "Pulsa en el botón\npara salir del\ntutorial\n\n^c",
        },
    },
    -- 62. (122,202,104)
    ["122,202,104"] = {
        text = {
            en = "Press the button\nto leave the\ntutorial\n\n^g",
            es = "Pulsa en el botón\npara salir del\ntutorial\n\n^g",
        },
    },
    -- 63. (122,203,103)
    ["122,203,103"] = {
        text = {
            en = "\"A dead-end path,\n\nthat leads to a new path\"",
            es = "\"Un camino sin salida,\n\nque da salida a un nuevo camino\"",
        },
    },
    -- 64. (126,201,132)
    ["126,201,132"] = {
        text = {
            en = "\nA torch\ncan be very\nuseful in some\nsituations",
            es = "\nUna antorcha\npuede ser muy\nútil en algunos\ncasos",
        },
    },
    -- 65. (129,201,144)
    ["129,201,144"] = {
        text = {
            en = "^a\n\nThis is a door",
            es = "^a\n\nEsto es una puerta",
        },
    },
    -- 66. (135,203,144)
    ["135,203,144"] = {
        text = {
            en = "\nOpen this door\n\n^e",
            es = "\nAbre esta puerta\n\n^e",
        },
    },
    -- 67. (142,202,101)
    ["142,202,101"] = {
        text = {
            en = "Press the button\nto spawn a\nmonster\n\n^c",
            es = "Pulsa el botón\npara que aparezca\nun monstruo\n\n^c",
        },
    },
    -- 68. (145,202,101)
    ["145,202,101"] = {
        text = {
            en = "Pick up a sword\nand try fighting\nthe monsters\n\n^e",
            es = "Coge una espada\ny prueba a luchar\ncontra los\nmonstruos\n\n^e",
        },
    },
    -- 69. (146,202,124)
    ["146,202,124"] = {
        text = {
            en = "\n\nTry again ^c",
            es = "\n\nReinténtalo ^c",
        },
    },
    -- 70. (148,201,110)
    ["148,201,110"] = {
        text = {
            en = "\nIf you step on this material, you won't be able to jump.\n\nHowever, it will protect you from falls from great heights.",
            es = "\nSi pisas este material no podrás saltar.\n\nEn cambio, te protegerá de caídas a grandes alturas.",
        },
        display_text = {
            en = "Spores",
            es = "Esporas",
        },
    },
    -- 71. (148,201,134)
    ["148,201,134"] = {
        text = {
            en = "^a\n\nThis is\na ladder",
            es = "^a\n\nEsto es\nuna escalera",
        },
    },
    -- 72. (148,203,117)
    ["148,203,117"] = {
        text = {
            en = "If you jump over this,\nyou'll hit the ceiling.\n\nStick to the wall\nand use the stairs",
            es = "Si saltas esto te\nchocas por arriba\n\nPégate a la pared\ny usa las escaleras",
        },
    },
    -- 73. (148,203,123)
    ["148,203,123"] = {
        text = {
            en = "Because there's only\na #e1-block gap",
            es = "Porque solo hay\ndistancia de\n#e1 bloque",
        },
    },
    -- 74. (148,203,125)
    ["148,203,125"] = {
        text = {
            en = "\nYou can cross this\npath without jumping",
            es = "\nPuedes pasar este\ncamino sin saltar",
        },
    },
    -- 75. (148,204,114)
    ["148,204,114"] = {
        text = {
            en = "\nGo down the stairs\n\n^e",
            es = "\nBaja las escaleras\n\n^e",
        },
    },
    -- 76. (149,202,146)
    ["149,202,146"] = {
        text = {
            en = "Open it with the key\n\n^e",
            es = "Ábrela con la llave\n\n^e",
        },
    },
    -- 77. (150,201,136)
    ["150,201,136"] = {
        text = {
            en = "\nTry jumping from this block to the one in front.\n\nIt may seem impossible on your first try.\n\nBut here's a trick to make it every time:\n     - Jump with Spacebar, W (forward), and E (sprint) at the same time.\n     - When you're almost there, hold Shift without releasing the other keys to land safely on the platform.\n\nShift helps you stick to blocks, but it can also slow you down a little.\n\nIt's a slightly tricky move, but you won't miss these jumps.",
            es = "\nIntenta saltar de este bloque hacia el que está en frente.\n\nParece imposible hacerlo a la primera.\n\nPero un truco para nunca fallar:\n     - Salta con la barra espaciadora, W (hacia adelante) y E (correr) a la vez\n     - Y cuando ya casi llegues, pulsa Shift (sin soltar las demás teclas) y mantenlo para entrar 100% seguro en la plataforma\n\nLa tecla Shift te ayuda a pegarte a los bloques pero, también te puede frenar un poco.\n\nEs una maniobra ligeramente complicada, pero nunca fallarás estos saltos.",
        },
        display_text = {
            en = "Risky jumps",
            es = "Saltos arriesgados",
        },
    },
    -- 78. (150,202,144)
    ["150,202,144"] = {
        text = {
            en = "You won't be able to open\nevery door so easily",
            es = "No podrás abrir\ntodas las puertas\ntan fácilmente",
        },
    },
}


local function position_key(pos)
    return string.format(
        "%d,%d,%d",
        pos.x,
        pos.y,
        pos.z
    )
end


local function get_player_language(player_name)
    local info =
        minetest.get_player_information(player_name)

    local lang_code =
        info and info.lang_code or "en"

    if type(lang_code) == "string"
        and lang_code:lower():match("^es")
    then
        return "es"
    end

    return "en"
end


local function get_sign_text(texts, language)
    if not texts then
        return nil
    end

    if texts.both then
        return texts.both
    end

    if language == "es" then
        return texts.es
            or texts.en
            or ""
    end

    return texts.en
        or texts.es
        or ""
end


function M.setup(ctx)
    ctx.sign_language = "en"

    local function restore_signs_in_mapblock(mapblock)

        if not minetest.get_modpath("signs_lib")
            or not signs_lib
            or not signs_lib.update_sign
            or not signs_lib.delete_objects
        then
            return 0
        end

        local pos1, pos2 =
            mapblock_lib.get_mapblock_bounds_from_mapblock(
                mapblock
            )

        local signs =
            minetest.find_nodes_in_area(
                pos1,
                pos2,
                {"group:sign"}
            )

        local total_signs = 0

        for _, pos in ipairs(signs) do

            local node =
                minetest.get_node(pos)

            local node_def =
                minetest.registered_items[node.name]

            if node_def and node_def.entity_info then

                -- Encuentra la traducción para este puesto.
                local definition =
                    sign_texts[position_key(pos)]

                if definition then

                    local meta = minetest.get_meta(pos)

                    -- Main sign/poster text.
                    local text =
                        get_sign_text(
                            definition.text,
                            ctx.sign_language
                        )

                    if text ~= nil then
                        meta:set_string("text", text)
                    end

                    -- Some posters have a separate visible title.
                    local display_text =
                        get_sign_text(
                            definition.display_text,
                            ctx.sign_language
                        )

                    if display_text ~= nil then
                        meta:set_string(
                            "display_text",
                            display_text
                        )
                    end

                end

                -- Regenerar la entidad de texto signs_lib.
                signs_lib.delete_objects(pos)

                signs_lib.update_sign(pos)

                total_signs =
                    total_signs + 1

            end

        end

        return total_signs

    end

    local function restore_all_signs()

        if not minetest.get_modpath("signs_lib") then
            return
        end

        if not signs_lib
            or not signs_lib.update_sign
            or not signs_lib.delete_objects
        then
            minetest.log(
                "warning",
                "[dungeon_core] The signs_lib API "
                .. "was not found."
            )
            return
        end

        local total_signs = 0

        for _, mapblock in pairs(
            ctx.generated_mapblocks
        ) do

            total_signs =
                total_signs
                + restore_signs_in_mapblock(mapblock)

        end

        minetest.log(
            "action",
            "[dungeon_core] Restored "
            .. total_signs
            .. " signs_lib signs."
        )

    end


    -- Hacemos accesible la función para reset.lua.

    ctx.restore_all_signs =
        restore_all_signs

    ctx.restore_signs_in_mapblock =
        restore_signs_in_mapblock


    minetest.register_on_joinplayer(
        function(player)

            local player_name =
                player:get_player_name()

            minetest.after(
                0.5,
                function()

                    if not minetest.get_player_by_name(
                        player_name
                    ) then
                        return
                    end

                    ctx.sign_language =
                        get_player_language(
                            player_name
                        )

                    restore_all_signs()

                end
            )

        end
    )

    return ctx

end


return M
