



-- PIROS = 214,76,69 #d64c45
-- SÁRGA = 214,175,66 #d6af42
-- ZÖLD = 116,179,71 #74b347
-- KÉK = 84,144,196 #5490c4

wheels = { --[id] = {id=objectid,texture=shadername}
	[1] = {id=1025,texture="rays_re30"},
	[2] = {id=1073,texture="BLITZ_Z1"}, -- correto
	[3] = {id=1074,texture="te37"}, -- correto
	[4] = {id=1075,texture="ame_torqthrust"}, -- correto
	[5] = {id=1076,texture="hamman_editrace"}, -- correto
	[6] = {id=1077,texture="te37"},-- correto
	[7] = {id=1078,texture="enkei_nt03"},-- correto
	[8] = {id=1079,texture="bbs_rs_gt"},-- correto
	[9] = {id=1080,texture="wed_105"}, -- correto
	[10] = {id=1081,texture="rays_gtc"}, -- correto
	[11] = {id=1082,texture="roja_25r"},-- correto
	[12] = {id=1083,texture="rays_re30"},-- correto
	[13] = {id=1084,texture="advan_rgii"},-- correto
	[14] = {id=1085,texture="zen_dynm"},-- correto
	[15] = {id=1096,texture="BLITZ_Type03"}, -- correto
	[16] = {id=1097,texture="zen_dynm"},-- correto
	[17] = {id=1098,texture="dub_bigchips"},-- correto
}

defualt_size = 0.7
wheel_size = {
	[401] = 0.8, -- BMW M4
	[579] = 0.94, -- Mercedes-Benz G63
	[518] = 0.79, -- Nissan 370z Nismo
	[445] = 0.79, -- BMW M5 E60
	[565] = 0.79, -- Nissan GT-R R34
	[541] = 0.79, -- Mercedes-Benz S63 AMG
	[438] = 0.75, -- Lexus IS 350
	[527] = 0.79, -- Ford Mustang GT
	[415] = 0.80, -- Bugatti Veyron
	[507] = 0.75, -- BMW M5 E39
	[562] = 0.77, -- BMW M3 E46
	[587] = 0.79, -- Nissan Skyline GT-R R35
	[533] = 0.77, -- Chevrolet Corvette C8
	[502] = 0.77, -- Mercedes-Benz C63 AMG
	[503] = 0.78, -- Bugatti Chiron
	[411] = 0.75, -- Ferrari 488
	[479] = 0.80, -- Ferrari 488
	[540] = 0.75, -- Ferrari 488
	[400] = 0.95, -- Porsche Cayenne Turbo
	[517] = 0.75, -- Chevrolet SS
	[410] = 0.76, -- Mercedes-Benz SLR McLaren 722
	--[551] = 0.78, -- BMW 750i
	[516] = 0.78, -- Kia Stinger
	[404] = 0.83, -- Audi Q7
	[603] = 0.75, -- Mercedes-Benz GT-R
	[475] = 0.76, -- Dodge Challanger SRT
	[405] = 0.76, -- Alfa Romeo Giulia
	[580] = 0.75, -- Audi RS4
	[561] = 0.69, -- Nissan 240sx
	[409] = 0.72, -- Strech
	[560] = 0.72, -- Michubitcsigeci Evo x
	[529] = 0.78, -- Mercedes-Benz S65 
	[547] = 0.78, -- Ford Focus RS 
	[554] = 0.90, -- Ford Raptor
	[600] = 0.75, -- Acura NSX
	[477] = 0.77, -- Ferrari F355
	[567] = 0.75, -- Chevrolet Impala
	[506] = 0.78, -- McLaren Senna
	[597] = 0.96, -- Rendőr GLE
}
function getVehicleWheelSize(vehicle)
	if isElement(vehicle) then
		if wheel_size[getElementModel(vehicle)] then
			return wheel_size[getElementModel(vehicle)]
		else
			return defualt_size
		end
	end
end