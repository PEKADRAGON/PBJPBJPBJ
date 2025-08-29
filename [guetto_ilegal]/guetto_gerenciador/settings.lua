config = {

    ["ElementsData"] = {
        ["Corporação"] = "service.police",
        ["Facção"] = "service.gang",
        ["Mec"] = "service.mechanic",
        ["SAMU"] = "service.samu",
    };

    ["Gerenciador"] = {
        ["PMESP"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {2513.282, 2248.281, 10.82};
            ["Skins"] = {
                {name = "Skin 1", description = 'Roupa de patrulhamento', id = 272};
                {name = "Skin 2", description = 'Roupa de patrulhamento', id = 273};
            };
            ["Veiculos"] = {
                {name = "VTR", description = 'Veículo para patrulhamento.', space = 30, id = 597, plotagem = 'PMESP', blindagem = true, spawn = {2507.958, 2251.766, 10.82, 0, 0, 0} };  
            };
        };
        ["FT"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {1003.466, 518.479, 20.441};
            ["Skins"] = {

                {name = "Skin 1", description = 'Roupa de patrulhamento', id = 94};
                {name = "Skin 2", description = 'Roupa de patrulhamento', id = 95};
                {name = "Skin 3", description = 'Roupa de patrulhamento', id = 96};
                {name = "Skin 4", description = 'Roupa de patrulhamento', id = 97};

            };
            ["Veiculos"] = {
                {name = "VTR", description = 'Força tatica', space = 30, id = 490, plotagem = 'FT', blindagem = true, spawn = {979.124, 515.079, 20.277, 0, 0, 243.529} };  
                {name = "VTR", description = 'Radio patrulhamento', space = 30, id = 597, plotagem = 'FT', blindagem = true, spawn = {979.124, 515.079, 20.277, 0, 0, 243.529} };  
                {name = "VTR", description = 'Corregedoria.', space = 30, id = 490, plotagem = 'FT2', blindagem = true, spawn = {979.124, 515.079, 20.277, 0, 0, 243.529} };  
                {name = "ROCAM", description = 'Motocicleta.', space = 30, id = 523, plotagem = 'FT', blindagem = true, spawn = {979.124, 515.079, 20.277, 0, 0, 243.529} };  
            };
        };
        ["CORE"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {2513.561, 2262.875, 10.82};
            ["Skins"] = {
                {name = "Skin 2", description = 'Roupa de patrulhamento', id = 84};
            };
            ["Veiculos"] = {
                {name = "VTR1", description = 'Patrulhamento', space = 30, id = 598, plotagem = 'CORE', blindagem = true, spawn = {2507.592, 2262.527, 10.82, 0, 0, 0} };  
            };
        };
        ["EB"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {-1491.106, 302.081, 7.199};
            ["Skins"] = {

                {name = "Roupa 1", description = 'Roupa do EB', id = 200};
                {name = "Roupa 2", description = 'Roupa do EB', id = 201};
                {name = "Roupa 3", description = 'Roupa do EB', id = 202};
                {name = "Roupa 4", description = 'Roupa do EB', id = 203};

            };
            ["Veiculos"] = {
                {name = "Rocam", description = 'Para patrulhamento', space = 30, id = 523, plotagem = 'EB', blindagem = false, spawn = {-1528.019, 359.477, 7.199, 0, 0, 0} };  
                {name = "VTR", description = 'Para patrulhamento', space = 30, id = 490, plotagem = 'EB', blindagem = true, spawn = {-1528.019, 359.477, 7.199, 0, 0, 0} };  
                {name = "Blindado", description = 'Para Ações', space = 3, id = 489, plotagem = 'EB', blindagem = true, spawn = {-1528.019, 359.477, 7.199, 0, 0, 0} };  
                {name = "Aeronave", description = 'Para Ações', space = 3, id = 497, plotagem = 'EB', blindagem = true, spawn = {-1557.41, 277.768, 7.711, 0, 0, 0} };  
                {name = "Transporte", description = 'Para Transporte', space = 10, id = 456, plotagem = 'EB', blindagem = true, spawn = {-1528.019, 359.477, 7.199, 0, 0, 0} };  

               -- {name = "Transporte", description = 'Para Ações', space = 3, id = 433, plotagem = 'EB', blindagem = true, spawn = {-1528.019, 359.477, 7.199, 0, 0, 0} };  
            };
        };
        ["PF"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {2046.045, -1907.661, 5.438};
            ["Skins"] = {
                {name = "Roupa 1", description = 'Roupa de lider', id = 204};
                {name = "Roupa 2", description = 'Roupa de patrulhamento', id = 205};
                {name = "Roupa 3", description = 'Roupa de patrulhamento', id = 35};
            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Duster', space = 30, id = 597, plotagem = 'PF', blindagem = true, spawn = {2064.733, -1870.27, 5.438, 0, 0, 92.405} };  
                {name = "Veiculo 2", description = 'S10', space = 30, id = 585, plotagem = 'PF', blindagem = true, spawn = {2064.733, -1870.27, 5.438, 0, 0, 92.405} }; 
                {name = "Veiculo 3", description = 'Aeronave PF', space = 10, id = 497, plotagem = 'PF', blindagem = true, spawn = {2026.511, -1872.756, 24.312, 0, 0, 92.086} };
                {name = "Veiculo 4", description = 'Rocam', space = 30, id = 523, plotagem = 'PF', blindagem = true, spawn = {2064.733, -1870.27, 5.438, 0, 0, 92.405} }; 
            };
        };

        ["PMES"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {2510.016, 2393.819, 10.815};
            ["Skins"] = {
                {name = "Skin 1", description = 'Descrição vai aqui!', id = 100};
                {name = "Skin 2", description = 'Descrição vai aqui!', id = 101};
            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Descrição vai aqui!', space = 30, id = 597, plotagem = 'PMES', blindagem = true, spawn = {2506.039, 2382.457, 10.815, 0, 0, 0} };   
            };
        };
        ["BOPE"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {2510.252, 2398.727, 10.815};
            ["Skins"] = {
                {name = "Skin 1", description = 'Descrição vai aqui!', id = 282};
                {name = "Skin 2", description = 'Descrição vai aqui!', id = 283};
                {name = "Skin 3", description = 'Descrição vai aqui!', id = 284};
            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Descrição vai aqui!', space = 30, id = 490, plotagem = 'BOPE', blindagem = true, spawn = {2512.477, 2393.927, 10.815, 0, 0, 90.801} };  
                {name = "Veiculo 2", description = 'Descrição vai aqui!', space = 30, id = 585, plotagem = 'BOPE', blindagem = true, spawn = {2512.477, 2393.927, 10.815, 0, 0, 90.801} };  
            };
        };
        ["PMMG"] = {
            ["Type"] = "Corporação",    
            ['DestroyVehicle'] = {934.201, -1697.086, 14.955};
            ["Skins"] = {
                {name = "Skin 1", description = 'Descrição vai aqui!', id = 86};
                {name = "Skin 2", description = 'Descrição vai aqui!', id = 87};
                {name = "Skin 3", description = 'Descrição vai aqui!', id = 88};
            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Descrição vai aqui!', space = 30, id = 490, plotagem = 'PMMG', blindagem = true, spawn = {934.883, -1710.317, 14.955, 0, 0, 0} };
                {name = "Veiculo 1", description = 'Descrição vai aqui!', space = 30, id = 490, plotagem = 'ROTAMMG', blindagem = true, spawn = {934.883, -1710.317, 14.955, 0, 0, 0} };
                {name = "Veiculo 2", description = 'Descrição vai aqui!', space = 30, id = 523, plotagem = 'PMMG', blindagem = true, spawn = {934.883, -1710.317, 14.955, 0, 0, 0} };
                  
            };
        };
        ["TOR"] = {
            ["Type"] = "Corporação",    
            ['DestroyVehicle'] = {2045.82, -1899.087, 5.438};
            ["Skins"] = {
                {name = "Skin 1", description = 'Descrição vai aqui!', id = 206};
                {name = "Skin 2", description = 'Descrição vai aqui!', id = 207};
            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Descrição vai aqui!', space = 30, id = 490, plotagem = 'TOR', blindagem = true, spawn = {2065.851, -1875.51, 5.438, 0, 0, 90.477} };  
            };
        };
        ["ROTA"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {1012.112, 514.312, 20.441};
            ["Skins"] = {
                {name = "Skin 1", description = 'Descrição vai aqui!', id = 29};
                {name = "Skin 2", description = 'Descrição vai aqui!', id = 30};
                {name = "Skin 3", description = 'Descrição vai aqui!', id = 85};
            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Descrição vai aqui!', space = 30, id = 490, plotagem = 'ROTA', blindagem = true, spawn = {981.448, 519.821, 20.284, 0, 0, 244.337} };  
                {name = "Veiculo 2", description = 'Descrição vai aqui!', space = 30, id = 598, plotagem = 'ROTA', blindagem = true, spawn = {981.448, 519.821, 20.284, 0, 0, 244.337} };  
            };
        };
        ["PCERJ"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {2513.967, 2308.555, 10.82};
            ["Skins"] = {
                {name = "Skin 1", description = 'Descrição vai aqui!', id = 15};
            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Descrição vai aqui!', space = 30, id = 490, plotagem = 'PCERJ', blindagem = true, spawn = {2507.993, 2307.078, 10.82, 0, 0, 0} };  
            };
        };
        ["CHOQUE"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {2514.043, 2319.386, 10.82};
            ["Skins"] = {
                {name = "Skin 1", description = 'Descrição vai aqui!', id = 25};
                {name = "Skin 2", description = 'Descrição vai aqui!', id = 26};

            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Descrição vai aqui!', space = 30, id = 598, plotagem = 'CHOQUE', blindagem = true, spawn = {2507.066, 2319.055, 10.82, 0, 0, 0} };  
            };
        };
        ["PRF"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {1687.256, 66.082, 37.729};
            ["Skins"] = {
                {name = "Skin 1", description = 'Descrição vai aqui!', id = 20};
                {name = "Skin 2", description = 'Descrição vai aqui!', id = 21};
            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Descrição vai aqui!', space = 30, id = 596, plotagem = 'PRF', blindagem = true, spawn = {1672.613, 75.948, 37.729, 0, 0, 0} };  
            };
        };
        ["COT"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {2513.95, 2299.436, 10.82};
            ["Skins"] = {
                {name = "Skin 1", description = 'Descrição vai aqui!', id = 40};
                {name = "Skin 2", description = 'Descrição vai aqui!', id = 41};
            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Descrição vai aqui!', space = 30, id = 598, plotagem = 'COT', blindagem = true, spawn = {2507.26, 2293.725, 10.82, 0, 0, 0} };  
            };
        };
        
        ["SAMU"] = {
            ["Type"] = "SAMU",
            ['DestroyVehicle'] = {1429.059, -1794.303, 13.547};
            ["Skins"] = {
                {name = "Skin 1", description = 'Roupa feminina do samu', id = 274};
                {name = "Skin 2", description = 'Roupa masculina do samu', id = 275};
                {name = "C-Feminino", description = 'Roupa feminina da custom', id = 2};
            };
            ["Veiculos"] = {
                {name = "Ambulancia", description = 'Pronto atendimento', space = 30, id = 416, plotagem = 'SAMU', blindagem = true, spawn = {1491.602, -1746.985, 13.696, 0, 0, 333} }; 
                {name = "VTR", description = 'Pronto atendimento', space = 30, id = 490, plotagem = 'SAMU', blindagem = true, spawn = {1491.602, -1746.985, 13.696, 0, 0, 333} }; 
                {name = "Aeronave", description = 'Pronto atendimento', space = 30, id = 497, plotagem = 'SAMU', blindagem = true, spawn = {1464.45, -1757.448, 25.062, 0, 0, 333} }; 

            };
        };
        ["DETRAN"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {1175.462, -916.965, 43.319};
            ["Skins"] = {
                {name = "Skin 1", description = 'Roupa', id = 280};
                {name = "Skin 2", description = 'Roupa', id = 281};
            };
            ["Veiculos"] = {
            
                {name = "Guincho", description = 'Transporte de veículos', space = 30, id = 443, plotagem = 'DETRAN', blindagem = true, spawn = {1216.074, -901.121, 42.914, 0, 0, 188.526} }; 
                {name = "VTR Blazer", description = 'Veículo de suporte.', space = 30, id = 597, plotagem = 'DETRAN', blindagem = true, spawn = {1190.268, -908.381, 43.218, 0, 0, 199.803} }; 

            };
        };
        --- FACÇÂO
        ["UT"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {-1125.094, -1653.293, 76.397};
            ["Skins"] = {
                {name = "Feminino", description = 'Juh-skin', id = 36};
                {name = "UT 1", description = 'UT', id = 37};
                {name = "UT 2", description = 'UT', id = 38};
                {name = "UT 3", description = 'UT', id = 39};
            };
            ["Veiculos"] = {
                {name = "Veículo Ranger", description = 'Veículos temporario', space = 15, id = 470, plotagem = 'UT', blindagem = true, spawn = {-1102.661, -1648.539, 76.367, 0, 0, 0} }; 
                {name = "Veículo Alpha r.", description = 'Veículos temporario', space = 15, id = 561, plotagem = 'UT', blindagem = true, spawn = {-1102.661, -1648.539, 76.367, 0, 0, 0} };  
                {name = "Veículo Exclusivo", description = 'Veículos temporario', space = 15, id = 466, plotagem = 'UT', blindagem = true, spawn = {-1102.661, -1648.539, 76.367, 0, 0, 0} };  
                {name = "Veículo Aeronave", description = 'Veículos temporario', space = 15, id = 497, plotagem = 'UT', blindagem = true, spawn = {-1075.139, -1683.183, 76.106, 0, 0, 0} }; 
            };
        };
        ["MEC"] = {
            ["Type"] = "Mec",
            ['DestroyVehicle'] = {1014.659, -1021.335, 32.105};
            ["Skins"] = {
                {name = "Feminina", description = 'Roupa feminina', id = 50};
                {name = "Masculino", description = 'Roupa masculina', id = 51};
                {name = "F-Masculino", description = 'Roupa masculina da custom', id = 1};
                {name = "C-Feminino", description = 'Roupa feminina da custom', id = 2};
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 10, id = 525, plotagem = 'MEC', blindagem = false, spawn = {1028.054, -1019.544, 32.105, 0, 0, 0} };  
            };
        };
        ["CND"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {-412.311, -1754.053, 6.626};
            ["Skins"] = {
            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Cuide do veículo.', space = 15, id = 566, plotagem = 'CND', blindagem = false, spawn = {-431.344, -1754.792, 7.854, 0, 0, 282.284} };  
            };
        };
        ["TDF"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {2695.847, -730.879, 79.797};
            ["Skins"] = {
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 15, id = 566, plotagem = 'TDF', blindagem = false, spawn = {2700.681, -733.601, 79.581, 0, 0, 262.272} };  
            };
        };
        ["MLC"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {1538.649, -2843.971, 1.389};
            ["Skins"] = {
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 15, id = 566, plotagem = 'MLC', blindagem = false, spawn = {1523.772, -2831.749, 1.31, 0, 0, 89.026} };  
            };
        };
        ["YKZ"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {1965.469, 187.618, 36.597};
            ["Skins"] = {
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 10, id = 566, plotagem = 'YKZ', blindagem = false, spawn = {1957.638, 164.63, 36.68, 0, 0, 62.043} };  
            };
        };
        ["KATIARA"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {1376.354, -230.968, 9.305};
            ["Skins"] = {
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 10, id = 470, plotagem = 'KATIARA', blindagem = false, spawn = {1364.197, -216.021, 7.831, 0, 0, 81.83} };  
            };
        };
        ["DPZ"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {2505.671, -1695.676, 13.552};
            ["Skins"] = {
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 10, id = 470, plotagem = 'DPZ', blindagem = false, spawn = {2498.405, -1658.036, 13.367,0, 0, 177.495} };  
            };
        };
        ["TD7"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {2509.763, -1229.152, 39.016};
            ["Skins"] = {
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 15, id = 566, plotagem = 'TD7', blindagem = false, spawn = {2512.608, -1256.332, 34.863, 0, 0, 86.521} };  
            };
        };
        ["BALLAS"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {2474.139, -1996.212, 13.547};
            ["Skins"] = {
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 10, id = 561, plotagem = 'BALLAS', blindagem = false, spawn = {2468.204, -2007.721, 13.346, 0, 0, 91.603} };  
            };
        };
        ["TDC"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {-480.934, -41.918, 60.458};
            ["Skins"] = {
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 10, id = 566, plotagem = 'TDP', blindagem = false, spawn = {-439.975, -48.802, 60.388, 0, 0, 80.138} };  
            };
        };
        ["CV"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {-770.343, -1111.334, 60.964};
            ["Skins"] = {
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 10, id = 566, plotagem = 'CV', blindagem = false, spawn = {-758.83, -1112.614, 60.964,0, 0, 359.047} };  
            };
        };
        ["COE"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {2513.666, 2273.677, 10.82};
            ["Skins"] = {
                {name = "Skin 1", description = 'Descrição vai aqui!', id = 42};
            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Descrição vai aqui!', space = 30, id = 598, plotagem = 'COE', blindagem = true, spawn = {2507.509, 2275.167, 10.82, 0, 0, 0} };  
            };
        };
        ["PCC"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {492.724, 1482.147, 11.512};
            ["Skins"] = {
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 15, id = 421, plotagem = 'PCC', blindagem = false, spawn = {463.313, 1518.66, 10.424, 0, 0, 162.449} };  
            };
        };
        ["CGR"] = {
            ["Type"] = "Corporação",
            ['DestroyVehicle'] = {2045.786, -1892.948, 5.438};
            ["Skins"] = {
                {name = "Skin 1", description = 'Descrição vai aqui!', id = 285};
                {name = "Skin 2", description = 'Descrição vai aqui!', id = 286};
                {name = "Skin 3", description = 'Descrição vai aqui!', id = 287};
                {name = "Skin 4", description = 'Descrição vai aqui!', id = 288};
            };
            ["Veiculos"] = {
                {name = "Veiculo 1", description = 'Descrição vai aqui!', space = 30, id = 490, plotagem = 'CGR', blindagem = true, spawn = {2065.534, -1907.328, 5.438, 0, 0, 89.35} };  
            };
        };
        ["R7"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {2684.582, -1990.062, 13.554};
            ["Skins"] = {
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 15, id = 421, plotagem = 'R7', blindagem = false, spawn = {2661.786, -2000.729, 13.383, 0, 0, 269.743} };  
            };
        };
        ["MOTOCLUB"] = {
            ["Type"] = "Facção",
            ['DestroyVehicle'] = {845.652, -1723.788, 13.617};
            ["Skins"] = {
            };
            ["Veiculos"] = {
               {name = "Veiculo 1", description = 'Cuide do veículo.', space = 15, id = 525, plotagem = 'MOTOCLUB', blindagem = false, spawn = {841.281, -1694.239, 13.617, 0, 0, 359.338} };  
            };
        };
    };

    ['Positions'] = {

        {2492.443, 2249.977, 10.831, 'PMESP', int = 0, dim = 0};
        {2484.944, 2392.606, 11.972, 'PMES', int = 0, dim = 0};

        {2473.759, 2391.998, 11.964, 'BOPE', int = 0, dim = 0};
        {832.252, -1711.5, 1739.252, 'PMMG', int = 0, dim = 0};
        {968.483, 526.841, 20.441, 'ROTA', int = 0, dim = 0};
        {2493.561, 2264.031, 10.831, 'CORE', int = 0, dim = 0};
        {2493.398, 2305.053, 10.831, 'PCERJ', int = 0, dim = 0};
        {2493.239, 2318.912, 10.831, 'CHOQUE', int = 0, dim = 0};
        {1646.394, 94.642, 37.923, 'PRF', int = 0, dim = 0};
        {1471.067, -1804.606, 13.664, 'SAMU', int = 0, dim = 0};
        {2046.954, -1910.017, 13.703, 'PF', int = 0, dim = 0};
        {-1496.112, 337.51, 7.346, 'EB', int = 0, dim = 0};
        {2050.102, -1901.128, 13.703, 'TOR', int = 0, dim = 0};
        {965.727, 520.479, 20.441, 'FT', int = 0, dim = 0}; 
        {1197.07, -891.189, 43.123, 'DETRAN', int = 0, dim = 0};
        {2493.209, 2291.519, 10.831, 'COT', int = 0, dim = 0};
        {2492.827, 2277.742, 10.831, 'COE', int = 0, dim = 0};
        {2051.148, -1907.795, 13.703, 'CGR', int = 0, dim = 0};

        --- Facçõesw
        {-745.072, -1112.73, 60.964, 'CV', int = 0, dim = 0};
        {2483.727, -1984.557, 14.248, 'BALLAS', int = 0, dim = 0};
        {2512.751, -1240.028, 39.788, 'TD7', int = 0, dim = 0};
        {-425.258, -48.011, 63.647, 'TDC', int = 0, dim = 0};

        {2670.336, -2031.392, 14.248, 'R7', int = 0, dim = 0};
        
        {828.017, -1706.492, 15.617, 'MOTOCLUB', int = 0, dim = 0};
        {-1096.501, -1665.993, 76.389, 'UT', int = 0, dim = 0};
        {1064.722, -1010.38, 38.051, 'MEC', int = 0, dim = 0};
        {-431.947, -1769.515, 7.854, 'CND', int = 0, dim = 0};
        {2666.007, -752.751, 92.939, 'TDF', int = 0, dim = 0};
        {1538.132, -2865.141, 8.589, 'MLC', int = 0, dim = 0};
        {1967.837, 180.397, 40.713, 'YKZ', int = 0, dim = 0};
        {1367.832, -159.325, 22.303, 'KATIARA', int = 0, dim = 0};
        {2486.874, -1632.15, 14.248, 'DPZ', int = 0, dim = 0};
        {531.917, 1443.006, 13.789, 'PCC', int = 0, dim = 0};
        
    };

    ["Ui"] = {
        ["Skins"] = {
            ["Text"] = "Garagem de veículos";
            ["Description"] = "Cuide do seu veículo, existe um limite por veículo."
        };
        ["Veiculos"] = {
            ["Text"] = "Garagem de veículos";
            ["Description"] = "Cuide do seu veículo, existe um limite por veículo."
        };
    }
}

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;

sendMessageClient = function (msg, type)
    return exports['guetto_notify']:showInfobox(type, msg)
end;

function createEvent (event, ...)
    addEvent(event, true)
    addEventHandler(event, ...)
end

function getVehicleByModel (acl, model)
    if not (acl) or not (model) then
        return false 
    end
    for i = 1, #config["Gerenciador"][acl]["Veiculos"] do 
        if (config["Gerenciador"][acl]["Veiculos"][i].id == model) then
            return i
        end
    end
    return false
end