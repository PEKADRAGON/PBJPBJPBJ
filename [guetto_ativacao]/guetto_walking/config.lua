config = {
    ['animation'] = {
        [1] = {
            ifp = 'ifps/male.ifp', 
            skin = 1,
            replaces = {
                'WALK_player', 'sprint_civi', 'run_player', 'Run_stop', 'Run_stopR', 'WEAPON_crouch', 
                'Player_Sneak_walkstart', 'Player_Sneak', 'WALK_armed', 'run_armed', 'run_armed1',
                'GunCrouchFwd', 'GunCrouchBwd', 'GunMove_BWD', 'GunMove_FWD', 'GunMove_L', 'GunMove_R',
                'cower', 'Crouch_Roll_L', 'Crouch_Roll_R', 'CAR_align_RHS', 'CAR_align_LHS', 'CAR_close_RHS', 'CAR_close_LHS',
                'JUMP_launch', 'JUMP_launch_R', 'JUMP_land', 'JUMP_drive', 'JUMP_glide',
            },
        },
        [2] = {
            ifp = 'ifps/female.ifp', 
            skin = 2,
            replaces = {
                'WALK_player', 'sprint_civi', 'run_player', 'Run_stop', 'Run_stopR', 'WEAPON_crouch', 
                'Player_Sneak_walkstart', 'Player_Sneak', 'WALK_armed', 'run_armed', 'run_armed1',
            },
        },
    }
}
-- 'IDLE_stance'