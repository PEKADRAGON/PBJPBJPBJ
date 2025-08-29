



-- PIROS = 214,76,69 #d64c45
-- SÁRGA = 214,175,66 #d6af42
-- ZÖLD = 116,179,71 #74b347
-- KÉK = 84,144,196 #5490c4

max_box = 6

tuning_markers = {
	[1] = {
		pos = {1020.289, -1004.896, 32.176, 180 , 'Mec'}, -- x,y,z,rot
		logo = "textures/logo/san_fierro.png",
	},
	[2] = {
		pos = {1031.9, -1005.347, 32.176, 180, 'Mec' }, -- x,y,z,rot
		logo = "textures/logo/san_fierro.png",
	},
	[3] = {
		pos = {1042.631, -1005.342, 32.176, 180 , 'Mec'}, -- x,y,z,rot
		logo = "textures/logo/san_fierro.png",
	},
	[4] = {
		pos = {2254.291, -2003.836, 13.61, 0, 'Mec'}, -- x,y,z,rot
		logo = "textures/logo/san_fierro.png",
	},
	[5] = {
		pos = {836.294, -1707.58, 13.617, 270, 'Mec'}, -- x,y,z,rot
		logo = "textures/logo/san_fierro.png",
	},
	[6] = {
		pos = {836.319, -1714.099, 13.617, 270, 'Mec'}, -- x,y,z,rot
		logo = "textures/logo/san_fierro.png",
	},
	[7] = {
		pos = {-1108.799, -1682.099, 76.374, 270, 'Mec'}, -- x,y,z,rot
		logo = "textures/logo/san_fierro.png",
	},
	[8] = {
		pos = {2102.399, -1268.148, 25.488, 180, 'Mec'}, -- x,y,z,rot
		logo = "textures/logo/san_fierro.png",
	},
}

tuning_options = {
	--// Main kategóriák
	name = "airintake",
	[1] = {name = "Engine",icon = "textures/icons/engine.dds",
		[1] = {name = "Motor",icon = "textures/icons/engine.dds",
			[1] = {name = "Entrada de ar",icon = "textures/icons/air_intake.dds",data="danihe->tuning->airintake",
				desc = "As melhorias na entrada de ar ajudam o motor a respirar mais livremente e dão uma dose extra de impulso. Filtros de ar menos restritivos e um tubo de admissão ajustado permitem que mais ar entre no motor, fornecendo mais potência.",
				cameraSettings = {"bonnet_dummy", 70, 40, 4, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/air_intake.dds",price=0,priceType="Money",handling={"maxVelocity",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/air_intake.dds",price=1000,priceType="Money",handling={"maxVelocity",1.5}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/air_intake.dds",price=2000,priceType="Money",handling={"maxVelocity",3}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/air_intake.dds",price=4000,priceType="Money",handling={"maxVelocity",4.5}},
				[5] = {name = "Pacote premium",icon = "textures/icons/air_intake.dds",price=1000,priceType="Money",handling={"maxVelocity",7.5}},
			},
			[2] = {name = "Sistema de combustível",icon = "textures/icons/fuel_system.dds",data="danihe->tuning->fuelsystem",
				desc = "Melhorias no sistema de combustível podem trazer um grande aumento de desempenho. Eles garantem um fluxo de combustível mais eficiente, um tempo mais preciso, o uso de combustível com maior octanagem e a extração de mais potência do combustível que você usa..",
				cameraSettings = {"bonnet_dummy", 110, 40, 3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/fuel_system.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/fuel_system.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.2}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/fuel_system.dds",price=2000,priceType="Money",handling={"engineAcceleration",0.4}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/fuel_system.dds",price=4000,priceType="Money",handling={"engineAcceleration",0.6}},
				[5] = {name = "Pacote premium",icon = "textures/icons/fuel_system.dds",price=1000,priceType="Money",handling={"engineAcceleration",1}},
			},
			[3] = {name = "Ignição",icon = "textures/icons/ignite.dds",data="danihe->tuning->ignite",
				desc = "Melhorias na ignição ajudam o motor a queimar combustível de forma mais eficiente e proporcionar melhor desempenho. Melhores bobinas, velas de ignição e cabos de ignição podem fazer uma grande diferença na potência do motor e no desempenho do carro.",
				cameraSettings = {"bonnet_dummy", 80, 30, 3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/ignite.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/ignite.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.15}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/ignite.dds",price=2000,priceType="Money",handling={"engineAcceleration",0.3}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/ignite.dds",price=4000,priceType="Money",handling={"engineAcceleration",0.45}},
				[5] = {name = "Pacote premium",icon = "textures/icons/ignite.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.75}},
			},
			[4] = {name = "Escape",icon = "textures/icons/exhaust.dds",data="danihe->tuning->exhaust",
				desc = "As atualizações do sistema de exaustão, como melhores cabeçalhos, tambor silencioso, desvios e tubos de grande diâmetro, proporcionam desempenho extra a um preço relativamente baixo. Eles permitem que o motor respire muito mais livremente e forneça mais potência, reduzindo a contrapressão e canalizando de forma mais eficiente os gases de escape.",
				cameraSettings = {"bump_rear_dummy", -105, 10, 3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/exhaust.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/exhaust.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.2}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/exhaust.dds",price=2000,priceType="Money",handling={"engineAcceleration",0.4}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/exhaust.dds",price=4000,priceType="Money",handling={"engineAcceleration",0.6}},
				[5] = {name = "Pacote premium",icon = "textures/icons/exhaust.dds",price=1000,priceType="Money",handling={"engineAcceleration",1}},
			},
			[5] = {name = "Eixo de comando",icon = "textures/icons/camshaft.dds",data="danihe->tuning->camshaft",
				desc = "Com o sincronismo de válvulas aprimorado, o motor pode respirar mais livremente e girar mais alto, proporcionando mais torque e potência. O resultado é uma faixa vermelha mais alta e mais desempenho na faixa de alta RPM.",
				cameraSettings = {"bonnet_dummy", 92, 35, 2.5, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/camshaft.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/camshaft.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.15}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/camshaft.dds",price=2000,priceType="Money",handling={"engineAcceleration",0.3}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/camshaft.dds",price=4000,priceType="Money",handling={"engineAcceleration",0.45}},
				[5] = {name = "Pacote premium",icon = "textures/icons/camshaft.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.75}},
			},
			[6] = {name = "Válvulas",icon = "textures/icons/valve.dds",data="danihe->tuning->valve",
				desc = "As válvulas permitem que a mistura de ar e combustível entre e saia do motor. Seu desenvolvimento permite maior fluxo de ar para maior desempenho.",
				cameraSettings = {"bonnet_dummy", 50, 30, 4, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/valve.dds",price=0,priceType="Money",handling={"maxVelocity",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/valve.dds",price=1000,priceType="Money",handling={"maxVelocity",2}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/valve.dds",price=2000,priceType="Money",handling={"maxVelocity",4}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/valve.dds",price=4000,priceType="Money",handling={"maxVelocity",6}},
				[5] = {name = "Pacote premium",icon = "textures/icons/valve.dds",price=1000,priceType="Money",handling={"maxVelocity",10}},
			},
			[7] = {name = "Capacidade do cilindro",icon = "textures/icons/engine.dds",data="danihe->tuning->engine",
				desc = "Com melhorias na cilindrada, o motor será muito mais durável e menos propenso a danos. Estes podem reduzir o atrito/inércia e aumentar o valor do curso/compressão para tornar o motor mais potente e flexível.",
				cameraSettings = {"bonnet_dummy", 90, 30, 3.3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/engine.dds",price=0,priceType="Money",handling={"maxVelocity",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/engine.dds",price=1000,priceType="Money",handling={"maxVelocity",5}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/engine.dds",price=2000,priceType="Money",handling={"maxVelocity",10}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/engine.dds",price=4000,priceType="Money",handling={"maxVelocity",15}},
				[5] = {name = "Pacote premium",icon = "textures/icons/engine.dds",price=30000,priceType="Money",handling={"maxVelocity",30}},
			},
			[8] = {name = "ECU",icon = "textures/icons/ecu.dds",data="danihe->tuning->ecu",
				desc = "O funcionamento dos motores de combustão interna atuais é controlado pela unidade de controle eletrônico (ECU), com base nos dados recebidos dos sensores conectados a ela. Isso aumenta a potência e o torque do motor sem modificações mecânicas, modificando o software da ECU.",
				cameraSettings = {"bonnet_dummy", 110, 45, 3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/ecu.dds",price=0,priceType="Money",handling={"maxVelocity",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/ecu.dds",price=1000,priceType="Money",handling={"maxVelocity",3}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/ecu.dds",price=2000,priceType="Money",handling={"maxVelocity",6}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/ecu.dds",price=4000,priceType="Money",handling={"maxVelocity",9}},
				[5] = {name = "Pacote premium",icon = "textures/icons/ecu.dds",price=20000,priceType="Money",handling={"maxVelocity",15}},
			},
			[9] = {name = "Pistões",icon = "textures/icons/pistons.dds",data="danihe->tuning->pistons",
				desc = "O desenvolvimento dos pistões permite uma alta taxa de compressão para mais potência.",
				cameraSettings = {"bonnet_dummy", 140, 50, 2.5, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/pistons.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/pistons.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.2}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/pistons.dds",price=2000,priceType="Money",handling={"engineAcceleration",0.4}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/pistons.dds",price=4000,priceType="Money",handling={"engineAcceleration",0.6}},
				[5] = {name = "Pacote premium",icon = "textures/icons/pistons.dds",price=1000,priceType="Money",handling={"engineAcceleration",1.0}},
			},
			[10] = {name = "Turbó",icon = "textures/icons/turbo.dds",data="danihe->tuning->turbo",
				desc = "O turbocompressor fornece um aumento significativo de potência usando os gases de escape para girar uma turbina, que comprime a mistura ar-combustível e a entrega ao motor a uma pressão maior que a atmosférica. O resultado é mais energia por curso, o que significa mais desempenho.",
				cameraSettings = {"bonnet_dummy", 90, 30, 3.3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/turbo.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/turbo.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.5}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/turbo.dds",price=2000,priceType="Money",handling={"engineAcceleration",1.0}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/turbo.dds",price=4000,priceType="Money",handling={"engineAcceleration",1.5}},
				[5] = {name = "Pacote premium",icon = "textures/icons/turbo.dds",price=10000,priceType="Money",handling={"engineAcceleration",2.5}},
			},
			[11] = {name = "Trocador de calor",icon = "textures/icons/intercooler.dds",data="danihe->tuning->intercooler",
				desc = "O trocador de calor é um pequeno radiador que resfria o ar quente proveniente do turbocompressor ou supercompressor antes de entrar no motor. Isso faz com que a mistura ar-combustível fique em uma temperatura mais baixa e, portanto, mais densa, dando mais energia por curso.",
				cameraSettings = {"bonnet_dummy", 90, 0, 4, false}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/intercooler.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/intercooler.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.3}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/intercooler.dds",price=2000,priceType="Money",handling={"engineAcceleration",0.6}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/intercooler.dds",price=4000,priceType="Money",handling={"engineAcceleration",0.9}},
				[5] = {name = "Pacote premium",icon = "textures/icons/intercooler.dds",price=1000,priceType="Money",handling={"engineAcceleration",1.5}},
			},
			[12] = {name = "Resfriamento de óleo",icon = "textures/icons/oil_cooler.dds",data="danihe->tuning->oil_cooler",
				desc = "A instalação de um radiador de óleo mantém o óleo do motor na temperatura certa, ajudando na eficiência e aumentando o desempenho.",
				cameraSettings = {"bonnet_dummy", 80, 0, 4, false}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/oil_cooler.dds",price=0,priceType="Money",handling={"maxVelocity",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/oil_cooler.dds",price=1000,priceType="Money",handling={"maxVelocity",1.2}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/oil_cooler.dds",price=2000,priceType="Money",handling={"maxVelocity",2.4}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/oil_cooler.dds",price=4000,priceType="Money",handling={"maxVelocity",3.6}},
				[5] = {name = "Pacote premium",icon = "textures/icons/oil_cooler.dds",price=10000,priceType="Money",handling={"maxVelocity",6.0}},
			},
			[13] = {name = "Volante",icon = "textures/icons/flywheel.dds",data="danihe->tuning->flywheel",
				desc = "Em um carro de fábrica, a massa rotativa do volante suaviza e estabiliza a rotação do semi-eixo, mas piora a resposta do acelerador e a aceleração. O desenvolvimento de um volante mais leve permite que o motor responda mais rapidamente ao acelerador e acelere mais rápido, proporcionando melhor aceleração.",
				cameraSettings = {"bonnet_dummy", 92, 28, 3.3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/flywheel.dds",price=0,priceType="Money",handling={"maxVelocity",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/flywheel.dds",price=1000,priceType="Money",handling={"maxVelocity",1.2}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/flywheel.dds",price=2000,priceType="Money",handling={"maxVelocity",2.4}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/flywheel.dds",price=4000,priceType="Money",handling={"maxVelocity",3.6}},
				[5] = {name = "Pacote premium",icon = "textures/icons/flywheel.dds",price=1000,priceType="Money",handling={"maxVelocity",6.0}},
			},
		},
		[2] = {name = "Capacidade de gerenciamento",icon = "textures/icons/brakes.dds",
			[1] = {name = "Freios",icon = "textures/icons/brakes.dds",data="danihe->tuning->brakes",
				desc = "Os freios são uma parte importante do desempenho geral. Para um carro ser competitivo, seu desempenho de frenagem deve ser compatível com seu desempenho e manuseio. Essas melhorias aumentam o poder de frenagem e reduzem a perda de frenagem devido ao calor excessivo..",
				cameraSettings = {"wheel_lf_dummy", 180, 10, 1.3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/brakes.dds",price=0,priceType="Money",handling={"brakeDeceleration",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/brakes.dds",price=1000,priceType="Money",handling={"brakeDeceleration",4}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/brakes.dds",price=2000,priceType="Money",handling={"brakeDeceleration",8}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/brakes.dds",price=4000,priceType="Money",handling={"brakeDeceleration",12}},
				[5] = {name = "Pacote premium",icon = "textures/icons/brakes.dds",price=10000,priceType="Money",handling={"brakeDeceleration",20}},
			},
			[2] = {name = "Amortecedor",icon = "textures/icons/suspension.dds",data="danihe->tuning->suspension",
				desc = "As molas e os amortecedores podem afetar significativamente o manuseio do seu carro, mantendo a altura ideal do passeio e a aderência dos pneus.",
				cameraSettings = {"wheel_rf_dummy", 0, 10, 1.3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/suspension.dds",price=0,priceType="Money",handling={"tractionMultiplier",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/suspension.dds",price=1000,priceType="Money",handling={"tractionMultiplier",0.008}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/suspension.dds",price=2000,priceType="Money",handling={"tractionMultiplier",0.016}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/suspension.dds",price=4000,priceType="Money",handling={"tractionMultiplier",0.024}},
				[5] = {name = "Pacote premium",icon = "textures/icons/suspension.dds",price=1000,priceType="Money",handling={"tractionMultiplier",0.060}},
			},
			[3] = {name = "Reforço do chassi",icon = "textures/icons/drivetype.dds",data="danihe->tuning->chassis",
				desc = "Os reforços do chassi endurecem a estrutura do carro, reduzindo o estresse nas curvas, o que, por sua vez, ajuda a suspensão a manter o pneu na estrada o máximo possível..",
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/drivetype.dds",price=0,priceType="Money",handling={"tractionMultiplier",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/drivetype.dds",price=1000,priceType="Money",handling={"tractionMultiplier",0.007}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/drivetype.dds",price=2000,priceType="Money",handling={"tractionMultiplier",0.014}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/drivetype.dds",price=4000,priceType="Money",handling={"tractionMultiplier",0.021}},
				[5] = {name = "Pacote premium",icon = "textures/icons/drivetype.dds",price=10000,priceType="Money",handling={"tractionMultiplier",0.035}},
			},
			[4] = {name = "Redução de peso",icon = "textures/icons/weightreducation.dds",data="danihe->tuning->weight",
				desc = "Um carro mais leve acelera melhor e se comporta melhor do que um mais pesado. A redução de peso pode compensar removendo materiais não essenciais ou substituindo peças de fábrica por outras mais leves.",
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/weightreducation.dds",price=0,priceType="Money",handling={"tractionLoss",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/weightreducation.dds",price=1000,priceType="Money",handling={"tractionLoss",0.007}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/weightreducation.dds",price=2000,priceType="Money",handling={"tractionLoss",0.014}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/weightreducation.dds",price=4000,priceType="Money",handling={"tractionLoss",0.021}},
				[5] = {name = "Pacote premium",icon = "textures/icons/weightreducation.dds",price=10000,priceType="Money",handling={"tractionLoss",0.035}},
			},
			[5] = {name = "Pneus",icon = "textures/icons/tires.dds",data="danihe->tuning->tires",
				desc = "Mudar os pneus para um composto mais macio e agressivo aumenta a tração e melhora a capacidade dos pneus de manter a tração apesar do alto calor, mas também aumenta o desgaste. O composto mais duro usado nos pneus de fábrica sacrifica alguma aderência para aumentar a resistência ao desgaste.",
				cameraSettings = {"wheel_lf_dummy", 205, 15, 2, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/tires.dds",price=0,priceType="Money",handling={"tractionMultiplier",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/tires.dds",price=1000,priceType="Money",handling={"tractionMultiplier",0.03}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/tires.dds",price=2000,priceType="Money",handling={"tractionMultiplier",0.06}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/tires.dds",price=4000,priceType="Money",handling={"tractionMultiplier",0.09}},
				[5] = {name = "Pacote premium",icon = "textures/icons/tires.dds",price=10000,priceType="Money",handling={"tractionMultiplier",0.15}},
			},
		},
		[3] = {name = "Corrente de transmissão",icon = "textures/icons/drivetype.dds",
			[1] = {name = "Embreagem",icon = "textures/icons/clutch.dds",data="danihe->tuning->clutch",
				desc = "A embreagem é um elo vital entre o motor e a transmissão. Com as melhorias, a embreagem é mais capaz de lidar com o torque extra de um motor de corrida sem danos.",
				cameraSettings = {"bonnet_dummy", 80, 30, 3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/clutch.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/clutch.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.15}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/clutch.dds",price=2000,priceType="Money",handling={"engineAcceleration",0.3}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/clutch.dds",price=4000,priceType="Money",handling={"engineAcceleration",0.45}},
				[5] = {name = "Pacote premium",icon = "textures/icons/clutch.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.75}},
			},
			[2] = {name = "Caixa de velocidade",icon = "textures/icons/gear.dds",data="danihe->tuning->gear",
				desc = "A transmissão transfere a potência do carro do motor para as rodas motrizes. As melhorias na transmissão podem tornar as trocas de marcha mais rápidas e eficientes, reduzir o atrito e a perda de potência e proporcionar maior durabilidade.",
				cameraSettings = {"bonnet_dummy", 108, 30, 3, true}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/gear.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/gear.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.25}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/gear.dds",price=2000,priceType="Money",handling={"engineAcceleration",0.5}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/gear.dds",price=4000,priceType="Money",handling={"engineAcceleration",0.75}},
				[5] = {name = "Pacote premium",icon = "textures/icons/gear.dds",price=10000,priceType="Money",handling={"engineAcceleration",1.50}},
			},
			[3] = {name = "Corrente de transmissão",icon = "textures/icons/drivetype.dds",data="danihe->tuning->chain",
				desc = "Você pode melhorar a resposta e a aceleração do acelerador reduzindo o peso e a inércia dos componentes do trem de força, especialmente o eixo de transmissão.",
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/drivetype.dds",price=0,priceType="Money",handling={"engineAcceleration",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/drivetype.dds",price=1000,priceType="Money",handling={"engineAcceleration",0.2}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/drivetype.dds",price=2000,priceType="Money",handling={"engineAcceleration",0.4}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/drivetype.dds",price=4000,priceType="Money",handling={"engineAcceleration",0.6}},
				[5] = {name = "Pacote premium",icon = "textures/icons/drivetype.dds",price=10000,priceType="Money",handling={"engineAcceleration",1.0}},
			},
			[4] = {name = "Engrenagem diferencial",icon = "textures/icons/diff.dds",data="danihe->tuning->diff",
				desc = "O diferencial permite que as rodas de cada lado do carro girem em velocidades diferentes porque a roda interna percorre uma distância menor na curva do que a roda externa. O diferencial autoblocante trava em um ponto pré-definido para limitar a diferença de rpm, proporcionando tração máxima ao acelerar e/ou desacelerar.",
				cameraSettings = {"wheel_lb_dummy", 220, 15, 3, false}, -- komponens, x, y, zoom, eltüntés
				[1] = {name = "Pacote de fábrica",icon = "textures/icons/diff.dds",price=0,priceType="Money",handling={"tractionMultiplier",0}},
				[2] = {name = "Pacote de rua",icon = "textures/icons/diff.dds",price=1000,priceType="Money",handling={"tractionMultiplier",0.007}},
				[3] = {name = "Pacote profissional",icon = "textures/icons/diff.dds",price=2000,priceType="Money",handling={"tractionMultiplier",0.014}},
				[4] = {name = "Pacote de competição",icon = "textures/icons/diff.dds",price=4000,priceType="Money",handling={"tractionMultiplier",0.021}},
				[5] = {name = "Pacote premium",icon = "textures/icons/diff.dds",price=10000,priceType="Money",handling={"tractionMultiplier",0.035}},
			},
		},
		[4] = {name = "Nitro",icon = "textures/icons/nitro.dds",data="danihe->tuning->nitro",
			cameraSettings = {"boot_dummy", -45, 22, 4, true}, -- komponens, x, y, zoom, eltüntés
			[1] = {name = "Embalagem",icon = "textures/icons/nitro.dds",price=0,priceType="Money"},
			[2] = {name = "Instalação",icon = "textures/icons/nitro.dds",price=5000,priceType="Money"},
			--[3] = {name = "Enchendo uma garrafa",icon = "textures/icons/nitro.dds",price=1000,priceType="Money"},
 		},
	},
	[2] = {name = "Óptico",icon = "textures/icons/optics.dds",
		[1] = {name = "Roda da frente",icon = "textures/icons/rim.dds",wheelType="Front",
			cameraSettings = {"wheel_lf_dummy", 220, 15, 3, false}, -- komponens, x, y, zoom, eltüntés
			[1] = {name = "Fábrica",icon = "textures/icons/rim.dds",price=0,priceType="Money",wheelID = 0},
			[2] = {name = "Roda #1",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 1,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[3] = {name = "Roda #2",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 2,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[4] = {name = "Roda #3",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 3,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[5] = {name = "Roda #4",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 4,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[6] = {name = "Roda #5",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 5,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[7] = {name = "Roda #6",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 6,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[8] = {name = "Roda #7",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 7,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[9] = {name = "Roda #8",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 8,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[10] = {name = "Roda #9",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 9,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[11] = {name = "Roda #10",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 10,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[12] = {name = "Roda #11",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 11,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[13] = {name = "Roda #12",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 12,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[14] = {name = "Roda #13",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 13,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[15] = {name = "Roda #14",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 14,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[16] = {name = "Roda #15",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 15,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[17] = {name = "Roda #16",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 16,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[18] = {name = "Roda #17",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 17,wheelType="Front",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},

		},
		[2] = {name = "Roda de trás",icon = "textures/icons/rim.dds",wheelType="Back",
			cameraSettings = {"wheel_lb_dummy", 220, 15, 3, false}, -- komponens, x, y, zoom, eltüntés
			[1] = {name = "Fábrica",icon = "textures/icons/rim.dds",price=0,priceType="Money",wheelID = 0},
			[2] = {name = "Roda #1",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 1,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[3] = {name = "Roda #2",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 2,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[4] = {name = "Roda #3",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 3,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[5] = {name = "Roda #4",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 4,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[6] = {name = "Roda #5",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 5,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[7] = {name = "Roda #6",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 6,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[8] = {name = "Roda #7",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 7,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[9] = {name = "Roda #8",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 8,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[10] = {name = "Roda #9",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 9,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[11] = {name = "Roda #10",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 10,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[12] = {name = "Roda #11",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 11,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[13] = {name = "Roda #12",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 12,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[14] = {name = "Roda #13",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 13,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[15] = {name = "Roda #14",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 14,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[16] = {name = "Roda #15",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 15,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[17] = {name = "Roda #16",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 16,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},
			[18] = {name = "Roda #17",icon = "textures/icons/rim.dds",price=500,priceType="Money",wheelID = 17,wheelType="Back",[1] = {name = "Comprar",icon = "textures/icons/rim.dds",price=2000,priceType="Money"},},

		},
		--[3] = {name = "Peitoril",icon = "textures/icons/sideskirt.dds",upgradeSlot=3,price=5000,priceType="Money",
		--	cameraSettings = {"door_rf_dummy", 40, 30, 4, false},[1] = {},
		--},
		--[3] = {name = "Saida de ar",icon = "textures/icons/hood.dds",upgradeSlot=0,price=5000,priceType="Money",
		--	cameraSettings = {"bonnet_dummy", 40, 10, 4, false},[1] = {},
		--},
		[3] = {name = "Aerofólio",icon = "textures/icons/spoiler.dds",upgradeSlot=2,price= 1000,priceType="Money",
			cameraSettings = {"boot_dummy", -30, 10, 5, false},[1] = {},
		},
		--[5] = {name = "Spoiler de teto",icon = "textures/icons/roof.dds",upgradeSlot=7,price=5000,priceType="Money",
		--	cameraSettings = {"ug_roof", 40, 30, 4, false},[1] = {},
		--},
		--[7] = {name = "Escape",icon = "textures/icons/exhaust.dds",upgradeSlot=13,price=1000,priceType="Money",
		--	cameraSettings = {"wheel_lb_dummy", -65, 3, 5, false},[1] = {},
		--},
	},
	[3] = {name = "Polimento",icon = "textures/icons/paint.dds",
		[1] = {name = "Cor #1",icon = "textures/icons/paint.dds",paintID = 1,
			[1] = {name = "Comprar",icon = "textures/icons/paint.dds",price=500,priceType="Money"},
		},
		[2] = {name = "Cor #2",icon = "textures/icons/paint.dds",paintID = 2,
			[1] = {name = "Comprar",icon = "textures/icons/paint.dds",price=500,priceType="Money"},
		},
		[3] = {name = "Cor #3",icon = "textures/icons/paint.dds",paintID = 3,
			[1] = {name = "Comprar",icon = "textures/icons/paint.dds",price=500,priceType="Money"},
		},
		[4] = {name = "Cor #4",icon = "textures/icons/paint.dds",paintID = 4,
			[1] = {name = "Comprar",icon = "textures/icons/paint.dds",price=500,priceType="Money"},
		},
		[5] = {name = "Holofote",icon = "textures/icons/lamp.dds",paintID = 5,
			cameraSettings = {"bump_front_dummy", -45, 22, 8, false}, -- komponens, x, y, zoom, eltüntés
			[1] = {name = "Comprar",icon = "textures/icons/lamp.dds",price=500,priceType="Money"},
		},
	},
	[4] = {name = "Extras",icon = "textures/icons/extras.dds",
		[1] = {name = "Passeio aéreo",icon = "textures/icons/airride.dds",data="danihe->tuning->airride",
			[1] = {name = "Embalagem",icon = "textures/icons/airride.dds",price=0,priceType="Money"},
			[2] = {name = "Instalação",icon = "textures/icons/airride.dds",price=500,priceType="Money"},
		},
		--[2] = {name = "Rotatória",icon = "textures/icons/steering.dds",
		--	[1] = {name = "30°",icon = "textures/icons/steering.dds",price=0,priceType="Money",steer=30},
		--	[2] = {name = "35°",icon = "textures/icons/steering.dds",price=0,priceType="Money",steer=35},
		--	[3] = {name = "40°",icon = "textures/icons/steering.dds",price=0,priceType="Money",steer=40},
		--	[4] = {name = "45°",icon = "textures/icons/steering.dds",price=0,priceType="Money",steer=45},
		--	[5] = {name = "50°",icon = "textures/icons/steering.dds",price=0,priceType="Money",steer=50},
		--	[6] = {name = "55°",icon = "textures/icons/steering.dds",price=0,priceType="Money",steer=55},
		--	[7] = {name = "60°",icon = "textures/icons/steering.dds",price=0,priceType="Money",steer=60},
		--},
		--[3] = {name = "Placa de carro",icon = "textures/icons/plate.dds",plate=true,
		--	cameraSettings = {"boot_dummy", 270, -5, 3, false}, -- komponens, x, y, zoom, eltüntés
		--	[1] = {name = "Placa de carro #1",icon = "textures/icons/plate.dds",price=0,priceType="Money"},
		--	[2] = {name = "Placa de carro #2",icon = "textures/icons/plate.dds",price=0,priceType="Money"},
		--	[3] = {name = "Placa de carro #3",icon = "textures/icons/plate.dds",price=0,priceType="Money"},
		--	[4] = {name = "Placa de carro #4",icon = "textures/icons/plate.dds",price=0,priceType="Money"},
		--	[5] = {name = "Placa de carro #5",icon = "textures/icons/plate.dds",price=0,priceType="Money"},
		--	[6] = {name = "Placa de carro #6",icon = "textures/icons/plate.dds",price=0,priceType="Money"},
		--},
		[2] = {name = "Propulsão",icon = "textures/icons/drivetype.dds",
			[1] = {name = "Roda da frente",icon = "textures/icons/drivetype.dds",price=500,priceType="Money",drivetype="fwd"},
			[2] = {name = "Todas as rodas",icon = "textures/icons/drivetype.dds",price=500,priceType="Money",drivetype="awd"},
			[3] = {name = "Roda traseira",icon = "textures/icons/drivetype.dds",price=500,priceType="Money",drivetype="rwd"},
		},

		--[3] = {name = "Color smoke",icon = "textures/icons/tiresmoke.dds",
		--	[1] = {name = "Lado esquerdo",icon = "textures/icons/tiresmoke.dds",tiredata="Left",
		--		cameraSettings = {"wheel_lb_dummy", 185, 10, 7, false}, -- komponens, x, y, zoom, eltüntés
		--		[1] = {name = "Comprar",icon = "textures/icons/tiresmoke.dds",price=1000,priceType="Money"},
		--	},
		--	[2] = {name = "Lado direito",icon = "textures/icons/tiresmoke.dds",tiredata="Right",
		--		cameraSettings = {"wheel_rb_dummy", -5, 10, 7, false}, -- komponens, x, y, zoom, eltüntés
		--		[1] = {name = "Comprar",icon = "textures/icons/tiresmoke.dds",price=1000,priceType="Money"},
		--	},
		--},
		--[6] = {name = "LSD Ajtó",icon = "textures/icons/lsd_door.dds",

		--},
		[3] = {name = "Neon",icon = "textures/icons/neon.dds",neon=true,
			cameraSettings = {"chassis", 170, 15, 5.5, false}, -- komponens, x, y, zoom, eltüntés
			[1] = {name = "Original",icon = "textures/icons/neon.dds",price=0,priceType="Money"},
			[2] = {name = "#Neon Azul",icon = "textures/icons/neon.dds",price=500,priceType="Money"},
			[3] = {name = "#Neon Verde",icon = "textures/icons/neon.dds",price=500,priceType="Money"},
			[4] = {name = "#Neon Oceano",icon = "textures/icons/neon.dds",price=500,priceType="Money"},
			[5] = {name = "#Neon Azul",icon = "textures/icons/neon.dds",price=500,priceType="Money"},
			[6] = {name = "#Neon Laranja",icon = "textures/icons/neon.dds",price=500,priceType="Money"},
			[7] = {name = "#Neon Rosa",icon = "textures/icons/neon.dds",price=500,priceType="Money"},
			[8] = {name = "#Neon Reggae",icon = "textures/icons/neon.dds",price=500,priceType="Money"},
			[9] = {name = "#Neon Vermelho",icon = "textures/icons/neon.dds",price=500,priceType="Money"},
			[10] = {name = "#Neon Branco",icon = "textures/icons/neon.dds",price=500,priceType="Money"},
			[11] = {name = "#Neon Amarelo",icon = "textures/icons/neon.dds",price=500,priceType="Money"},
		},
		--[5] = {name = "Variante",icon = "textures/icons/variant.dds",variant=true,
		--	[1] = {name = "Variante #1",icon = "textures/icons/variant.dds",price=0,priceType="Money"},
		--	[2] = {name = "Variante #2",icon = "textures/icons/variant.dds",price=0,priceType="Money"},
		--	[3] = {name = "Variante #3",icon = "textures/icons/variant.dds",price=0,priceType="Money"},
		--	[4] = {name = "Variante #4",icon = "textures/icons/variant.dds",price=0,priceType="Money"},
		--	[5] = {name = "Variante #5",icon = "textures/icons/variant.dds",price=0,priceType="Money"},
		--	[6] = {name = "Variante #6",icon = "textures/icons/variant.dds",price=0,priceType="Money"},
		--	[7] = {name = "Variante #7",icon = "textures/icons/variant.dds",price=0,priceType="Money"},
		--	[8] = {name = "Variante #8",icon = "textures/icons/variant.dds",price=0,priceType="Money"},
		--},
	},
	[5] = {name = "Adesivos",icon = "textures/icons/stickers.dds",
		[1] = {name = "Adicionar novo",icon = "textures/icons/sticker_new.dds",
			newSticker = true,
			[1] = {name = "Comprar",icon = "textures/icons/sticker_new.dds",stickerEditing = true},
		},
		[2] = {name = "Editando",icon = "textures/icons/sticker_edit.dds",listStickers=true,
			[1] = {},
		},
		[3] = {name = "Excluir tudo",icon = "textures/icons/sticker_delete.dds",delteStickers=true,price=0,priceType="Money"},
	},
}

function getPerformanceTuneDatas()
	local datas = {}
	for k,v in ipairs(tuning_options[1]) do
		for i,row in ipairs(v) do
			if row.data then
				table.insert(datas,row.data)
			end
		end
	end
	return datas
end

function getPerformanceTunesForDashboard()
	local datas = {}
	for k,v in ipairs(tuning_options[1]) do
		for i,row in ipairs(v) do
			if row.data then
				table.insert(datas,{name=row.name,elementdata=row.data})
			end
		end
	end
	return datas
end


--// Matrica kategóriák
stickers = {
	[1] = {name="Formulários",icon="textures/stickers/shapes.dds",dir="shapes",stickerCount=28,price=0},
	[2] = {name="Folhas",icon="textures/stickers/body.dds",dir="body",stickerCount=35,price=0},
	[3] = {name="Personagens",icon="textures/stickers/characters.dds",dir="characters",stickerCount=65,price=0},
	[4] = {name="Texto:% s",icon="textures/stickers/texts.dds",dir="texts",stickerCount=177,price=0},
	[5] = {name="Outro",icon="textures/stickers/misc.dds",dir="misc",stickerCount=174,price=0},
}

function getStickerPrice(dir)
	local price = 0
	for k,v in ipairs(stickers) do
		if v.dir == dir then
			price = v.price
		end
	end
	return price 
end

function findPerformanceByData(data,level)
	local handling = false
	for k,v in ipairs(tuning_options[1]) do
		for i,row in ipairs(tuning_options[1][k]) do
			if row.data == data then
				handling = row[level].handling
				break
			end
		end
	end
	return handling
end

timeBySound = {
	["sounds/upgrade.ogg"] = 1700,
	["sounds/paint.ogg"] = 3000,
}


function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function getPositionFromElementOffset(element, offsetX, offsetY, offsetZ)
	local elementMatrix = getElementMatrix(element)
    local elementX = offsetX * elementMatrix[1][1] + offsetY * elementMatrix[2][1] + offsetZ * elementMatrix[3][1] + elementMatrix[4][1]
    local elementY = offsetX * elementMatrix[1][2] + offsetY * elementMatrix[2][2] + offsetZ * elementMatrix[3][2] + elementMatrix[4][2]
    local elementZ = offsetX * elementMatrix[1][3] + offsetY * elementMatrix[2][3] + offsetZ * elementMatrix[3][3] + elementMatrix[4][3]
	
    return elementX, elementY, elementZ
end


function hsvToRgb(h, s, v, a)
  local r, g, b

  local i = math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r * 255, g * 255, b * 255, a * 255
end

function rgbToHsv(r, g, b, a)
  r, g, b, a = r / 255, g / 255, b / 255, a / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v
  v = max

  local d = max - min
  if max == 0 then s = 0 else s = d / max end

  if max == min then
    h = 0 -- achromatic
  else
    if max == r then
    h = (g - b) / d
    if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, v, a
end