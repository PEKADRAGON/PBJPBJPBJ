--  _//     _//_///////      _//       _////     _/////    _////////  _// //     --
--  _//     _//_//    _// _//   _//  _//    _//  _//   _// _//      _//    _//   --
--  _//     _//_//    _//_//       _//        _//_//    _//_//       _//         --
--  _//     _//_///////  _//       _//        _//_//    _//_//////     _//       --
--  _//     _//_//       _//       _//        _//_//    _//_//            _//    --
--  _//     _//_//        _//   _//  _//     _// _//   _// _//      _//    _//   --
--    _/////   _//          _////      _////     _/////    _////////  _// //     --
--                                                                               --
--     Discord: https://discord.com/invite/XRaMsVbUP2, Desenvolvedor: K4RLOW     --


configLicense = {
    ["User"] = "907433052391747655",
    ["Key"] = "12bd36754c03a013a7842a05e54c805a"
};

__GLOBAL = {

    interface = {

        quality = 'quality', -- performance, intermediary, quality

        default_settings = {

            view_in_vehicle = true, -- Ver minimapa apenas dentro do veiculo.



            key_close_bigmap = 'F11', -- Fechar mapa

            key_open_bigmap = 'F11', -- Abrir mapa

            key_mark_bigmap = 'enter', -- Tecla marcar no GPS



            key_preview_map = 'rshift', -- Tecla pre-visualização mapa



            minimap_style = '3D', -- 2d ou 3d.



            size = {w = 250, h = 270}, -- Tamanho

            radius = 5, -- Tamanho da borda minimapa

            zoom = 1.2, -- Zoom minimapa

            spacing = 35, -- Espaçamento minimapa



            water_color = tocolor(15, 15, 15, 200), -- tocolor(64, 152, 201, 200)

            border = {

                color = '#121213',

            },

            gps = {

                width = 4,

                stroke = '#C19F72', -- Cor da marcação -- #7680f5, #40C95F, #FF8100

            }

        },

        colors = {

            map = {

                background = '#121213', -- Cor do fundo do mapa

                edge_of_the_street = '#272627', -- Cor da borda ao redor da rua

                street = '#2E2D2E', -- Cor da Rua

                rural = '#2E2D2E', -- Cor da Zona Rural

                highlight = '#C19F72', -- Cor destaque subterraneo das ruas

                map_border = '#121213', -- Cor borda ao redor do mapa

                neighborhoods = '#FFFFFF', -- Cor dos nomes de bairro

            },

            fadeIn = {'#C19F72', '#C19F72'} -- Cores de destaque

        },

        mapBorderRadius = '2px', -- Borda ao redor do minimapa.



        filters = {

           {

               icon = 0,

               title = 'Ilegal',

               blip_ids = {19, 53, 51, 26, 16, 28, 38},

           },

           {

            icon = 0,

            title = 'Governo',

            blip_ids = {10, 22, 56, 55, 46},

        },

          -- {

          --     icon = 58,

          --     title = 'Comidas',

          --     blip_ids = {1, 2, 3, 4, 5, 6, 7, 8},

          -- },

          -- {

          --     icon = 58,

          --     title = 'Zona de risco',

          --     blip_ids = {1, 2, 3, 4, 5, 6, 7, 8},

          -- },

        },



        controls = {

            data = { -- Altera cores nos menus de controles e blips.

                posit = 'center',

                background = '#262526',

                sub_background = '#C19F72',

            },

            {

                title = 'F11',

                sub_text = 'Fechar'

            },

            {

                title = 'ENTER',

                sub_text = 'Marcar'

            },

            {

                title = '↑↓',

                sub_text = 'Navegar'

            },

            {

                title = 'SCROLL',

                sub_text = 'Zoom'

            },

        },



        locals_name = {

            neighborhoods = { -- Nome dos bairros

                ["Los Santos International"] = "Los Santos International",

                ["Bayside"] = "Bayside",

                ["Los Santos"] = "Rua da Esperança",

                ["Red County"] = "Red County",

                ["Las Venturas"] = "Las Venturas",

                ["San Fierro"] = "San Fierro",

                ["Tierra Robada"] = "Tierra Robada",

                ["Whitewood Estates"] = "Whitewood Estates",

                ["Bone County"] = "Bone County",

                ["Blackfield Chapel"] = "Blackfield Chapel",

                ["Flint County"] = "Flint County",

                ["Blackfield Intersection"] = "Blackfield Intersection",

                ["Whetstone"] = "Whetstone",

                ["Ocean Docks"] = "Ocean Docks",

                ["Royal Casino"] = "Royal Casino",

                ["Starfish Casino"] = "Starfish Casino",

                ["Mount Chiliad"] = "Mount Chiliad",

                ["Market"] = "Market",

                ["Shady Creeks"] = "Shady Creeks",

                ["El Quebrados"] = "El Quebrados",

                ["Missionary Hill"] = "Missionary Hill",

                ["Foster Valley"] = "Foster Valley",

                ["Easter Bay Airport"] = "Easter Bay Airport",

                ["Juniper Hill"] = "Juniper Hill",

                ["Santa Maria Beach"] = "Santa Maria Beach",

                ["City Hall"] = "City Hall",

                ["Blueberry"] = "Blueberry",

                ["El Corona"] = "El Corona",

                ["Blueberry Acres"] = "Blueberry Acres",

                ["Mulholland"] = "Mulholland",

                ["Back o Beyond"] = "Back o Beyond",

                ["Spinybed"] = "Spinybed",

                ["Paradiso"] = "Paradiso",

                ["El Castillo del Diablo"] = "El Castillo del Diablo",

                ["Marina"] = "Marina",

                ["LVA Freight Depot"] = "LVA Freight Depot",

                ["Julius Thruway East"] = "Julius Thruway East",

                ["Fern Ridge"] = "Fern Ridge",

                ["Fisher's Lagoon"] = "Fisher's Lagoon",

                ["The Emerald Isle"] = "The Emerald Isle",

                ["The Sherman Dam"] = "The Sherman Dam",

                ["Pilson Intersection"] = "Pilson Intersection",

                ["Calton Heights"] = "Calton Heights",

                ["Angel Pine"] = "Angel Pine",

                ["Restricted Area"] = "Restricted Area",

                ["Gant Bridge"] = "Gant Bridge",

                ["Blackfield"] = "Blackfield",

                ["Palisades"] = "Palisades",

                ["Las Colinas"] = "Las Colinas",

                ["Verdant Bluffs"] = "Verdant Bluffs",

                ["The Visage"] = "The Visage",

                ["Richman"] = "Richman",

                ["Prickle Pine"] = "Prickle Pine",

                ["Jefferson"] = "Jefferson",

                ["Bayside Tunnel"] = "Bayside Tunnel",

                ["San Fierro Bay"] = "San Fierro Bay",

                ["Downtown"] = "Downtown",

                ["Yellow Bell Station"] = "Yellow Bell Station",

                ["Esplanade North"] = "Esplanade North",

                ["Doherty"] = "Doherty",

                ["Temple"] = "Temple",

                ["Julius Thruway South"] = "Julius Thruway South",

                ["Fort Carson"] = "Fort Carson",

                ["Las Venturas Airport"] = "Las Venturas Airport",

                ["Verona Beach"] = "Verona Beach",

                ["Redsands West"] = "Redsands West",

                ["Lil' Probe Inn"] = "Lil' Probe Inn",

                ["Kincaid Bridge"] = "Kincaid Bridge",

                ["Harry Gold Parkway"] = "Harry Gold Parkway",

                ["The Strip"] = "The Strip",

                ["Easter Basin"] = "Easter Basin",

                ["Regular Tom"] = "Regular Tom",

                ["Sherman Reservoir"] = "Sherman Reservoir",

                ["Rodeo"] = "Rodeo",

                ["'The Big Ear'"] = "'The Big Ear'",

                ["Glen Park"] = "Glen Park",

                ["Pilgrim"] = "Pilgrim",

                ["Old Venturas Strip"] = "Old Venturas Strip",

                ["Financial"] = "Financial",

                ["Creek"] = "Creek",

                ["Linden Station"] = "Linden Station",

                ["Robada Intersection"] = "Robada Intersection",

                ["Commerce"] = "Commerce",

                ["Palomino Creek"] = "Palomino Creek",

                ["Last Dime Motel"] = "Last Dime Motel",

                ["Las Payasadas"] = "Las Payasadas",

                ["Hilltop Farm"] = "Hilltop Farm",

                ["East Beach"] = "East Beach",

                ["Hunter Quarry"] = "Hunter Quarry",

                ["Idlewood"] = "Idlewood",

                ["North Rock"] = "North Rock",

                ["Easter Bay Chemicals"] = "Easter Bay Chemicals",

                ["Greenglass College"] = "Greenglass College",

                ["Octane Springs"] = "Octane Springs",

                ["The Mako Span"] = "The Mako Span",

                ["Pirates in Men's Pants"] = "Pirates in Men's Pants",

                ["Avispa Country Club"] = "Avispa Country Club",

                ["Flint Intersection"] = "Flint Intersection",

                ["Ocean Flats"] = "Ocean Flats", 

                ["Flint Water"] = "Flint Water",

                ["Vinewood"] = "Vinewood",

                ["Santa Flora"] = "Santa Flora",

                ["Chinatown"] = "Chinatown",

                ["Downtown Los Santos"] = "Downtown Los Santos",

                ["Juniper Hollow"] = "Juniper Hollow",

                ["Hankypanky Point"] = "Hankypanky Point",

                ["Verdant Meadows"] = "Verdant Meadows",

                ["Caligula's Palace"] = "Caligula's Palace",

                ["The Panopticon"] = "The Panopticon",

                ["San Andreas Sound"] = "San Andreas Sound",

                ["Los Santos Inlet"] = "Los Santos Inlet",

                ["Come-A-Lot"] = "Come-A-Lot",

                ["Arco del Oeste"] = "Arco del Oeste",

                ["Garcia"] = "Garcia",

                ["Dillimore"] = "Dillimore",

                ["Garver Bridge"] = "Garver Bridge",

                ["Sobell Rail Yards"] = "Sobell Rail Yards",

                ["Flint Range"] = "Flint Range",

                ["Redsands East"] = "Redsands East",

                ["Montgomery Intersection"] = "Montgomery Intersection",

                ["Aldea Malvada"] = "Aldea Malvada",

                ["Willowfield"] = "Willowfield",

                ["Fallen Tree"] = "Fallen Tree",

                ["Las Brujas"] = "Las Brujas",

                ["The Pink Swan"] = "The Pink Swan",

                ["Leafy Hollow"] = "Leafy Hollow",

                ["Rockshore West"] = "Rockshore West",

                ["The Four Dragons Casino"] = "The Four Dragons Casino",

                ["Playa del Seville"] = "Playa del Seville",

                ["Easter Tunnel"] = "Easter Tunnel",

                ["East Los Santos"] = "East Los Santos",

                ["Julius Thruway North"] = "Julius Thruway North",

                ["Esplanade East"] = "Esplanade East",

                ["Conference Center"] = "Conference Center",

                ["Montgomery"] = "Montgomery",

                ["King's"] = "King's",

                ["The Camel's Toe"] = "The Camel's Toe",

                ["Rockshore East"] = "Rockshore East",

                ["Julius Thruway West"] = "Julius Thruway West",

                ["Roca Escalante"] = "Roca Escalante",

                ["The Farm"] = "The Farm",

                ["Pershing Square"] = "Pershing Square",

                ["Green Palms"] = "Green Palms",

                ["Queens"] = "Queens",

                ["Ganton"] = "Ganton",

                ["Yellow Bell Golf Course"] = "Yellow Bell Golf Course",

                ["Las Barrancas"] = "Las Barrancas",

                ["Randolph Industrial Estate"] = "Randolph Industrial Estate",

                ["The High Roller"] = "The High Roller",

                ["The Clown's Pocket"] = "The Clown's Pocket",

                ["Valle Ocultado"] = "Valle Ocultado",

                ["Battery Point"] = "Battery Point",

                ["Los Flores"] = "Los Flores",

                ["K.A.C.C. Military Fuels"] = "K.A.C.C. Military Fuels",

                ["Martin Bridge"] = "Martin Bridge",

                ["Cranberry Station"] = "Cranberry Station",

                ["Fallow Bridge"] = "Fallow Bridge",

                ["Linden Side"] = "Linden Side",

                ["Beacon Hill"] = "Beacon Hill",

                ["Hampton Barns"] = "Hampton Barns",

                ["Little Mexico"] = "Little Mexico",

                ["Hashbury"] = "Hashbury",

                ["Bayside Marina"] = "Bayside Marina",

                ["Frederick Bridge"] = "Frederick Bridge",

                ["Market Station"] = "Market Station",

                ["Shady Cabin"] = "Shady Cabin",

            }

        }

    },



    blip_settings = {

        type = 'game_default', -- 'game_default' blips defaults do jogo

        element = 'blipName', -- element data do nome do blip, caso utilize o type = 'element'

        blips_name = {

            [0] = 'Marcação',

            [1] = 'Quadrado branco',

            [2] = 'Você',

            [3] = 'Seta',

            [4] = 'Norte',

            [5] = 'Airdrop',

            [6] = 'Loja de Armas',

            [7] = 'Barbeiro',

            [8] = 'Venda seus Peixes',

            [9] = 'Airdrops',

            [10] = 'Ilha desconhecida',

            [11] = 'Minerador',

            [12] = 'Cidade do crime',

            [13] = 'Favela Livre',

            [14] = 'Restaurante',

            [15] = 'Prisão',

            [16] = 'Cracolândia',

            [17] = 'Loja',

            [18] = 'Disparos',

            [19] = 'Área de Risco',

            [20] = 'Assalto Recente',

            [21] = 'Coração',

            [22] = 'Hospital',

            [23] = 'Prefeitura',

            [24] = 'Patio/Auto-Escola',

            [25] = 'Cassino',

            [26] = 'Vender joias',

            [27] = 'Oficina',

            [28] = 'Joalheria',

            [29] = 'Lanchonete',

            [30] = 'Delegacia',

            [31] = 'Casa Disponível',

            [32] = 'Casa Ocupada',

            [33] = 'Corrida',

            [34] = 'Lotérica',

            [35] = 'Dominação',

            [36] = 'Lixeiras',

            [37] = 'Alerta Incêndio',

            [38] = 'Mercado negro',

            [39] = 'Tatuador',

            [40] = 'Agencia de empregos.',

            [41] = 'Marcação',

            [42] = 'Trabalho',

            [43] = 'Boate',

            [44] = 'Mansão Vilas',

            [45] = 'Loja de Roupas',

            [46] = 'Garagem',

            [47] = 'Caixa Assaltado',

            [48] = 'Denuncia',

            [49] = 'Boate/Bar',

            [50] = 'Restaurante',

            [51] = 'Carro-Forte',

            [52] = 'Caixa-Eletrônico',

            [53] = 'Corrida Ilegal',

            [54] = 'Academia',

            [55] = 'Concessionária',

            [56] = 'Posto de Gasolina',

            [57] = 'Pedagio',

            [58] = 'Praça',

            [59] = 'Desmanche',

            [60] = 'Loja de acessorios',

            [61] = 'Dinheiro Sujo',

            [62] = 'Utilidades',

            [63] = 'Reparo de veículos',

            [64] = 'Ilha desconhecida',

        }

    },



    messages = {

        client = {

            invalid_route = function()

                local player = localPlayer

                return --iprint( 'Não é possivel marcar nesta localização '..getPlayerName(player) )

            end,

            end_route = function()

                local player = localPlayer

                return --iprint( 'Você chegou a sua rota '..getPlayerName(player) )

            end,

        },

        server = {

            sucessfull_save_data = function(element)

                local player = localPlayer

                return --iprint( 'Suas informações foram salvas com sucesso!'..getPlayerName(element) )

            end,

        }

    },



    executes = {

        open_bigmap = function()

            showChat(false)

            setElementData(localPlayer, 'bloqInterface', true)

        end,

        close_bigmap = function()

            showChat(true)

            setElementData(localPlayer, 'bloqInterface', false)

        end,

    }

}