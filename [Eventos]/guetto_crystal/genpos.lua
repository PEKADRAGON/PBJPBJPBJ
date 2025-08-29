local t = {}



local i = 1

local countPoints = 10



function startGen ()

	local posX, posY = math.random (-3000, 3000), math.random(-3000, 3000)

	

	setCameraMatrix (Vector3(posX, posY, 600), Vector3(posX, posY, 0))

	

	setTimer (function()

		local z = getGroundPosition (posX, posY, 100)

		

		setCameraMatrix (Vector3(posX, posY, z + 100), Vector3(posX, posY, z))

		

		if i > countPoints then

			setCameraTarget (localPlayer)

			outputText ()

			i = 1

			fadeCamera (true)

			removeEventHandler ("onClientRender", root, drawW)

		else

			if z <= 0 then

				setTimer(startGen, 50, 1)

			else

				table.insert (t, {posX, posY, z})

			

				i = i + 1

				setTimer(startGen, 50, 1)

			end

		end

	end, 100, 1)

end



local sx, sy = guiGetScreenSize ()

function drawW()

	dxDrawRectangle (sx/2 - 400, sy - 200, 800, 50, tocolor(50, 50, 50, 200))

	dxDrawRectangle (sx/2 - 400, sy - 200, 800 * (i/countPoints), 50, tocolor(0, 255, 0, 255))

end



addCommandHandler ("startgen", function(_, arg)

	countPoints = tonumber(arg)

	fadeCamera (false)

	setTimer (startGen, 500, 1)

	

	addEventHandler ("onClientRender", root, drawW)

end)



function outputText ()

		local text = ""

		local pattert = "{%.2f, %.2f, %.2f},"

		for i, v in ipairs (t) do

			if text == "" then

				text = string.format (pattert, v[1], v[2], v[3])

			else

				text = text.."\n"..string.format (pattert, v[1], v[2], v[3])

			end

		end

		setClipboard (text)

	

	-- globalPoints = t

	-- startCreateCrystal ()

end