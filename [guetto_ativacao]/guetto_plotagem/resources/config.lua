--[[

    Example:
        vehiclesDefaults = {
            [modelId] = { LocalTXD = "fileTxd", LocalDFF = "fileDff" },
        },
        vehiclesPlotagem = {
            [modelId] = {
                ["ElementData"] = {
                    -- Textures Apply
                    { LocalPNG = "filePng", TextureName = "textureName" },
                },
            },
        }
]]


config = {
    PasswordVTR = "MISTICPASS",
    DefaultStateLag = true, -- Como vai ficar quando logar no servidor (Caso for false, use o exports e os trigger)

    downloadsPriority = {},
    vehiclesDefaults = {
        [490] = {LocalTXD = "resources/vehicles/490.txd", LocalDFF = "resources/vehicles/490.dff"}, -- BLAZER
        [597] = {LocalTXD = "resources/vehicles/597.txd", LocalDFF = "resources/vehicles/597.dff"}, -- DUSTER
        [596] = {LocalTXD = "resources/vehicles/596.txd", LocalDFF = "resources/vehicles/596.dff"}, -- BMW M3
        [598] = {LocalTXD = "resources/vehicles/598.txd", LocalDFF = "resources/vehicles/598.dff"}, -- HILUX
        [585] = {LocalTXD = "resources/vehicles/585.txd", LocalDFF = "resources/vehicles/585.dff"}, -- S10
        [523] = {LocalTXD = "resources/vehicles/523.txd", LocalDFF = "resources/vehicles/523.dff"}, -- ROCAM
        [497] = {LocalTXD = "resources/vehicles/497.txd", LocalDFF = "resources/vehicles/497.dff"}, -- HELI

        [566] = {LocalTXD = "resources/vehicles/566.txd", LocalDFF = "resources/vehicles/566.dff"}, -- lancer
        [561] = {LocalTXD = "resources/vehicles/561.txd", LocalDFF = "resources/vehicles/561.dff"}, -- alpha romeu
        [470] = {LocalTXD = "resources/vehicles/470.txd", LocalDFF = "resources/vehicles/470.dff"}, -- ranger 4x4
        [429] = {LocalTXD = "resources/vehicles/429.txd", LocalDFF = "resources/vehicles/429.dff"}, -- r8 speed
        [421] = {LocalTXD = "resources/vehicles/421.txd", LocalDFF = "resources/vehicles/421.dff"}, -- nivus
    },
    vehiclesPlotagem = {
        [566] = {
            ["GROTA"] = {
                {LocalPNG = "resources/textures/bandeiras/grota.png", TextureName = "remap"},
            },
            ["VK"] = {
                {LocalPNG = "resources/textures/bandeiras/vk.png", TextureName = "remap"},
            },
            ["PCC"] = {
                {LocalPNG = "resources/textures/bandeiras/pcc.png", TextureName = "remap"},
            },
            ["TCP"] = {
                {LocalPNG = "resources/textures/bandeiras/tcp.png", TextureName = "remap"},
            },
            ["TDL"] = {
                {LocalPNG = "resources/textures/bandeiras/tdl.png", TextureName = "remap"},
            },
            ["MLC"] = {
                {LocalPNG = "resources/textures/bandeiras/mlc.png", TextureName = "remap"},
            },
            ["CDC"] = {
                {LocalPNG = "resources/textures/bandeiras/cdc.jpg", TextureName = "remap"},
            },
            ["TDH"] = {
                {LocalPNG = "resources/textures/bandeiras/tdh.png", TextureName = "remap"},
            },
            ["NS"] = {
                {LocalPNG = "resources/textures/bandeiras/ns.png", TextureName = "remap"},
            },
            ["4M"] = {
                {LocalPNG = "resources/textures/bandeiras/4m.png", TextureName = "remap"},
            },
            ["XP"] = {
                {LocalPNG = "resources/textures/bandeiras/xp.png", TextureName = "remap"},
            },
            ["CV"] = {
                {LocalPNG = "resources/textures/bandeiras/cv.png", TextureName = "remap"},
            },
            ["RODO"] = {
                {LocalPNG = "resources/textures/bandeiras/rodo.png", TextureName = "remap"},
            },
            ["TDI"] = {
                {LocalPNG = "resources/textures/bandeiras/tdi.png", TextureName = "remap"},
            },
            ["R7"] = {
                {LocalPNG = "resources/textures/bandeiras/r7.png", TextureName = "remap"},
            },
            ["TDM"] = {
                {LocalPNG = "resources/textures/bandeiras/tdm.png", TextureName = "remap"},
            },
            ["AL-QAEDA"] = {
                {LocalPNG = "resources/textures/bandeiras/alq.png", TextureName = "remap"},
            },
            ["CDD"] = {
                {LocalPNG = "resources/textures/bandeiras/cdd.png", TextureName = "remap"},
            },
            ["STD"] = {
                {LocalPNG = "resources/textures/bandeiras/std.png", TextureName = "remap"},
            },
            ["CPX"] = {
                {LocalPNG = "resources/textures/bandeiras/cpx.png", TextureName = "remap"},
            },
            ["YKZ"] = {
                {LocalPNG = "resources/textures/bandeiras/ykz.png", TextureName = "remap"},
            },
            ["TDF"] = {
                {LocalPNG = "resources/textures/bandeiras/tdf.png", TextureName = "remap"},
            },
            ["CDA"] = {
                {LocalPNG = "resources/textures/bandeiras/cda.png", TextureName = "remap"},
            },
        },
        [561] = {
            ["GROTA"] = {
                {LocalPNG = "resources/textures/bandeiras/grota.png", TextureName = "remap"},
            },
            ["VK"] = {
                {LocalPNG = "resources/textures/bandeiras/vk.png", TextureName = "remap"},
            },
            ["LM"] = {
                {LocalPNG = "resources/textures/bandeiras/lmf.png", TextureName = "remap"},
            },
            ["ADA"] = {
                {LocalPNG = "resources/textures/bandeiras/ada.png", TextureName = "remap"},
            },
            ["TDH"] = {
                {LocalPNG = "resources/textures/bandeiras/tdh.png", TextureName = "remap"},
            },
            ["TDJ"] = {
                {LocalPNG = "resources/textures/bandeiras/tdj.png", TextureName = "remap"},
            },
            ["YKZ"] = {
                {LocalPNG = "resources/textures/bandeiras/ykz.png", TextureName = "remap"},
            },
            ["CDC"] = {
                {LocalPNG = "resources/textures/bandeiras/cdc.jpg", TextureName = "remap"},
            },
            ["PAQUISTAO"] = {
                {LocalPNG = "resources/textures/bandeiras/paquistao.png", TextureName = "remap"},
            },
            ["TDN"] = {
                {LocalPNG = "resources/textures/bandeiras/tdn.png", TextureName = "remap"},
            },
            ["MLC"] = {
                {LocalPNG = "resources/textures/bandeiras/mlc.png", TextureName = "remap"},
            },
            ["ZNX"] = {
                {LocalPNG = "resources/textures/bandeiras/znx.png", TextureName = "remap"},
            },
            ["SLATT"] = {
                {LocalPNG = "resources/textures/bandeiras/slatt.png", TextureName = "remap"},
            },
            ["TDF"] = {
                {LocalPNG = "resources/textures/bandeiras/tdf.png", TextureName = "remap"},
            },
            ["TDT"] = {
                {LocalPNG = "resources/textures/bandeiras/tdt.png", TextureName = "remap"},
            },
            ["PCC"] = {
                {LocalPNG = "resources/textures/bandeiras/pcc.png", TextureName = "remap"},
            },
            ["4M"] = {
                {LocalPNG = "resources/textures/bandeiras/4m.png", TextureName = "remap"},
            },
            ["STD"] = {
                {LocalPNG = "resources/textures/bandeiras/std.png", TextureName = "remap"},
            },
            ["CDD"] = {
                {LocalPNG = "resources/textures/bandeiras/cdd.png", TextureName = "remap"},
            },
            ["TDM"] = {
                {LocalPNG = "resources/textures/bandeiras/tdm.png", TextureName = "remap"},
            },
        },
        [470] = {
            ["MCD"] = {
                {LocalPNG = "resources/textures/bandeiras/mcd.png", TextureName = "remap"},
            },
            ["MLC"] = {
                {LocalPNG = "resources/textures/bandeiras/mlc.png", TextureName = "remap"},
            },
            ["VK"] = {
                {LocalPNG = "resources/textures/bandeiras/vk.png", TextureName = "remap"},
            },
            ["BALLAS"] = {
                {LocalPNG = "resources/textures/bandeiras/ballas.png", TextureName = "remap"},
            },
            ["YKZ"] = {
                {LocalPNG = "resources/textures/bandeiras/ykz.png", TextureName = "remap"},
            },
            ["PCC"] = {
                {LocalPNG = "resources/textures/bandeiras/pcc.png", TextureName = "remap"},
            },
            ["TCP"] = {
                {LocalPNG = "resources/textures/bandeiras/tcp.png", TextureName = "remap"},
            },
            ["TDT"] = {
                {LocalPNG = "resources/textures/bandeiras/tdt.png", TextureName = "remap"},
            },
            ["CDD"] = {
                {LocalPNG = "resources/textures/bandeiras/cdd.png", TextureName = "remap"},
            },
            ["PCC"] = {
                {LocalPNG = "resources/textures/bandeiras/pcc.png", TextureName = "remap"},
            },
            ["CV"] = {
                {LocalPNG = "resources/textures/bandeiras/cv.png", TextureName = "remap"},
            },
            ["R7"] = {
                {LocalPNG = "resources/textures/bandeiras/r7.png", TextureName = "remap"},
            },
            ["PCC"] = {
                {LocalPNG = "resources/textures/bandeiras/pcc.png", TextureName = "remap"},
            },
            ["RODO"] = {
                {LocalPNG = "resources/textures/bandeiras/rodo.png", TextureName = "remap"},
            },
            ["STD"] = {
                {LocalPNG = "resources/textures/bandeiras/std.png", TextureName = "remap"},
            },
        },
        [429] = {
            ["BRASIL"] = {
                {LocalPNG = "resources/textures/bandeiras/brasil.png", TextureName = "remap"},
            },
            ["VK"] = {
                {LocalPNG = "resources/textures/bandeiras/vk.png", TextureName = "remap"},
            },
            ["YKZ"] = {
                {LocalPNG = "resources/textures/bandeiras/ykz.png", TextureName = "remap"},
            },
            ["PCC"] = {
                {LocalPNG = "resources/textures/bandeiras/pcc.png", TextureName = "remap"},
            },
            ["TDT"] = {
                {LocalPNG = "resources/textures/bandeiras/tdt.png", TextureName = "remap"},
            },
            ["TDN"] = {
                {LocalPNG = "resources/textures/bandeiras/tdn.png", TextureName = "remap"},
            },
        },
        [421] = {
            ["BRASIL"] = {
                {LocalPNG = "resources/textures/bandeiras/brasil.png", TextureName = "remap"},
            },
            ["GROTA"] = {
                {LocalPNG = "resources/textures/bandeiras/grota.png", TextureName = "remap"},
            },
            ["YKZ"] = {
                {LocalPNG = "resources/textures/bandeiras/ykz.png", TextureName = "remap"},
            },
            ["PCC"] = {
                {LocalPNG = "resources/textures/bandeiras/pcc.png", TextureName = "remap"},
            },
            ["4M"] = {
                {LocalPNG = "resources/textures/bandeiras/4m.png", TextureName = "remap"},
            },
            ["VK"] = {
                {LocalPNG = "resources/textures/bandeiras/vk.png", TextureName = "remap"},
            },
            ["CDD"] = {
                {LocalPNG = "resources/textures/bandeiras/cdd.png", TextureName = "remap"},
            },
        },

        [597] = {
            ["EB"] = {
                {LocalPNG = "resources/textures/597/eb.png", TextureName = "remap"},
            },
            ["DETRAN"] = {
                {LocalPNG = "resources/textures/597/detran.png", TextureName = "remap"},
            },
            ["PMPR"] = {
                {LocalPNG = "resources/textures/597/pmpr.png", TextureName = "remap"},
            },
            ["GOE"] = {
                {LocalPNG = "resources/textures/597/goe.png", TextureName = "remap"},
            },
            ["RONDESP"] = {
                {LocalPNG = "resources/textures/597/rondesp.png", TextureName = "remap"},
            },
            ["FN"] = {
                {LocalPNG = "resources/textures/597/fn.png", TextureName = "remap"},
            },
            ["RDP"] = {
                {LocalPNG = "resources/textures/597/rdp.png", TextureName = "remap"},
            },
            ["PSP"] = {
                {LocalPNG = "resources/textures/597/psp.png", TextureName = "remap"},
            },
            ["BMRS"] = {
                {LocalPNG = "resources/textures/597/bmrs.png", TextureName = "remap"},
            },
            ["DOF"] = {
                {LocalPNG = "resources/textures/597/dof.png", TextureName = "remap"},
            },
            ["CIOSAC"] = {
                {LocalPNG = "resources/textures/597/ciosac.png", TextureName = "remap"},
            },
            ["COE"] = {
                {LocalPNG = "resources/textures/597/coe.png", TextureName = "remap"},
            },
            ["PMMG"] = {
                {LocalPNG = "resources/textures/597/pmmg.png", TextureName = "remap"},
            },
            ["ROTA"] = {
                {LocalPNG = "resources/textures/597/rota.png", TextureName = "remap"},
            },
            ["PCERJ"] = {
                {LocalPNG = "resources/textures/597/pcerj.png", TextureName = "remap"},
            },
            ["PMESP"] = {
                {LocalPNG = "resources/textures/597/pmesp.png", TextureName = "remap"},
            },
            ["PMES"] = {
                {LocalPNG = "resources/textures/597/pmes.png", TextureName = "remap"},
            },
            ["SAMU"] = {
                {LocalPNG = "resources/textures/597/samu.png", TextureName = "remap"},
            },
            ["PMBA"] = {
                {LocalPNG = "resources/textures/597/pmba.png", TextureName = "remap"},
            },
            ["PCMG"] = {
                {LocalPNG = "resources/textures/597/pcmg.png", TextureName = "remap"},
            },
            ["FT"] = {
                {LocalPNG = "resources/textures/597/ft.png", TextureName = "remap"},
            },
            ["PRF"] = {
                {LocalPNG = "resources/textures/597/prf.png", TextureName = "remap"},
            },
            ["BPRAIO"] = {
                {LocalPNG = "resources/textures/597/bpraio.png", TextureName = "remap"},
            },
            ["PF"] = {
                {LocalPNG = "resources/textures/597/pf.png", TextureName = "remap"},
            },
            ["FAB"] = {
                {LocalPNG = "resources/textures/597/fab.png", TextureName = "remap"},
            },
            ["BAEP"] = {
                {LocalPNG = "resources/textures/597/baep.png", TextureName = "remap"},
            },
            ["PCESP"] = {
                {LocalPNG = "resources/textures/597/pcesp.png", TextureName = "remap"},
            },
            ["PMERJ"] = {
                {LocalPNG = "resources/textures/597/pmerj.png", TextureName = "remap"},
            },
        },
        [596] = {
            ["EB"] = {
                {LocalPNG = "resources/textures/596/eb.png", TextureName = "remap"},
            },
            ["PCERJ"] = {
                {LocalPNG = "resources/textures/596/pcerj.png", TextureName = "remap"},
            },
            ["PMERJ"] = {
                {LocalPNG = "resources/textures/596/pmerj.png", TextureName = "remap"},
            },
            ["SAMU"] = {
                {LocalPNG = "resources/textures/596/samu.png", TextureName = "remap"},
            },
            ["PRF"] = {
                {LocalPNG = "resources/textures/596/prf.png", TextureName = "remap"},
            },
            ["LSDP"] = {
                {LocalPNG = "resources/textures/596/lsdp.png", TextureName = "remap"},
            },
            ["PF"] = {
                {LocalPNG = "resources/textures/596/pf.png", TextureName = "remap"},
            },
            ["CORE"] = {
                {LocalPNG = "resources/textures/596/core.png", TextureName = "remap"},
            },
            ["COMANF"] = {
                {LocalPNG = "resources/textures/596/comanf.png", TextureName = "remap"},
            },
            ["BOPE"] = {
                {LocalPNG = "resources/textures/596/bope.png", TextureName = "remap"},
            },
            ["PCESP"] = {
                {LocalPNG = "resources/textures/596/pcesp.png", TextureName = "remap"},
            },
            ["COE"] = {
                {LocalPNG = "resources/textures/596/coe.png", TextureName = "remap"},
            },
            ["PSP"] = {
                {LocalPNG = "resources/textures/596/psp.png", TextureName = "remap"},
            },
            ["CHOQUE"] = {
                {LocalPNG = "resources/textures/596/choque.png", TextureName = "remap"},
            },
            ["ROTA"] = {
                {LocalPNG = "resources/textures/596/rota.png", TextureName = "remap"},
            },
            ["FT"] = {
                {LocalPNG = "resources/textures/596/ft.png", TextureName = "remap"},
            },
        },
        [598] = {
            ["PF"] = {
                {LocalPNG = "resources/textures/598/pf.png", TextureName = "remap"},
            },
            ["COT"] = {
                {LocalPNG = "resources/textures/598/cot.png", TextureName = "remap"},
            },
            ["PMESP"] = {
                {LocalPNG = "resources/textures/598/pmesp.png", TextureName = "remap"},
            },
            ["COE"] = {
                {LocalPNG = "resources/textures/598/coe.png", TextureName = "remap"},
            },
            ["BEPI"] = {
                {LocalPNG = "resources/textures/598/bepi.png", TextureName = "remap"},
            },
            ["PCERJ"] = {
                {LocalPNG = "resources/textures/598/pcerj.png", TextureName = "remap"},
            },
            ["FT"] = {
                {LocalPNG = "resources/textures/598/ft.png", TextureName = "remap"},
            },
            ["CHOQUE"] = {
                {LocalPNG = "resources/textures/598/choque.png", TextureName = "remap"},
            },
            ["BMRS"] = {
                {LocalPNG = "resources/textures/598/bmrs.png", TextureName = "remap"},
            },
            ["PRF"] = {
                {LocalPNG = "resources/textures/598/prf.png", TextureName = "remap"},
            },
            ["PCDF"] = {
                {LocalPNG = "resources/textures/598/pcdf.png", TextureName = "remap"},
            },
            ["PCESP"] = {
                {LocalPNG = "resources/textures/598/pcesp.png", TextureName = "remap"},
            },
            ["EB"] = {
                {LocalPNG = "resources/textures/598/eb.png", TextureName = "remap"},
            },
            ["PMERJ"] = {
                {LocalPNG = "resources/textures/598/pmerj.png", TextureName = "remap"},
            },
            ["PMMG"] = {
                {LocalPNG = "resources/textures/598/pmmg.png", TextureName = "remap"},
            },
            ["CORE"] = {
                {LocalPNG = "resources/textures/598/core.png", TextureName = "remap"},
            },
            ["MARINHA"] = {
                {LocalPNG = "resources/textures/598/marinha.png", TextureName = "remap"},
            },
            ["BOPE"] = {
                {LocalPNG = "resources/textures/598/bope.png", TextureName = "remap"},
            },
            ["ROTAM"] = {
                {LocalPNG = "resources/textures/598/rotam.png", TextureName = "remap"},
            },
            ["ROTA"] = {
                {LocalPNG = "resources/textures/598/rota.png", TextureName = "remap"},
            },
            ["PMBA"] = {
                {LocalPNG = "resources/textures/598/pmba.png", TextureName = "remap"},
            },
        },
        [490] = {
            ["PF"] = {
                {LocalPNG = "resources/textures/490/pf.png", TextureName = "remap"},
            },
            ["EB"] = {
                {LocalPNG = "resources/textures/490/eb.png", TextureName = "remap"},
            },
            ["CGR"] = {
                {LocalPNG = "resources/textures/490/cgr.png", TextureName = "remap"},
            },
            ["MARINHA"] = {
                {LocalPNG = "resources/textures/490/mb.png", TextureName = "remap"},
            },
            ["PMMG"] = {
                {LocalPNG = "resources/textures/490/pmmg.png", TextureName = "remap"},
            },
            ["COMANF"] = {
                {LocalPNG = "resources/textures/490/comanf.png", TextureName = "remap"},
            },
            ["GCM"] = {
                {LocalPNG = "resources/textures/490/gcm.png", TextureName = "remap"},
            },
            ["ROTAMMG"] = {
                {LocalPNG = "resources/textures/490/rotammg.png", TextureName = "remap"},
            },
            ["BOPE"] = {
                {LocalPNG = "resources/textures/490/bope.png", TextureName = "remap"},
            },
            ["CIOSAC"] = {
                {LocalPNG = "resources/textures/490/ciosac.png", TextureName = "remap"},
            },
            ["ABIN"] = {
                {LocalPNG = "resources/textures/490/abin.png", TextureName = "remap"},
            },
            ["DOF"] = {
                {LocalPNG = "resources/textures/490/dof.png", TextureName = "remap"},
            },
            ["PCERJ"] = {
                {LocalPNG = "resources/textures/490/pcerj.png", TextureName = "remap"},
            },
            ["PRF"] = {
                {LocalPNG = "resources/textures/490/prf.png", TextureName = "remap"},
            },
            ["FT"] = {
                {LocalPNG = "resources/textures/490/ft.png", TextureName = "remap"},
            },
            ["FT2"] = {
                {LocalPNG = "resources/textures/490/ft2.png", TextureName = "remap"},
            },
            ["ROTAM"] = {
                {LocalPNG = "resources/textures/490/rotam.png", TextureName = "remap"},
            },
            ["ROTA"] = {
                {LocalPNG = "resources/textures/490/rota.png", TextureName = "remap"},
            },
            ["SAMU"] = {
                {LocalPNG = "resources/textures/490/samu.png", TextureName = "remap"},
            },
            ["BAEP"] = {
                {LocalPNG = "resources/textures/490/baep.png", TextureName = "remap"},
            },
            ["PMPR"] = {
                {LocalPNG = "resources/textures/490/pmpr.png", TextureName = "remap"},
            },
            ["RONE"] = {
                {LocalPNG = "resources/textures/490/rone.png", TextureName = "remap"},
            },
            ["PSP"] = {
                {LocalPNG = "resources/textures/490/psp.png", TextureName = "remap"},
            },
            ["COE"] = {
                {LocalPNG = "resources/textures/490/coe.png", TextureName = "remap"},
            },
            ["TOR"] = {
                {LocalPNG = "resources/textures/490/tor.png", TextureName = "remap"},
            },
            ["PMERJ"] = {
                {LocalPNG = "resources/textures/490/pmerj.png", TextureName = "remap"},
            },
            ["PMBA"] = {
                {LocalPNG = "resources/textures/490/pmba.png", TextureName = "remap"},
            },
            ["GATE"] = {
                {LocalPNG = "resources/textures/490/gate.png", TextureName = "remap"},
            },
            ["COD"] = {
                {LocalPNG = "resources/textures/490/cod.png", TextureName = "remap"},  
            },
            ["PETO"] = {
                {LocalPNG = "resources/textures/490/peto.png", TextureName = "remap"},  
            },
        },
        [523] = {
            
            ["CHOQUE"] = {
                {LocalPNG = "resources/textures/523/choque.png", TextureName = "remap"},
            },
            ["MARINHA"] = {
                {LocalPNG = "resources/textures/523/mb.png", TextureName = "remap"},
            },
            ["PMMG"] = {
                {LocalPNG = "resources/textures/523/pmmg.png", TextureName = "remap"},
            },
            ["BAEP"] = {
                {LocalPNG = "resources/textures/523/baep.png", TextureName = "remap"},
            },
            ["EB"] = {
                {LocalPNG = "resources/textures/523/eb.png", TextureName = "remap"},
            },
            ["PSP"] = {
                {LocalPNG = "resources/textures/523/psp.png", TextureName = "remap"},
            },
            ["FAB"] = {
                {LocalPNG = "resources/textures/523/fab.png", TextureName = "remap"},
            },
            ["GIS"] = {
                {LocalPNG = "resources/textures/523/gis.png", TextureName = "remap"},
            },
            ["PC"] = {
                {LocalPNG = "resources/textures/523/pcesp.png", TextureName = "remap"},
            },
            ["CORE"] = {
                {LocalPNG = "resources/textures/523/corerj.png", TextureName = "remap"},
            },
            ["PCERJ"] = {
                {LocalPNG = "resources/textures/523/pcerj.png", TextureName = "remap"},
            },
            ["PF"] = {
                {LocalPNG = "resources/textures/523/pf.png", TextureName = "remap"},
            },
            ["PMBA"] = {
                {LocalPNG = "resources/textures/523/pmba.png", TextureName = "remap"},
            },
            ["PMESP"] = {
                {LocalPNG = "resources/textures/523/pmesp.png", TextureName = "remap"},
            },
            ["PRF"] = {
                {LocalPNG = "resources/textures/523/prf.png", TextureName = "remap"},
            },
            ["ROCAM"] = {
                {LocalPNG = "resources/textures/523/rocam.png", TextureName = "remap"},
            },
            ["ROTA"] = {
                {LocalPNG = "resources/textures/523/rota.png", TextureName = "remap"},
            },
            ["SAMU"] = {
                {LocalPNG = "resources/textures/523/samu.png", TextureName = "remap"},
            },
        },
        [585] = {
            ["FT"] = {
                {LocalPNG = "resources/textures/585/ft.png", TextureName = "remap"},
            },
            ["PF"] = {
                {LocalPNG = "resources/textures/585/pf.png", TextureName = "remap"},
            },
            ["PRF"] = {
                {LocalPNG = "resources/textures/585/prf.png", TextureName = "remap"},
            },
            ["EB"] = {
                {LocalPNG = "resources/textures/585/eb.png", TextureName = "remap"},
            },
            ["BOPE"] = {
                {LocalPNG = "resources/textures/585/bope.png", TextureName = "remap"},
            },
            ["MARINHA"] = {
                {LocalPNG = "resources/textures/585/marinha.png", TextureName = "remap"},
            },
            ["COE"] = {
                {LocalPNG = "resources/textures/585/coe.png", TextureName = "remap"},
            },
        },
        [497] = {
            ["COE"] = {
                {LocalPNG = "resources/textures/497/coe.png", TextureName = "remap"},
            },
            ["TNY"] = {
                {LocalPNG = "resources/textures/497/tny.png", TextureName = "remap"},
            },
            ["PRF"] = {
                {LocalPNG = "resources/textures/497/prf.png", TextureName = "remap"},
            },
            ["EB"] = {
                {LocalPNG = "resources/textures/497/eb.png", TextureName = "remap"},
            },
            ["BAEP"] = {
                {LocalPNG = "resources/textures/497/baep.png", TextureName = "remap"},
            },
            ["MARINHA"] = {
                {LocalPNG = "resources/textures/497/marinha.png", TextureName = "remap"},
            },
            ["SAMU"] = {
                {LocalPNG = "resources/textures/497/samu.png", TextureName = "remap"},
            },
        },
    },
}

function string:split(sep)
	local sep, fields = sep or ":", { }
	local pattern = string.format( "([^%s]+)", sep)

	self:gsub(pattern,
		function(c)
			fields[#fields + 1] = c
		end
	)

	return fields
end