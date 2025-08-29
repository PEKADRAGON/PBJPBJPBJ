local sWidth, sHeight = guiGetScreenSize()
local barWidth, barHeight = 436, 40
local barX, barY = sWidth / 2 - barWidth / 2, sHeight - 100

local handleWidth, handleHeight = 180, 30
local handleX, handleY = barX - 10, barY + 5

local fishWidth, fishHeight = 47, 23
local fishX, fishY = handleX + 15, handleY + 4

local fishMinX, fishMaxX = barX + 20, barX + barWidth - fishWidth - 20

local progressBarWidth = 0
local progressStep = 0.3

local fishDirection = "right"
local fishSpeed = 2
local handleSpeed = fishSpeed + 1

local keys = {}

local BLUE = tocolor(5, 118, 182, 220)
local WHITE = tocolor(255, 255, 255, 220)
local RED = tocolor(143, 68, 68, 220)

local cooldownTimer = nil
local cooldownGoing = false
local faults = 0

local gameStarted = false
local minigameActive = false

function start()
  minigameActive = true
  reset()
  addEventHandler("onClientKey", root, keyHandler)
  addEventHandler("onClientRender", root, render)
  setElementData(localPlayer, "BloqHud", true)

  setTimer(function()
    gameStarted = true
  end, 5000, 1)

  setTimer(setRandomSpeed, 5000, 5)
end

addEvent("startFishingMinigame", true)
addEventHandler("startFishingMinigame", root, start)

function stop()
  if minigameActive then
    removeEventHandler("onClientKey", root, keyHandler)
    removeEventHandler("onClientRender", root, render)
    setElementData(localPlayer, "BloqHud", false)
  end
  minigameActive = false

  reset()
end

addEvent("stopFishingMinigame", true)
addEventHandler("stopFishingMinigame", root, stop)


function reset()
  handleX, handleY = barX - 10, barY + 5
  fishX, fishY = handleX + 15, handleY + 4
  fishMinX, fishMaxX = barX + 20, barX + barWidth - fishWidth - 20
  fishDirection = "right"
  fishSpeed = 2
  handleSpeed = fishSpeed + 1
  progressBarWidth = 0
  faults = 0

  cooldownGoing = false
  gameStarted = false
  cooldownTimer = nil
end

function progressBarFinished()
  setElementData(localPlayer, "FinishedFishing", true)
  triggerEvent("onFishingMinigameSucceeded", resourceRoot)
end

function keyHandler(button, state)
  keys[button] = state
end

function drawOutline(x, y, sx, sy, color, size)
  dxDrawRectangle(x, y, size, sy, color)
  dxDrawRectangle(x + sx - size, y, size, sy, color)
  dxDrawRectangle(x, y, sx, size, color)
  dxDrawRectangle(x, y + sy - size, sx, size, color)
end

function setRandomSpeed()
  fishSpeed = math.random(3, 5)
  handleSpeed = fishSpeed + 1
end
setRandomSpeed()

function render()
  local isBehindFish = isInArea(fishX, handleX, handleX + handleWidth - 50)

  dxDrawRectangle(barX, barY, barWidth, barHeight, BLUE)
  dxDrawImage(handleX, handleY, handleWidth, handleHeight, "files/handle.png", 0, 0, 0, tocolor(53, 50, 45, 220))
  dxDrawImage(fishX, fishY, fishWidth, fishHeight, "files/fishicon.png", 0, 0, 0, isBehindFish and WHITE or RED)

  drawOutline(barX, barY, barWidth, barHeight, tocolor(30, 30, 30, 255), 4)
  drawOutline(barX + 4, barY + 4, barWidth - 8, barHeight - 8, tocolor(255, 255, 255, 25), 1)
  dxDrawRectangle(barX, barY - 10, barWidth, 10, tocolor(30, 30, 30, 220))
  dxDrawRectangle(barX + 5, barY - 5, progressBarWidth, 4, BLUE)

  if not gameStarted then return end

  if fishDirection == "right" and fishX > fishMaxX then
    fishDirection = "left"
  end

  if fishDirection == "left" and fishX < fishMinX then
    fishDirection = "right"
  end

  if fishDirection == "right" then
    fishX = fishX + fishSpeed
  else
    fishX = fishX - fishSpeed
  end

  if keys["arrow_l"] then
    handleX = math.max(barX - 10, handleX - handleSpeed)
  end

  if keys["arrow_r"] then
    handleX = math.min(barX + barWidth - handleWidth, handleX + handleSpeed)
  end

  progressBarWidth = progressBarWidth + progressStep

  if progressBarWidth >= barWidth - 10 then
    cooldownGoing = true
    progressBarFinished()
    stop()
  end

  if not isBehindFish and not cooldownGoing then
    faults = faults + 1
    cooldownGoing = true
    playSound(":crp_minigames/files/wrong.wav")

    if faults > 3 then
      stop()
      triggerEvent("onFishingMinigameFailed", localPlayer)
    end

    cooldownTimer = setTimer(function()
      cooldownGoing = false
    end, 1200, 1)
  end
end

function isInArea(x, xmin, xmax)
  return x >= xmin and x <= xmax or false
end
