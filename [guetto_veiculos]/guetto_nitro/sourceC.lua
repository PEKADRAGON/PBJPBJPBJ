local nosLevel = 0
local nosPurple = false
local nosLevelAnimation = false
local nosRefill = 1.1
local nosRefillTime = 1000

addEvent("gotVehicleNosLevel", true)
addEventHandler("gotVehicleNosLevel", root,
  function (level, purple, anim, time, refillTime)
    nosPurple = purple
    level = level / 4

    if anim then
      nosLevelAnimation = {getTickCount(), nosLevel, level, time}
      nosRefillTime = refillTime - time
    end

    nosLevel = level
  end
)

local seelangStatImgHand = false
local seelangStaticImage = {}
local seelangStaticImageToc = {}
local seelangStaticImageUsed = {}
local seelangStaticImageDel = {}
local processSeelangStaticImage = {}
seelangStaticImageToc[0] = true
seelangStaticImageToc[1] = true
local seelangStatImgPre
function seelangStatImgPre()
  local now = getTickCount()
  if seelangStaticImageUsed[0] then
    seelangStaticImageUsed[0] = false
    seelangStaticImageDel[0] = false
  elseif seelangStaticImage[0] then
    if seelangStaticImageDel[0] then
      if now >= seelangStaticImageDel[0] then
        if isElement(seelangStaticImage[0]) then
          destroyElement(seelangStaticImage[0])
        end
        seelangStaticImage[0] = nil
        seelangStaticImageDel[0] = false
        seelangStaticImageToc[0] = true
        return
      end
    else
      seelangStaticImageDel[0] = now + 5000
    end
  else
    seelangStaticImageToc[0] = true
  end
  if seelangStaticImageUsed[1] then
    seelangStaticImageUsed[1] = false
    seelangStaticImageDel[1] = false
  elseif seelangStaticImage[1] then
    if seelangStaticImageDel[1] then
      if now >= seelangStaticImageDel[1] then
        if isElement(seelangStaticImage[1]) then
          destroyElement(seelangStaticImage[1])
        end
        seelangStaticImage[1] = nil
        seelangStaticImageDel[1] = false
        seelangStaticImageToc[1] = true
        return
      end
    else
      seelangStaticImageDel[1] = now + 5000
    end
  else
    seelangStaticImageToc[1] = true
  end
  if seelangStaticImageToc[0] and seelangStaticImageToc[1] then
    seelangStatImgHand = false
    removeEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre)
  end
end
processSeelangStaticImage[0] = function()
  if not isElement(seelangStaticImage[0]) then
    seelangStaticImageToc[0] = false
    seelangStaticImage[0] = dxCreateTexture("files/backfire_nitro2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[1] = function()
  if not isElement(seelangStaticImage[1]) then
    seelangStaticImageToc[1] = false
    seelangStaticImage[1] = dxCreateTexture("files/backfire_nitro.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
local screenX, screenY = guiGetScreenSize()
screenX, screenY = guiGetScreenSize()
local sceneTarget = dxCreateScreenSource(screenX, screenY)
dxUpdateScreenSource(sceneTarget, true)
local movieShader = dxCreateShader("files/nitro.fx")
dxSetShaderValue(movieShader, "sBaseTexture", sceneTarget)
local start = getTickCount() + 1000
local vehicleFOV = getCameraFieldOfView("vehicle")
local vehicleMaxFOV = getCameraFieldOfView("vehicle_max")
local effectState = false
local fires = {}
local ojjektumok = {}
addEvent("nosEffectState", true)
addEventHandler("nosEffectState", getRootElement(), function(state, purple)
  if isElement(source) and isElementStreamedIn(source) then
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh == source and state ~= "test" then
      setCameraFieldOfView("vehicle", vehicleFOV)
      setCameraFieldOfView("vehicle_max", vehicleMaxFOV)
      effectState = state
      if state then
        if purple then
          playSound("files/in.wav")
          dxSetShaderValue(movieShader, "r", 0.05)
          dxSetShaderValue(movieShader, "g", 0.15)
          dxSetShaderValue(movieShader, "b", -0.05)
        else
          playSound("files/ins.wav")
          dxSetShaderValue(movieShader, "r", 0.2)
          dxSetShaderValue(movieShader, "g", 0.1)
          dxSetShaderValue(movieShader, "b", -0.05)
        end
      end
    end
    if state then
      local vx, vy, vz = getElementPosition(source)
      local x, y, z = getVehicleModelExhaustFumesPosition(getElementModel(source))
      local sound = false
      --exports.v4_vehicles:setFumeDisable(source, state)
      if purple then
        sound = playSound3D("files/out.wav", vx, vy, vz)
      else
        sound = playSound3D("files/outs.wav", vx, vy, vz)
      end
      setSoundMaxDistance(sound, 50)
      setSoundVolume(sound, 0.5)
      local t = getTickCount()
      if state == "test" then
        for i = #fires, 1, -1 do
          if fires[i][1] == source then
            if isElement(fires[i][7]) then
              destroyElement(fires[i][7])
            end
            table.remove(fires, i)
          end
        end
        t = t - (15000 - 3640 * (purple and 1 or 0.6))
      end
      table.insert(fires, {
        source,
        x,
        y,
        z,
        0,
        false,
        sound,
        purple,
        t
      })
      if bitAnd(getVehicleHandling(source).modelFlags, 8192) == 8192 then
        table.insert(fires, {
          source,
          -x,
          y,
          z,
          0,
          false,
          false,
          purple,
          t
        })
      end
    else
      for i = #fires, 1, -1 do
        if fires[i][1] == source then
          fires[i][6] = true
        end
      end
    end
  end
end)
local p = 0
local eff = 0
function getVehicleSpeed(currentElement)
  if isElement(currentElement) then
    local x, y, z = getElementVelocity(currentElement)
    return math.sqrt(x ^ 2 + y ^ 2 + z ^ 2) * 187.5
  end
end
local s = 1.25
addEventHandler("onClientPreRender", getRootElement(), function(delta)
  local cx, cy, cz = getCameraMatrix()
  local vehMatrixes = {}
  for i = #fires, 1, -1 do
    if isElement(fires[i][1]) and getTickCount() - fires[i][9] <= 15000 then
      if fires[i][6] then
        if fires[i][5] > 0 then
          fires[i][5] = fires[i][5] - 2 * delta / 1000
          if fires[i][5] < 0 then
            fires[i][5] = 0
          end
        end
      elseif 1 > fires[i][5] then
        fires[i][5] = fires[i][5] + 3 * delta / 1000
        if 1 < fires[i][5] then
          fires[i][5] = 1
        end
      end
      local p = 0
      local p2 = 1
      if fires[i][6] then
        p = 1
        p2 = fires[i][5]
      else
        p = fires[i][5]
        p2 = 1
      end
      if vehMatrixes[fires[i][1]] == nil then
        local x, y, z = getElementPosition(fires[i][1])
        if getDistanceBetweenPoints3D(cx, cy, cz, x, y, z) <= 90 then
          vehMatrixes[fires[i][1]] = getElementMatrix(fires[i][1])
        end
      end
      local m = vehMatrixes[fires[i][1]]
      if m then
        local fx = fires[i][2]
        local fy = fires[i][3]
        local fz = fires[i][4]
        local x = fx * m[1][1] + fy * m[2][1] + fz * m[3][1] + m[4][1]
        local y = fx * m[1][2] + fy * m[2][2] + fz * m[3][2] + m[4][2]
        local z = fx * m[1][3] + fy * m[2][3] + fz * m[3][3] + m[4][3]
        if isElement(fires[i][7]) then
          setElementPosition(fires[i][7], x, y, z)
        end
        local sp = s * p
        seelangStaticImageUsed[1] = true
        if seelangStaticImageToc[1] then
          processSeelangStaticImage[1]()
        end
        seelangStaticImageUsed[0] = true
        if seelangStaticImageToc[0] then
          processSeelangStaticImage[0]()
        end
        local text = fires[i][8] and seelangStaticImage[0] or seelangStaticImage[1]
        local rx, ry, rz = -m[2][1], -m[2][2], -m[2][3]
        dxDrawMaterialSectionLine3D(x + rx * sp, y + ry * sp, z + rz * sp, x + rx * (s * (1 - p2)), y + ry * (s * (1 - p2)), z + rz * (s * (1 - p2)), math.random(0, 7) * 128, 256 * (1 - p), 128, 256 * p * p2, text, s / 2, tocolor(255, 255, 255, 200), false, x, y, z + 1)
        dxDrawMaterialSectionLine3D(x + rx * sp, y + ry * sp, z + rz * sp, x + rx * (s * (1 - p2)), y + ry * (s * (1 - p2)), z + rz * (s * (1 - p2)), math.random(0, 7) * 128, 256 * (1 - p), 128, 256 * p * p2, text, s / 2, tocolor(255, 255, 255, 200), false, x + 1, y, z)
        dxDrawMaterialSectionLine3D(x + rx * sp, y + ry * sp, z + rz * sp, x + rx * (s * (1 - p2)), y + ry * (s * (1 - p2)), z + rz * (s * (1 - p2)), math.random(0, 7) * 128, 256 * (1 - p), 128, 256 * p * p2, text, s / 2, tocolor(255, 255, 255, 200), false, x + 1, y, z + 1)
        dxDrawMaterialSectionLine3D(x + rx * sp, y + ry * sp, z + rz * sp, x + rx * (s * (1 - p2)), y + ry * (s * (1 - p2)), z + rz * (s * (1 - p2)), math.random(0, 7) * 128, 256 * (1 - p), 128, 256 * p * p2, text, s / 2, tocolor(255, 255, 255, 200), false, x - 1, y, z + 1)
      end
      if p2 <= 0 then
        if isElement(fires[i][7]) then
          destroyElement(fires[i][7])
        end
        table.remove(fires, i)
      end
    else
      if isElement(fires[i][7]) then
        destroyElement(fires[i][7])
      end
      table.remove(fires, i)
    end
  end
  local veh = getPedOccupiedVehicle(localPlayer)
  if effectState then
    if not veh then
      effectState = false
    end
    if p < 1 then
      p = p + 4 * delta / 1000
      if p > 1 then
        p = 1
      end
    end
  elseif p > 0 then
    p = p - 0.5 * delta / 1000
    if p < 0 then
      p = 0
      setCameraFieldOfView("vehicle", vehicleFOV)
      setCameraFieldOfView("vehicle_max", vehicleMaxFOV)
    end
  end
  if p > 0 then
    local speed = veh and getVehicleSpeed(veh) or 0
    eff = math.min(1, math.max(0, speed / 150 * p))
    dxSetShaderValue(movieShader, "blurValue", eff)
    setCameraFieldOfView("vehicle", vehicleFOV + 10 * eff)
    setCameraFieldOfView("vehicle_max", vehicleMaxFOV + 10 * eff)
  end
  if veh then
    if nosLevelAnimation then
      local p = (getTickCount() - nosLevelAnimation[1]) / nosLevelAnimation[4]

      if p > 1 then
        p = 1
      end

      nosLevel = nosLevelAnimation[2] + (nosLevelAnimation[3] - nosLevelAnimation[2]) * p

      if p >= 1 then
        nosRefill = 0
        nosLevelAnimation = false
      end
    elseif nosRefill < 1.1 then
      nosRefill = nosRefill + 1 * delta / nosRefillTime

      if nosRefill > 1.1 then
        nosRefill = 1.1
      end
    end
  end
end)
addEventHandler("onClientRender", getRootElement(), function()
  if p > 0 then
    dxUpdateScreenSource(sceneTarget, true)
    dxDrawImage(math.random(-1000, 1000) / 400 * eff, math.random(-1000, 1000) / 400 * eff, screenX, screenY, movieShader)
  end
end, true, "low-99999999")
