--[[

    ___      ___ ___  ________  ___  ________  ________           ________  ________  ________  _______   ________      
    |\  \    /  /|\  \|\   ____\|\  \|\   __  \|\   ___  \        |\   ____\|\   __  \|\   ___ \|\  ___ \ |\   ____\     
    \ \  \  /  / | \  \ \  \___|\ \  \ \  \|\  \ \  \\ \  \       \ \  \___|\ \  \|\  \ \  \_|\ \ \   __/|\ \  \___|_    
     \ \  \/  / / \ \  \ \_____  \ \  \ \  \\\  \ \  \\ \  \       \ \  \    \ \  \\\  \ \  \ \\ \ \  \_|/_\ \_____  \   
      \ \    / /   \ \  \|____|\  \ \  \ \  \\\  \ \  \\ \  \       \ \  \____\ \  \\\  \ \  \_\\ \ \  \_|\ \|____|\  \  
       \ \__/ /     \ \__\____\_\  \ \__\ \_______\ \__\\ \__\       \ \_______\ \_______\ \_______\ \_______\____\_\  \ 
        \|__|/       \|__|\_________\|__|\|_______|\|__| \|__|        \|_______|\|_______|\|_______|\|_______|\_________\
                     \|_________|                                                                        \|_________|

    Script desenvolvido por: guh.dev 
    Desing desenvolvido por: matteo.ui
    Acesse nossa loja: https://discord.gg/usV3Y5kEvH

]]

config = {

    ["Others"] = {
        ['bind'] = 'f2',
        ['coolDown'] = 2000,
    };

    ["Categorys"] = {
        {25, 22, 49, 49, 'Danças', 'assets/images/icons/dance.png', 'Everyone'};
        {137, 21, 51, 51, 'Legais', 'assets/images/icons/like.png', 'Everyone'};
        {251, 22, 49, 49, 'Objetos', 'assets/images/icons/guarda-chuva.png', 'Everyone'};
        {363, 22, 49, 49, 'Outros', 'assets/images/icons/others.png', 'Everyone'};
        {484, 20, 59, 57, 'Destaques', 'assets/images/icons/star.png', 'Everyone'};
    };

    ['IFPS'] = {
        'abdominal',
        'breakdance1',
        'breakdance2',
        'continencia',
        'flexao',
        'fortnite1',
        'fortnite2',
        'fortnite3',
        'newAnims',
        'render',
        'sex',
        'roll',
        'guitarra',
    };

    ['Objects'] = {
        {Name = 'maleta', Model = 1934},
        {Name = 'umbrella', Model = 14864},
        {Name = 'prancheta', Model = 1933},
        {Name = 'camera', Model = 367},
        {Name = 'guitarra', Model = 1563},
    };

    ["Animations"] = {
        
        ["Danças"] = {
        
            { name = "Dança 1", others = {category = "DANCING", animation = "dance_loop", type = 'dance', command = 'dance1', options = { -1, true, false, false } } },
            { name = "Dança 2", others = {category = "DANCING", animation = "DAN_Down_A", type = 'dance', command = 'dance2', options = { -1, true, false, false } } },
            { name = "Dança 3", others = {category = "DANCING", animation = "DAN_Left_A", type = 'dance', command = 'dance3', options = { -1, true, false, false } } },
            { name = "Dança 4", others = {category = "DANCING", animation = "DAN_Right_A", type = 'dance', command = 'dance4', options = { -1, true, false, false } } },
            { name = "Dança 5", others = {category = "DANCING", animation = "DAN_Up_A", type = 'dance', command = 'dance5', options = { -1, true, false, false } } },
          
            { name = "Dança 6", others = {category = "DANCING", animation = "dnce_M_a", type = 'dance', command = 'dance6', options = { -1, true, false, false } } },
            { name = "Dança 7", others = {category = "DANCING", animation = "dnce_M_b", type = 'dance', command = 'dance7', options = { -1, true, false, false } } },
            { name = "Dança 8", others = {category = "DANCING", animation = "dnce_M_c", type = 'dance', command = 'dance8', options = { -1, true, false, false } } },
            { name = "Dança 9", others = {category = "DANCING", animation = "dnce_M_d", type = 'dance', command = 'dance9', options = { -1, true, false, false } } },
            { name = "Dança 10", others = {category = "DANCING", animation = "dnce_M_e", type = 'dance', command = 'dance10', options = { -1, true, false, false } } },
           
            { name = "Dança 11", others = {category = "fortnite1", animation = "baile 1", type = 'dance', command = 'dance11', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 12", others = {category = "fortnite1", animation = "baile 2", type = 'dance', command = 'dance12', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 13", others = {category = "fortnite1", animation = "baile 3", type = 'dance', command = 'dance13', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 14", others = {category = "fortnite1", animation = "baile 4", type = 'dance', command = 'dance14', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 15", others = {category = "fortnite1", animation = "baile 5", type = 'dance', command = 'dance15', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 16", others = {category = "fortnite1", animation = "baile 6", type = 'dance', command = 'dance16', IFP = true, options = { -1, true, false, false } } },
           
            { name = "Dança 17", others = {category = "fortnite2", animation = "baile 7", type = 'dance', command = 'dance17', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 18", others = {category = "fortnite2", animation = "baile 8", type = 'dance', command = 'dance18', IFP = true, options = { -1, true, false, false } } },
          
            { name = "Dança 19", others = {category = "fortnite3", animation = "baile 9", type = 'dance', command = 'dance19', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 20", others = {category = "fortnite3", animation = "baile 10", type = 'dance', command = 'dance20', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 21", others = {category = "fortnite3", animation = "baile 11", type = 'dance', command = 'dance21', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 22", others = {category = "fortnite3", animation = "baile 12", type = 'dance', command = 'dance22', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 23", others = {category = "fortnite3", animation = "baile 13", type = 'dance', command = 'dance23', IFP = true, options = { -1, true, false, false } } },
          
            { name = "Dança 24", others = {category = "breakdance1", animation = "break_D", type = 'dance', command = 'dance24', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 25", others = {category = "breakdance2", animation = "FightA_1", type = 'dance', command = 'dance25', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 26", others = {category = "breakdance2", animation = "FightA_2", type = 'dance', command = 'dance26', IFP = true,  options = { -1, true, false, false } } },
            { name = "Dança 27", others = {category = "breakdance2", animation = "FightA_3", type = 'dance', command = 'dance27', IFP = true,  options = { -1, true, false, false } } },

            { name = "Dança 28", others = {category = "newAnims", animation = "dance1", type = 'dance', command = 'dance28', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 29", others = {category = "newAnims", animation = "dance2", type = 'dance', command = 'dance29', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 30", others = {category = "newAnims", animation = "dance3", type = 'dance', command = 'dance30', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 31", others = {category = "newAnims", animation = "dance4", type = 'dance', command = 'dance31', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 32", others = {category = "newAnims", animation = "dance5", type = 'dance', command = 'dance32', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 33", others = {category = "newAnims", animation = "dance6", type = 'dance', command = 'dance33', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 34", others = {category = "newAnims", animation = "dance7", type = 'dance', command = 'dance34', IFP = true, options = { -1, true, false, false } } },
            { name = "Dança 35", others = {category = "newAnims", animation = "dance8", type = 'dance', command = 'dance35', IFP = true, options = { -1, true, false, false } } },
        };
        
        ["Legais"] = {

            { name = "Cruzar os braços", others = {category = "Ações", animation = "Cruzar Braços", type = 'legal', command = 'cin', Custom = true, options = { 500, false, false, true } } },
            { name = "Rendido 2", others = {category = "Ações", animation = "Render 2", type = 'legal', command = 'cin2', Custom = true, options = {  500, false, false, true } } },
            { name = "Rendido 3", others = {category = "Ações", animation = "Render 3", type = 'legal', command = 'cin3', Custom = true, options = {  500, false, false, true } } },
          
            { name = "Rendido", others = {category = "Ações", animation = "Render", type = 'legal', command = 'in', Custom = true, options = {  500, false, false, true } } },

            { name = "Comprimentar", others = {category = "GANGS", animation = "hndshkaa", type = 'dance', command = 'in2', options = {  -1, true, false, false } } },
            { name = "Comprimentar 2", others = {category = "GANGS", animation = "hndshkba", type = 'dance', command = 'in3', options = {  -1, true, false, false } } },
          
            { name = "Conversando", others = {category = "GANGS", animation = "prtial_gngtlkA", type = 'dance', command = 'in4', options = {  -1, true, false, false } } },
            { name = "Conversando 2", others = {category = "GANGS", animation = "prtial_gngtlkB", type = 'dance', command = 'in5', options = {  -1, true, false, false } } },
        
            { name = "Triste", others = {category = "Interações", animation = "Triste", type = 'legal', command = 'scc', Custom = true, options = {  500, false, false, true } } },
            { name = "Pensando", others = {category = "Interações", animation = "Pensativo 2", type = 'legal', command = 'scc2', Custom = true, options = {  500, false, false, true } } },
           
            { name = "Fumando", others = {category = "SMOKING", animation = "M_smkstnd_loop", type = 'dance', command = 'sc3', options = {  -1, true, false, false  } } },
            { name = "Fumando 2", others = {category = "LOWRIDER", animation = "M_smkstnd_loop", type = 'dance', command = 'sc4', options = {  -1, true, false, false  } } },
            { name = "Fumando 3", others = {category = "GANGS", animation = "smkcig_prtl", type = 'dance', command = 'sc5', options = {  -1, true, false, false } } },
         
            { name = "Esperando", others = {category = "COP_AMBIENT", animation = "Coplook_loop", type = 'dance', command = 'sc6', options = {  -1, true, false, false } } },
            { name = "Esperando 2", others = {category = "COP_AMBIENT", animation = "Coplook_shake", type = 'dance', command = 'sc7', options = {  -1, true, false, false } } },
            { name = "Comemorando", others = {category = "CASINO", animation = "manwinb", type = 'dance', command = 'dance', options = { -1, true, false, false } } },
     
            { name = "Cansado", others = {category = "FAT", animation = "idle_tired", type = 'dance', command = 'sc9', options = {  -1, true, false, false } } },
            { name = "Rindo", others = {category = "RAPPING", animation = "Laugh_01", type = 'dance', command = 'sc10', options = {  -1, true, false, false } } },
       
            { name = "Empurrão", others = {category = "GANGS", animation = "shake_cara", type = 'dance', command = 'in6', options = { -1, true, false, false } } },
      
            { name = "Flexão", others = {category = "flexao", animation = "flexao", type = 'dance', command = 'in7', IFP = true, options = {   -1, true, false, false } } },
            { name = "Abdominal", others = {category = "abdominal", animation = "abdominal", type = 'dance', command = 'in8', IFP = true, options = {  -1, true, false, false } } },

            { name = "Continência", others = {category = "continencia", animation = "continencia", type = 'dance', command = 'in9', IFP = true, options = {  -1, true, false, false } } },
            { name = "Guitarra", others = {category = "guitarra", animation = "guitarra", type = 'objects', command = 'in10', IFP = true, Custom = true, options = {  -1, true, false, false } } },

        };
        
        ["Objetos"] = {
        
            { name = "Garrafa", others = {category = "Ações", animation = "Segurando garrafa", type = 'objects', command = 'oc', Custom = true, options = { 500, false, false, true } } },
            { name = "Caixa", others = {category = "Ações", animation = "Segurando caixa", type = 'objects', command = 'oc2', Custom = true, options = { 500, false, false, true } } },
            { name = "Buquê", others = {category = "Ações", animation = "Segurar buquê", type = 'objects', command = 'oc3', Custom = true, options = { 500, false, false, true } } },
            { name = "Prancha", others = {category = "Ações", animation = "Segurar prancha", type = 'objects', command = 'oc4', options = { 500, false, false, true } } },
            { name = "Guarda-Chuvas", others = {category = "Ações", animation = "Segurar guarda chuvas", type = 'objects', command = 'oc5', Custom = true, options = { 500, false, false, true } } },
            { name = "Câmera", others = {category = "Ações", animation = "Segurando camera", type = 'objects', command = 'oc6', Custom = true, options = { 500, false, false, true } } },
            { name = "Prancheta", others = {category = "Ações", animation = "Segurando prancheta", type = 'objects', command = 'oc7', Custom = true, options = { 500, false, false, true } } },
            { name = "Maleta", others = {category = "Ações", animation = "Segurando maleta", type = 'objects', command = 'oc8', Custom = true, options = { 500, false, false, true } } },

        };
        
        ["Outros"] = {
            { name = "Padrão", others = {type = 'walk', command = 'ws1', options = { style = 0 } } },
            { name = "Padrão 2", others = {type = 'walk', command = 'ws2', options = { style = 56 } } },
            { name = "Bebado", others = {type = 'walk', command = 'ws3', options = { style = 126 } } },
            { name = "Gordo", others = {type = 'walk', command = 'ws4', options = { style = 55 } } },
            { name = "Gordo 2", others = {type = 'walk', command = 'ws4', options = { style = 124 } } },
            { name = "Gang", others = {type = 'walk', command = 'ws5', options = { style = 121 } } },
            { name = "Idoso", others = {type = 'walk', command = 'ws6', options = { style = 120 } } },
            { name = "Idoso 2", others = {type = 'walk', command = 'ws7', options = { style = 123 } } },
            { name = "SWAT", others = {type = 'walk', command = 'ws8', options = { style = 128 } } },
            { name = "Feminino", others = {type = 'walk', command = 'ws9', options = { style = 129 } } },
            { name = "Feminino 2", others = {type = 'walk', command = 'ws10', options = { style = 131 } } },
            { name = "Feminino 3", others = {type = 'walk', command = 'ws11', options = { style = 132 } } },
            { name = "Feminino 4", others = {type = 'walk', command = 'ws12', options = { style = 136 } } },
        };
        
        ["Destaques"] = {
            { name = "Reboladinha", others = {category = "newAnims", animation = "dance9", type = 'dance', command = 'reboladinha', IFP = true, options = { -1, true, false, false } } },
            { name = "Sarradinha", others = {category = "newAnims", animation = "dance10", type = 'dance', command = 'sarradinha', IFP = true, options = { -1, true, false, false } } },
            { name = "Creu V1", others = {category = "newAnims", animation = "creu1", type = 'dance', command = 'creu1', IFP = true, options = { -1, true, false, false } } },
            { name = "Creu V2", others = {category = "newAnims", animation = "creu2", type = 'dance', command = 'creu2', IFP = true, options = { -1, true, false, false } } },
            { name = "Creu V3", others = {category = "newAnims", animation = "creu3", type = 'dance', command = 'creu3', IFP = true, options = { -1, true, false, false } } },
            { name = "Valsa", others = {category = "newAnims", animation = "DANCE_cm", type = 'dance', command = 'valsa', IFP = true, options = { -1, true, false, false } } },
            { name = "Santo", others = {category = "Interações", animation = "Santo", type = 'legal', command = 'oh', Custom = true, options = { 500, false, false, true } } },
            { name = "Assobiar", others = {category = "Ações", animation = "Assobiar", type = 'legal', command = 'oh2', Custom = true, options = { 600, false, false, false } } },
            { name = "Falando radinho", others = {category = "Ações", animation = "Falando radinho", type = 'legal', command = 'oh3', Custom = true, options = { 500, false, false, true } } },
            { name = "Segurando arma", others = {category = "Ações", animation = "Segurar arma", type = 'legal', command = 'oh4', Custom = true, options = { 500, false, false, true } } },
            { name = "Segurando arma 2", others = {category = "Ações", animation = "Segurar arma 2", type = 'legal', command = 'oh5', Custom = true, options = { 500, false, false, true } } },
            { name = "Segurando revolver", others = {category = "Ações", animation = "Segurar pistola", type = 'legal', command = 'oh6', Custom = true, options = { 500, false, false, true } } },
            { name = "Meditando", others = {category = "Interações", animation = "Meditando", type = 'legal', command = 'oh7', Custom = true, options = { 500, false, false, true } } },
            { name = "Lavar", others = {category = "INT_HOUSE", animation = "wash_up", type = 'dance', command = 'oh8', options = { -1, true, false, false } } },
            { name = "Sentar", others = {category = "INT_HOUSE", animation = "LOU_Loop", type = 'dance', command = 'oh9', options = { -1, true, false, false } } },
            { name = "Sentar 2", others = {category = "INT_HOUSE", animation = "LOU_In", type = 'dance', command = 'oh10', options = { -1, true, false, false } } },
            { name = "Sentar 3", others = {category = "ped", animation = "SEAT_idle", type = 'dance', command = 'oh11', options = { -1, true, false, false } } },
            { name = "Deitar", others = {category = "CRACK", animation = "crckidle2", type = 'dance', command = 'oh12', options = { -1, true, false, false } } },
            { name = "Deitar 2", others = {category = "CRACK", animation = "crckidle4", type = 'dance', command = 'oh13', options = { -1, true, false, false } } },
            { name = "Cartão", others = {category = "HEIST9", animation = "Use_SwipeCard", type = 'dance', command = 'oh14', options = { -1, true, false, false } } },
            { name = "Assustado", others = {category = "ped", animation = "cower", type = 'dance', command = 'oh15', options = { -1, true, false, false } } },
            { name = "Punheta", others = {category = "PAULNMAC", animation = "wank_out", type = 'dance', command = 'oh16', options = { -1, true, false, false } } },
            { name = "Mijando", others = {category = "PAULNMAC", animation = "Piss_out", type = 'dance', command = 'oh17', options = { -1, true, false, false } } },

        };
        
    };

    CUSTOM_ANIMATIONS = {
        ['Ações'] = {

            ['Cruzar Braços'] = {
                BonesRotation = {
                    [32] = {0, -110, 25},
                    [33] = {0, -100, 0},
                    [34] = {-75, 0, -40},
                    [22] = {0, -90, -25},
                    [23] = {0, -100, 0},
                },
    
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },

            ['Falando radinho'] = {
                BonesRotation = {
                    [5] = {0, 0, -30},
                    [32] = {-30, -30, 50},
                    [33] = {0, -160, 0},
                    [34] = {-120, 0, 0}
                },

                Object = {
                    Model = 1429,
                    Offset = {34, 0.09,0.04,-0.09,-180,7.2,0},
                    Scale = 1,
                },

                blockAttack = false,
                blockJump = false,
                blockVehicle = false,
            },

            ['Render'] = {
                BonesRotation = {
                    [22] = {0, -15, 60},
                    [32] = {0, -10, -60},
                    [23] = {80, -10, 120},
                    [33] = {-80, -10, -120},
                    [5] = {0, 8, 0}
                },
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },

            ['Render 2'] = {
                BonesRotation = {
                    [22] = {-30, -55, 30},
                    [23] = {10, -20, 60},
                    [24] = {120, 0, 0},
                    [25] = {0, 0, 0},
                    [26] = {0, 0, 0},
                    [32] = {-30, -55, -30},
                    [33] = {-10, -80, -30},
                    [34] = {-70, 0, 0},
                    [35] = {0, 0, 0},
                    [36] = {0, 0, 0},
                    [5] = {0, 8, 0}
                },
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },

            ['Render 3'] = {
                BonesRotation = {
                    [22] = {0, -15, 70},
                    [32] = {0, -10, -60},
                    [23] = {80, -10, 130},
                    [33] = {-80, -10, -130},
                    [5] = {0, -20, 0}
                },
    
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },

            ['Segurar arma'] = {
                BonesRotation = {
                    [23] = {-10, -100, 10},
                    [24] = {120, 10, -50},
                    [32] = {0, 0, 60},
                    [33] = {0, -45, 35},
                },
                blockAttack = true,
                blockVehicle = true,
            },

            ['Segurar arma 2'] = {
                BonesRotation = {
                    [5] = {0, 0, 0},
                    [22] = {80, 0, 0},
                    [23] = {0, -160, 0},
                    [32] = {0, 0, 70},
                    [33] = {0, -10, 20},
                    [34] = {-80, 0, 0},
                },
                blockAttack = true,
                blockVehicle = true,
            },
            
            ['Segurar pistola'] = {
                BonesRotation = {
                    [22] = {0, -30, -35},
                    [23] = {20, -125, -10},
                    [24] = {90, 40, -10},
                    [32] = {-5, -70, 60},
                    [33] = {-70, -90, -5},
                },
                blockAttack = true,
                blockVehicle = true,
            },
            
            ['Equipar máscara'] = {
                BonesRotation = {
                    [22] = {0, -80, -5},
                    [23] = {0, -125, 30},
                    [24] = {160, 0, 0},
                },
                blockAttack = true,
            },

            ['Equipar óculos'] = {
                BonesRotation = {
                    [5] = {10, 5, 0},
                    [22] = {0, -80, -5},
                    [23] = {0, -155, 50},
                    [24] = {60, 0, 0},
                    [32] = {0, -80, 5},
                    [33] = {0, -155, -55},
                    [34] = {-60, 0, 0},
                },
                blockAttack = true,
            },
    
            ['Equipar bolsa'] = {
                BonesRotation = {
                    [22] = {0, -35, -30},
                    [23] = {0, -140, -10},
    
                    [32] = {0, -35, 30},
                    [33] = {0, -140, 10},
                },
                blockAttack = true,
                blockJump = true,
            },

            ['Segurar escudo'] = {
                BonesRotation = {
                    [201] = {0, 0, 0},
                    [32] = {-80, -100, 13},
                    [33] = {-10, -10, 80},
                },
                onDuck = {
                    [201] = {0, 0, 0},
                    [32] = {-100, -15, -25},
                    [33] = {35, 50, 110},
                    [34] = {-30, 0, 0},
                },
                blockVehicle = true,
            },
    
            ['Colocar capacete'] = {
                BonesRotation = {
                    [5] = {0, 20, 0},
                    [22] = {0, -90, 0},
                    [23] = {50, -170, 60},
                    [24] = {0, 0, 0},
                    [25] = {-40, 0, 0},
                    [32] = {0, -110, 0},
                    [33] = {0, -170, -55},
                    [34] = {0, 0, 0},
                    [35] = {40, 0, 0},
                },
                blockAttack = true,
                Sound = {
                    File = 'capacete',
                    MaxDistance = 10,
                    Volume = 0.2,
                },
            },
    
            ['Segurando garrafa'] = {
                BonesRotation = {
                    [32] = {30, -20, 60},
                    [33] = {0, -90, 0},
                    [34] = {-90, 0, 0},
                    [35] = {-10, 0, 0},
                },
                onDuck = {
                    [32] = {-30, 0, 60},
                    [33] = {0, -90, 0},
                    [34] = {-90, 0, 0},
                    [35] = {-10, 0, 0},
                },
                Object = {
                    Model = 1544,
                    Offset = {34, 0.07, 0.03, 0.05, 0, -180, 0},
                    Scale = 0.9,
                },
            },

            ['Segurando camera'] = {
                BonesRotation = {
                    [22] = {0, -60, 0},
                    [23] = {80, -90, 80},
                    [24] = {80, 30, 0},
    
                    [32] = {0, -85, 10},
                    [33] = {-70, -100, -20},
                },
                onDuck = {
                    [22] = {0, -80, 0},
                    [23] = {80, -70, 80},
                    [24] = {90, 30, 0},
    
                    [32] = {0, 0, 10},
                    [33] = {-70, -100, -20},
                    [34] = {-20, 0, 0},
                },
                Object = {
                    Model = 367,
                    Offset = {24, -0.04,0.08,-0.31,-10.8,54,0},
                },
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },
            
            ['Segurando prancheta'] = {
                BonesRotation = {
                    [5] = {0, 5, 0},
                    [32] = {-10, -60, 20},
                    [33] = {-30, -80, 0},
    
                    [34] = {-120, 0, 0},
                    [35] = {-40, 30, -10},
                },
                onDuck = {
                    [5] = {0, -30, 0},
                    [32] = {-10, -20, -5},
                    [33] = {-40, -90, 0},
    
                    [34] = {-140, 0, 0},
                    [35] = {-40, 30, -10},
                },
                Object = {
                    Model = 1933,
                    Offset = {35, 0.08,0.05,0.02,82.8,-180,0},
                },
                blockJump = true,
            },

            ['Segurando maleta'] = {
                BonesRotation = {},
                Object = {
                    Model = 1934,
                    Offset = {35, 0.23,-0.02,0.03,25.2,-108,0},
                    Scale = 0.7,
                }
            },

            ['Segurar buquê'] = {

                BonesRotation = {
                    [32] = {30, -20, 60},
                    [33] = {0, -90, 0},
                    [34] = {-90, 0, 0},
                    [35] = {-10, 0, 0},
                },
                
                onDuck = {
                    [32] = {-90, -30, -10},
                    [33] = {0, -90, 0},
                    [34] = {-95, 30, 0},
                    [35] = {-10, 0, 0},
                },
                Object = {
                    Model = 325,
                    Offset = {34, 0.03,0.07,-0.06,-180,3.6,-18},
                    Scale = 0.9,
                },
            },

            ['Segurar guarda chuvas'] = {
                BonesRotation = {
                    [32] = {30, -20, 60},
                    [33] = {0, -90, 0},
                    [34] = {-80, -30, 0},
                    [35] = {-30, 0, 0},
                },
                onDuck = {
                    [32] = {30, -20, 10},
                    [33] = {0, -80, -80},
                    [34] = {-90, -30, 0},
                    [35] = {-30, 0, 0},
                },
                Object = {
                    Model = 14864,
                    Offset = {34, 0.05, 0.03, 0.05, 0, -210, 30},
                    Scale = 0.9,
                },
    
                blockJump = true,
                blockVehicle = true,
            },

            ['Segurar prancha'] = {
                BonesRotation = {
                    [32] = {30, -20, 40},
                    [33] = {0, -60, 30},
                    [34] = {-130, 0, 0}
                },
                Object = {
                    Model = 2404,
                    Offset = {33, 0.19,-0.07,0.01,39.6,7.2,-3.6},
                    Scale = 0.7,
                },
                blockDuck = true,
                blockJump = true,
                blockVehicle = true,
            },

            ['Segurando caixa'] = {
                BonesRotation = {
                    [22] = {60, -30, -70},
                    [23] = {-10, -70, -50},
                    [24] = {160, 0, 0},
                    [25] = {0, -10, 0},
                    [32] = {-60, -40, 70},
                    [33] = {10, -70, 50},
                    [34] = {-160, 0, 0},
                    [35] = {0, -10, 0},
                    [201] = {0, 0, 0},
                },
    
                onDuck = {
                    [22] = {60, -30, 0},
                    [23] = {-10, -70, -50},
                    [24] = {160, 0, 0},
                    [25] = {0, -10, 0},
                    [32] = {-60, -40, 0},
                    [33] = {10, -70, 50},
                    [34] = {-160, 0, 0},
                    [35] = {0, -10, 0},
                    [201] = {0, 0, 0},
                },
                Object = {
                    Model = 2912,
                    Offset = {24, 0.13,0.34,-0.21,28.8,0,-3.6},
                    Scale = 0.5,
                },
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },

            ['Assobiar'] = {
                BonesRotation = {
                    [32] = {-90, -70, 0},
                    [33] = {10, 30, 125},
                },
                Sound = {
                    File = 'assobio',
                    MaxDistance = 50,
                },
            },
        },
        
        ['Interações'] = {
            ['Triste'] = {
                BonesRotation = {
                    [5] = {0, 20, 0}
                },
    
                blockAttack = true,
            },
    
            ['Pensativo 2'] = {
                BonesRotation = {
                    [5] = {0, 8, 0},
                    [32] = {0, -110, 25},
                    [33] = {0, -100, 0},
                    [22] = {60, -95, -30},
                    [23] = {8, -135, 8}
                },
    
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
            },
    
            ['Santo'] = {
                BonesRotation = {
                    [32] = {0, -60, 60},
                    [33] = {0, -60, 20},
                    [34] = {-100, 0, 0},
    
                    [22] = {0, -40, -60},
                    [23] = {0, -70, -30},
                },
    
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
                blockDuck = true,
            },
    
            ['Meditando'] = {
                BonesRotation = {
                    [22] = {30, -60, -45},
                    [23] = {20, -60, 40},
                    [24] = {-220, 0, 0},
    
                    [32] = {-30, -60, 45},
                    [33] = {20, -60, -40},
                    [34] = {-220, 0, 0},
    
                },
    
                blockAttack = true,
                blockJump = true,
                blockVehicle = true,
                blockDuck = true,
            },
        },
    
        ['guitarra'] = {
            ['guitarra'] = {
                BonesRotation = {},
    
                Object = {
                    Model = 1563,
                    Offset = {31, 0.14, -0.16, -0.15, 0, 39.6, -7.2},
                }
            }
        }
    
    },

    ifps = {
        "abdominal",
        "breakdance1",
        "breakdance2",
        "continencia",
        "flexao",
        "fortnite1",
        "fortnite2",
        "fortnite3",
        "newAnims",
        "render",
        "sex",
        "segurando",
    },
    
    Ossos = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 21,--NÃO MECHER
        22, 23, 24, 25, 26, 31, 32, 33,--NÃO MECHER
        34, 35, 36, 41, 42, 43, 44, 51, --NÃO MECHER
        52, 53, 54, 201, 301, 302 --NÃO MECHER
    },

    sendMessageClient = function(message, type)
        return exports['guetto_notify']:showInfobox(type, message)
    end;
 
    sendMessageServer = function(player, message, type)
        return exports['guetto_notify']:showInfobox(player, type, message)
    end;
 
}

function registerEvent(event, element, callback)
    addEvent(event, true)
    addEventHandler(event, element, callback)
end

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end

