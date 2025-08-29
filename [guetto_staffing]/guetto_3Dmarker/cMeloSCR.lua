local sx, sy = guiGetScreenSize()
local zoom = 1
local baseX = 1900
local minZoom = 2
if sx < baseX then
  zoom = math.min(minZoom, baseX/sx)
end

ringTexture = dxCreateTexture("files/images/ring.png")

local prebuildedTexts = {
  ["exit"] = {"Saída", "Volte ao mundo."},
  --["exitInt"] = {"Wyjście", "Wyjście z pomieszczenia."},
  --["house-free"] = {"Posiadłość", "Ta posiadłość jest wolna i możesz ją zakupić."},
  --["house-bought"] = {"Posiadłość", "Ta posiadłość została już przez kogoś wykupiona."},
  --["garage"] = {"Parking", "Wjedź prywatnym pojazdem aby oddać go na przechowanie."},
  --["mechanic"] = {"Mechanik samochodowy", "Rozpoczęcie lub zakończenie służby jako mechanik."},
  --["taxi"] = {"Taxi Center", "Rozpoczęcie lub zakończenie służby jako teksówkarz."},
  --["police"] = {"Posterunek Policji", "Rozpoczęcie lub zakończenie służby jako policjant."},
  --["medic"] = {"Posterunek Medyczny", "Rozpoczęcie lub zakończenie służby jako ratownik medyczny."},
  --["fire"] = {"Posterunek Straży", "Rozpoczęcie lub zakończenie służby jako strażak."},
  --["fractionc"] = {"Biuro Fraction Center", "Rozpoczęcie lub zakończenie służby jako kierownik frakcji."},
  --["ers"] = {"Emergency Road Services", "Rozpoczęcie lub zakończenie służby jako pracownik pomocy drogowej."},
  --["tv"] = {"Interglobal Television", "Wejście do biura telewizyjnego."},
  --["news"] = {"AllOutMusic", "Rozpoczęcie lub zakończenie służby jako reporter radiowy."},
  --["carwash"] = {"Myjnia samochodowa", "Wjedź w marker aby skorzystać z myjni."},
  --["noParking"] = {"Zakaz parkowania", "Prosimy osoby nieupoważnione o nieparkowanie w tym miejscu.\nGrozi odholowaniem!"},
  --["office"] = {"Biurowiec organizacji", "Wejście do biura organizacji."},
  --["gun"] = {"Ammunation", "Wejście do sklepu z bronią."},
  --["bulb"] = {"Tuning wizualny", "Wjazd do garażu tunera wizualnego."},
  --["piston"] = {"Tuning osiągów", "Wjazd do garażu tunera osiągów."},
}

MarkerStreamer = {}
MarkerStreamer.__index = MarkerStreamer

function MarkerStreamer:create(...)
  local instance = {}
  setmetatable(instance, MarkerStreamer)
  if instance:constructor(...) then
    return instance
  end
  return false
end

function MarkerStreamer:constructor(...)  
  self.markerCol = createColSphere(0, 0, 0, 60)
  attachElements(self.markerCol, localPlayer)

  self.icons = {}
  self.targets = {}
  self.streamed = {}

  self.sizeScale = 0.15
  self.maxDist = 80
  self.refreshTick = getTickCount()
  self.refreshTime = 5000

  self.animTick = getTickCount()
  self.animState = "up"
  self.anim = 0

  self.fonts = {}
  self.fonts.title = dxCreateFont("files/fonts/Roboto-Medium.ttf", 40)
  self.fonts.desc = dxCreateFont("files/fonts/Roboto-Regular.ttf", 24)

  self.func = {}
  self.func.renderer = function(...) self:render(...) end
  self.func.maximize = function(...) self:cleanUp(...) end
  self.func.onColshapeLeave = function(...) self:onColshapeLeave(...) end
  addEventHandler("onClientRender", root, self.func.renderer)
  addEventHandler("onClientRestore", root, self.func.maximize)
  addEventHandler("onClientColShapeLeave", root, self.func.onColshapeLeave)
  return true
end

function MarkerStreamer:onColshapeLeave(el)
  if not isElement(el) then return end
  if getElementType(el) ~= "marker" then return end
  self:destroyMarker(el)
end

function MarkerStreamer:createIcon(...)
  if arg[2] then
    local orgImg = "files/images/logo.png"
    if orgImg then
      self.icons[arg[1]] = dxCreateTexture(orgImg, "argb", true, "clamp")
      return self.icons[arg[1]]
    end
  end

  if not fileExists("files/images/"..arg[1]..".png") then return false end
  self.icons[arg[1]] = dxCreateTexture("files/images/"..arg[1]..".png", "argb", true, "clamp")
  return self.icons[arg[1]]
end

function MarkerStreamer:getIcon(...)
  local icon, isOrg = self:prepareIconText(arg[1], arg[2])
  if self.icons[icon] then
    return self.icons[icon], icon
  else
    return self:createIcon(icon, isOrg), icon
  end
end

function MarkerStreamer:prepareIconText(...)
  if isElement(arg[1]) then
    arg[1] = arg[2]
  end

  if string.find(arg[1], "-") then
    local icon = split(arg[1], "-")
    return icon[1]
  end
  return arg[1]
end

function MarkerStreamer:getPrebuildedText(marker, icon, data)

  local text = prebuildedTexts[icon]
  if data then return data.title, data.desc end
  if string.find(icon, "-") then
    local pre = split(icon, "-")
    if prebuildedTexts[pre[2]] then
      text = prebuildedTexts[pre[2]]
    end
  end
  if not text then return false, false end
  return text[1], text[2]
end


function MarkerStreamer:createTarget(marker, icon, r, g, b, data)
  if not marker or not icon then return false end

  self.targets[marker] = {
    target = dxCreateRenderTarget(700, 700, true),
  }

  self:updateTarget(marker, icon, r, g, b, data)
  return self.targets[marker].target
end

function MarkerStreamer:updateTarget(marker, icon, r, g, b, data)
  if not marker or not icon then return false end
  local title, desc = self:getPrebuildedText(marker, icon, data)
  local markerIcon, iconName = self:getIcon(marker, icon)

  self.targets[marker].icon = iconName

  dxSetRenderTarget(self.targets[marker].target, true)
  --dxDrawImage(250, 0, 200, 200, self:getIcon("marker"), 0, 0, 0, tocolor(150,150,150, 255))
  dxDrawImage(286, 20, 128, 128, markerIcon, 0, 0, 0, iconName == "map" and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 255))

  if title then dxDrawText(title, 0, 220, 700, 700, tocolor(255, 255, 255, 255), 1, self.fonts.title, "center", "top") end
  if desc then dxDrawText(desc, 0, 300, 700, 700, tocolor(255, 255, 255, 255), 1, self.fonts.desc, "center", "top", true, true) end
  dxSetRenderTarget()
end

function MarkerStreamer:getMarker(marker, icon, r, g, b, data)
  if not marker then return false end
  if self.targets[marker] then
    return self.targets[marker].target
  else
    return self:createTarget(marker, icon, r, g, b, data)
  end
end

function MarkerStreamer:destroyMarker(marker)
  if not marker then return false end
  if self.targets[marker] then
    local icon = self.targets[marker].icon

    if isElement(self.targets[marker].target) then destroyElement(self.targets[marker].target) end
    self.targets[marker] = nil

    for i, v in pairs(self.targets) do
      if v.icon == icon then
        return
      end
    end
    if isElement(self.icons[icon]) then
      destroyElement(self.icons[icon])
      self.icons[icon] = nil
    end
  end
end


function MarkerStreamer:cleanUp(...)
  for marker, _ in pairs(self.targets) do
    if isElement(marker) then
      local r, g, b = getMarkerColor(marker)
      local data = getElementData(marker, "markerData")

      if data.icon then
        self:updateTarget(marker, data.icon, r, g, b, data)
      end

    else
      self:destroyMarker(marker)
    end
  end
end


function MarkerStreamer:clean()
  if (getTickCount() - self.refreshTick)/self.refreshTime >= 1 then
    self.refreshTick = getTickCount()
    self:cleanUp()
  end
end

function MarkerStreamer:render()
  self:animate()
  self:clean()
  local playerPos = Vector3(getElementPosition(localPlayer))
  local int = getElementInterior(localPlayer)
  local dim = getElementDimension(localPlayer)
  local markers = getElementsWithinColShape(self.markerCol, "marker")
  for _, marker in ipairs(markers) do
    if getMarkerType(marker) == "cylinder" then
      local x, y, z = getElementPosition(marker)
      local dist = getDistanceBetweenPoints3D(playerPos, x, y, z)

      if dist < self.maxDist and int == getElementInterior(marker) and dim == getElementDimension(marker) then
        local r, g, b = getMarkerColor(marker)
        local data = getElementData(marker, "markerData")
        local alpha = math.max(math.min((self.maxDist - dist)/40, 1), 0)
        if data then
          if data.icon then
            local markerImg = self:getMarker(marker, data.icon, r, g, b, data)
            if markerImg then dxDrawMaterialLine3D(x, y, z + 1.5 + self.sizeScale * self.anim, x, y, z + 0 + self.sizeScale * self.anim, markerImg, 1.5, tocolor(255, 255, 255, 255 * alpha)) end
            local msz = getMarkerSize( marker ) + self.sizeScale * self.anim
            local direction = 0
		        local ox = math.cos(direction) * msz / 2
		        local oy =  math.sin(direction) * msz / 2
            dxDrawMaterialLine3D(x + ox, y + oy, z, x - ox, y - oy, z, ringTexture, msz, tocolor(255, 255, 255, 255 * alpha), false, x, y, z + 1)
          end
        end
      else
        self:destroyMarker(marker)
      end
    end
  end
end






function MarkerStreamer:animate()
  if self.animState == "up" then
    local progress = (getTickCount() - self.animTick)/2000
    self.anim = interpolateBetween(0, 0, 0, 1, 0, 0, progress, "InOutQuad")
    if progress >= 1 then
      self.animState = "down"
      self.animTick = getTickCount()
    end

  elseif self.animState == "down" then
    local progress = (getTickCount() - self.animTick)/2000
    self.anim = interpolateBetween(1, 0, 0, 0, 0, 0, progress, "InOutQuad")
    if progress >= 1 then
      self.animState = "up"
      self.animTick = getTickCount()
    end
  end
end


MarkerStreamer:create()

function getMarkerDataByIcon(icon)
  local text = prebuildedTexts[icon]
  if string.find(icon, "-") then
    local pre = split(icon, "-")
    if prebuildedTexts[pre[2]] then return prebuildedTexts[pre[2]] end
  end
  if not text then return false end
  return text
end