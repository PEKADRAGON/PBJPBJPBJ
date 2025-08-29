MAX_DROP_DISTANCE = 200
ROD_OBJECT_ID = 338
ANIM_NAMES = {
  EXHAUST = {"fishing", "gg_katushka_idle"},
  IDLE = {"fishing", "gg_katushka_idle"},
  CAST = {"fishing", "gg_zabros"},
  PICK = {"fishing", "gg_pick_fish"},
  HOLDING = {"fishing", "gg_fih_idle"},
  THROW = {"GRENADE", "WEAPON_throw"}
}

--CATCH_TIME_MIN = 60000 / 2
--CATCH_TIME_MAX = 60000 * 3

CATCH_TIME_MIN = 6000 / 2
CATCH_TIME_MAX = 6000 * 1.5


FISHES = {
  {id = 108, name = 'Peixe 1'},
  {id = 109, name = 'Peixe 2'},
  {id = 110, name = 'Peixe 3'},
  {id = 111, name = 'Peixe 4'}, 
  {id = 112, name = 'Peixe 5'},
  {id = 113, name = 'Peixe 6'},
  {id = 114, name = 'Peixe 7'},
  {id = 115, name = 'Peixe 8'},
  {id = 116, name = 'Peixe 9'},
}

FISH_PRICE_MIN = 2500
FISH_PRICE_MAX = 3500

function sendPlayerMessage(srctype, ...)
    local arguments = {...};
    if srctype == "server" then
        return exports['guetto_notify']:showInfobox(arguments[1], arguments[3], arguments[2])
    end
    if srctype == "client" then
      return exports['guetto_notify']:showInfobox(arguments[2], arguments[1])
    end
end
