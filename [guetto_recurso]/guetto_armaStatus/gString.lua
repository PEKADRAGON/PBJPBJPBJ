STATS = {1000, 1000};

cSoundsEnabled = true
reloadSoundEnabled = false
explosionEnabled = false

WEAPONS_PROPERTIES = {
    [22] = { -- Glock
        Properties = {
            weapon_range = 40,
            target_range = 40,
            accuracy = 2,
            maximum_clip_ammo = 20,
            --anim_loop_start = 0.07,
            --anim_loop_stop = 0.23,
            --anim_loop_bullet_fire = 0.07,
            --anim2_loop_start = 0.21000001788139,
            --anim2_loop_stop = 0.35399999856949,
            --anim2_loop_bullet_fire = 0.2100001788139,
            damage = 20
        },
        Headshot = 6,
    },
    [23] = { -- Silenced (Teaser)
        Properties = {
            weapon_range = 16,
            target_range = 16,
            accuracy = 1,
            maximum_clip_ammo = 1,
            damage = 0,
        },
        Headshot = 2424,
    },
    [25] = { -- Shotgun
        Properties = {
            weapon_range = 5,
            target_range = 5,
            accuracy = 4,
            maximum_clip_ammo = 8,
            damage = 20
        },
        Headshot = 1,
    },
    [27] = { -- Shotgun 2
    Properties = {
        weapon_range = 10,
        target_range = 10,
        accuracy = 4,
        maximum_clip_ammo = 3,
        damage = 10,
    },
    Headshot = 1,
    },
    [28] = { -- Uzi [ glock rajada ]
        Properties = {
            weapon_range = 35,
            target_range = 35,
            accuracy = 4,
            maximum_clip_ammo = 30,
            damage = 25,
        },
        Headshot = 3,
    },
    [29] = { -- MP-5
        Properties = {
            weapon_range = 35,
            target_range = 35,
            accuracy = 4,
            maximum_clip_ammo = 25,
            damage = 10,
        },
        Headshot = 3,
    },
    [30] = { -- AK-47
        Properties = {
            weapon_range = 160,
            target_range = 160,
            damage = 10,
            accuracy = 0.35,
            maximum_clip_ammo = 45,
        },
        Headshot = 4,
    },
    [31] = { -- M4
        Properties = {
            weapon_range = 190,
            target_range = 190,
            damage = 10,
            accuracy = 0.5,
            maximum_clip_ammo = 100,
        },
        Headshot = 4,
    },
    [34] = { -- Sniper
        Properties = {
            damage = 300,
            maximum_clip_ammo = 1,
        },
        Headshot = 4,
    },
    [33] = { -- Sniper2
        Properties = {
            damage = 200,
            maximum_clip_ammo = 5,
        },
        Headshot = 4,
    },
    [8] = { -- Katana
        Properties = {
            damage = 50,
            maximum_clip_ammo = 1,
        },
        Headshot = 0,
    },
    [32] = { -- Tec - 9
    Properties = {
        weapon_range = 35,
        target_range = 35,
        accuracy = 4,
        maximum_clip_ammo = 30,
        damage = 10,
    },
    Headshot = 3,
},
};

VIPS = {"Console"}