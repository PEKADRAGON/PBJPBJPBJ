config = {
    ['modules'] = {
        ['AntiVPN'] = {
            ['state'] = true,
            ['keyAPI'] = 'dae700584980178404cfc2468edae0ba',
            ['commandWhitelist'] = 'addwhitelist',

            ['webhook'] = 'https://media.guilded.gg/webhooks/f91ab4d8-b3e6-40fc-a31b-bce28b08f7e4/ugYtUfLTzMe006W6sSyKqA2OAogwISKiokwIEYGCAiCmMEyuoMsUMKSaWWqqqwiSMyagOYSeCCQuuKoKKUK28K',
        },

        ['PrintSuspect'] = {
            ['state'] = false,
            ['action'] = 'ban',
            ['command'] = 'print',

            ['items'] = {
                ['insert'] = true,
                ['F12'] = true,
                ['F10'] = true,
                ['esc'] = true,
                ['home'] = true,
                ['delete'] = true,
                ['pause'] = true,
                ['='] = true,
            },

            ['webhook'] = 'https://discord.com/api/webhooks/1262110181953638612/w5ajj6YbdUeCzxsxHdWK9p4zcbAVSWGYF5XHoHl-jr23p__x00rFflXiLape7-zY8kF3',
        },

        ['Anti-Weapon'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['items'] = {
                [35] = true,
                [33] = true, 
                [36] = true, 
                [37] = true, 
                [38] = true, 
                [16] = true, 
                [18] = true, 
                [39] = true, 
                [40] = true,
            },

            ['webhook'] = 'https://media.guilded.gg/webhooks/2d2c1926-c2c4-4741-a2aa-d327fef9d070/K5ExfOkV0YusWqQa6CEIUUEsIa4w2wksymg8iAcOwIIYS4qUuemOGS40SI6kOaUg4giw8eaE6iKMykYUuMGuIs',
        },

        ['Anti-Stop'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/0bc7338e-2033-4cba-97bd-c1657bc7804d/ajH9YTd3HisWyoSGAQMkskYIioUmsCwCOGoyCYm2OGYmGOgOEIQEQYAQY4qY6sYKIgkm0YSQY8I6IU4wQCWUqi',
        },

        ['Anti-WeaponFire'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/61e05cd5-afe5-4423-96da-3f290a3bd05a/MZeTAJClMIwM4CoSoQQCwMIQs86uImgii4kWuumsEW8Cgm6soYACoiwOSAyg8QIuU6YGU8gOegoEiiKAq46K4Y',
        };
        
        ['Anti-VBR'] = {
            ['state'] = false,
            ['action'] = 'kick',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/d82c9ad5-5456-43e6-b795-2c224da76915/pmDcF33xXUk6EIIAKMaksSUQsqCIYwgeooai0mwweQKgaWMe2WewMKCWm8aaiWQyciCeum8aiKgYWMi2QYOeUW',
        },

        ['Anti-Invisible'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/2ddee9ef-2bc9-4016-aedc-d922d00bef72/NokCqBjUQgEKsy6GOSEeciUk8OCGYMssKg4wE0K2QGwe8SWuw8cgIAYIOOMYscMccKqCuiCMQ0IY2u6meWMss0',
        },
        ['Anti-Jetpack'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff", "Patrocinador"};
                ["element.data"] = {"onProt"};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/39bb5005-7e31-4389-baeb-08564678c1fc/mfQZZPXlJei0A2Yw86agCSck4q4EcuKIGyMik4AkwmU8CYeEMYa0swMi6Yyu0YGQIk4seQkWyUewaaEkUCiWws',
        },
        ['Anti-Fly'] = {
            ['state'] = true,
            ['action'] = 'warning',

            ["bypass"] = {
                ["acls"] = {"Console", 'Staff'};
                ["element.data"] = {"onProt", "Grudado", "SQUADY.carregado"};
            };
            
            ['webhook'] = 'https://media.guilded.gg/webhooks/c8c96c53-8859-49c6-aab5-b61f28253d1e/fW5S6kWoxM0igSakeUE02a0ICI8I4cuYsOg64KUAiQCqC6AOcM0q80qAUMoMg06W4KuYMEi4AWuK2M2mSsMk66',
        },
        ['Anti-Explosions'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['items'] = {
                [0] = true,
                [1] = true, 
                [2] = false, 
                [3] = true, 
                [4] = false, 
                [5] = true, 
                [6] = true, 
                [7] = true, 
                [8] = true, 
                [9] = false, 
                [10] = true, 
                [11] = true,
            },

            ['webhook'] = 'https://media.guilded.gg/webhooks/223190ef-b18f-4d23-a41e-fee12c089943/EKPKpw1NokUWWQEEymMc2SYA4wIq4e4us6AyWEKiqa2YQsuAkwGa6SAu04UGyAs0oGC2g6GmaycgaqgY62KoQU',
        },
        ['Anti-Projectile'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/5e774d5e-4448-4f6e-9596-6a8e45d2b522/jlXK2M3lPa6yIu8coC0yQyW0CGwY04WAI4MqmQmIcigamyQy8GKIsOuGwgWOKeQkAQmIScIkAMaiO4YOUw4OEo',
        },
        ['Anti-FastFire'] = {
            ['state'] = true,
            ['action'] = 'kick',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/248a250f-15ab-4a9e-a48c-3af6ed7546e3/WmyKTBw4kEYCGmiYwe68yUqM6IiIAuiGOwmAAgiCQYgIYWwEikQ4eWqMcYaSWe00g8eiCMwcUMGGuoiagCKAK8',
        },
        ['Anti-Vehicle'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['items'] = {
                [425] = true,
                [520] = true, 
                [432] = true, 
                [590] = true, 
                [538] = true, 
                [570] = true, 
                [569] = true, 
                [537] = true, 
                [449] = true, 
                [464] = true,

            },

            ['webhook'] = 'https://media.guilded.gg/webhooks/74415e55-4eb5-495c-996c-2881d5091357/rW7PZTyg48Q0OKCMem0oMWW4oSwuWQSioGkCQskggcwcMqMaO86g08YwcSMiocEQcyESEuIE6yawowsIEGOmMm',
        },
        ['Anti-Speed'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/f96d1565-28dd-4b8f-928e-85e03ddd173d/gk9MeyyETYGmOwAUYumCkMgciomsaq0EOmakWQSiWGGaguQao6YYoQwk2McQUc6OEWImWmW8w6c60KwMICOGWG',
        },
        ['Anti-Executor'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/e91bf838-3070-4c13-abda-dfddb9ee898b/BDfhVLkg1imgmeEaUGIKowE4KscciG8GCiWaWW6uSIwE4uOWs64e0iaSACCq2e4sI0kiS46MIyseskY2IIUgKe',
        },
        ['Anti-TriggerExists'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/0ca5828b-e33c-41ca-80b8-a36a9035371f/UaN5xrviQ6MiO0GsMWUkg0CE8kIU0Ae8go2UCyYsAi0mKYuowUuKSQ4CcsemmA8yqqCyCiIiGqq8s4q6WmyGQq',
        },
        ['Anti-ChangeData'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['items'] = {
                ['ID'] = true,
                ["Exp"] = true,
                ["Level"] = true,
                ["Emprego"] = true,
                ["onProt"] = true,
                ["guetto.points"] = true,
                ['battle.level'] = true,
            },

            ['webhook'] = 'https://media.guilded.gg/webhooks/8598495e-8cb8-45d1-a64b-4ed1f20ba5b7/LEefEwCRqeGcs8cIC6Ko4go4AGuI00SgGuS6qySGY0Sy4S84ig6cyEa6Ia4qwWWsEugSYCsoWUoM8AEAi4QECc',
        },
        ['Anti-CarFucker'] = {
            ['state'] = true,
            ['action'] = 'warning',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };
            
            ['webhook'] = 'https://media.guilded.gg/webhooks/3be8200a-d957-4f57-9e8d-ff38e112bf92/KY2x0SXjmo6GEwMgQOqSOkeMAYYq0sQGO0wC2oKGaYiMgkgMK0Omg28wMUeamEiSGcucUwiog2wKK4U4AUA4WO',
        },
        ['Anti-Block'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/c9e6a5ae-7da4-4188-a0f0-8ce08a597fc9/iX35Pf9ZL2Qs2kMm2s8GaECgaaEOM2q4GYEEUwuOiMQc6MEIekCyE28KGGoi2wyQs8y2SokM4O8MeMyOq68ESw',
        },
        ['Anti-Gui'] = {
            ['state'] = false,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/07f3c046-5c67-4cac-a6ea-6f61ac69a732/3KW4eQLOEgo8E0gcI20UcOmm6gkegemYuwEKmkMcKwQcYkAGqqQIIS0w2O2ys0WoigSOY6G4wcYuOkg6OMkuYs',
        },
        ['Anti-Trigger'] = {
            ['state'] = true,
            ['action'] = 'ban',

            ["bypass"] = {
                ["acls"] = {"Console", "Staff"};
                ["element.data"] = {"onProt"};
            };

            ['Triggers'] = {
                ['PEGASUS_AC'] = {
                    ['Pegasus.DetectSpoofer'] = true,
                    ['Pegasus.detectCheaters'] = true,
                    ['Pegasus.ReceiverPrintFromClient'] = true,
                    ['Pegasus.onPlayerSendServerCod'] = true,
                    ['onPlayerGetInfos'] = true,
                },
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/21d49663-c70b-42a0-8559-1f4c36a3c15c/7P0yHqEi5OyEQkI6c48Awuiaeqa2cOQ6AG0yGcqIomooauMkSOu2q6MKEoOgQIKWsKWySOOmAo4eYUQ8s84ukQ',
        },
        ['Anti-FakeWeapon'] = {
            ['state'] = true,
            ['action'] = 'warning',

            ["bypass"] = {
                ["acls"] = {};
                ["element.data"] = {};
            };

            ['webhook'] = 'https://media.guilded.gg/webhooks/2f5c75f3-f72f-4b13-9eae-741bfb2ab73d/Q07KANaBwGWkKGkUyKeiyswYkKGMG2K2aKUmOIqMs08sWEg6k4wiU8eUUCqEYmOQy8yikyC0A2sCeWGG8kYM8u',
        },
        ['Anti-Spoofer'] = {
            ['state'] = true,

            ['webhook'] = 'https://media.guilded.gg/webhooks/bb093f88-c268-4e0b-ab10-56d310316100/xeYSMKejCg8kmYKoCU8OImGgcKkO8cOOOQCIs8eEWasSOycso2q0gCcY6woiiqSWyeqmY4UUSqaqS0ioC0i4qs',
        },
    },
}

notifyC = function(message, type)
    return exports['guetto_notify']:showInfobox(type, message)
end

notifyS = function(player, message, type)
    return exports['guetto_notify']:showInfobox(player, type, message)
end