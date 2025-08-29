



-- PIROS = 214,76,69 #d64c45
-- SÁRGA = 214,175,66 #d6af42
-- ZÖLD = 116,179,71 #74b347
-- KÉK = 84,144,196 #5490c4

avaiblePaintjobs = {

	[604] = "remap", -- Mercedes-Benz AMG GT
	[411] = "remap430body", -- Mercedes-Benz AMG GT
	[479] = "remap", -- Mercedes-Benz AMG GT
	[558] = "remap", -- GTR R35
	[439] = "body", -- Nissa 400z
	[602] = "vehiclegrunge256", -- Ford econoline egyterü
	[580] = "remapbody_merc63", -- Ford econoline egyterü
	[603] = "remap_body", -- Mercedes-Benz AMG GT
	[445] = "remap", -- Mercedes-Benz AMG GT
	[551] = "remap_body", -- Mercedes-Benz AMG GT

	[429] = "remap", -- Mercedes-Benz AMG GT
	[526] = "remap", -- Mercedes-Benz AMG GT
	[579] = "remap", -- Mercedes-Benz AMG GT
	[547] = "remap", -- Mercedes-Benz AMG GT
	[540] = "remap", -- Mercedes-Benz AMG GT
	[402] = "remap_body", -- Mercedes-Benz AMG GT
	[496] = "remap", -- Mercedes-Benz AMG GT
	[477] = "remap", -- Mercedes-Benz AMG GT
	


}

defPaintjob = {x=270,y=636,rot=90}
paintjobDefaults = {
	
		[602] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[477] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[580] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[603] = {x=175,y=462,rot=90}, -- Mercedes-Benz GT-R  √
		[604] = {x=175,y=462,rot=90}, -- Mercedes-Benz GT-R  √
		[445] = {x=175,y=462,rot=90}, -- Mercedes-Benz GT-R  √
		[551] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[429] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[526] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[579] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[547] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[558] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[439] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[402] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[540] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[411] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[479] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √
		[496] = {x=175,y=462,rot=90}, -- Lamborghini Huracan LP610-4 √



}

function getPaintjobDefaults(vehicle)
	if isElement(vehicle) then
		if avaiblePaintjobs[getElementModel(vehicle)] then
			return paintjobDefaults[getElementModel(vehicle)].x,paintjobDefaults[getElementModel(vehicle)].y,paintjobDefaults[getElementModel(vehicle)].rot
		end 
	end
end

function isVehicleCompatibleWithStickers(vehicle)
	if isElement(vehicle) then
		if avaiblePaintjobs[getElementModel(vehicle)] then
			if paintjobDefaults[getElementModel(vehicle)] then
				if paintjobDefaults[getElementModel(vehicle)].x == 20000 then
					return false
				else
					return true
				end
			else
				return true
			end
		else
			return false
		end
	else
		return false
	end
end	