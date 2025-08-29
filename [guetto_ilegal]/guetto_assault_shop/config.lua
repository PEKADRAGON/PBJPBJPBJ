--"Copyright

armas = {
	[31] = true;
	[30] = true;
	[20] = true;
	[21] = true;
	[22] = true;
	[23] = true;
	[24] = true;
}


mochilaconfig = {1550,3, -0.02,-0.19,-0.01,-7.2,0,0} --id mochila ,osso , posicao de attach com escala

moneySujo = 100;

Config = {
	GlobalConfigs = {
		perder_ao_morrer = true;
		tempopegarmoney = 20,-- segundos para pegar o dinheiro
		tentativa = 3,-- quantidade de tentativa
		tempo_ocorrendoabordagem = 20, -- quantidade de segundos em que o ped fala  senha
		tempo_senha = 15, -- segundos para tentar abrir o cofre
		tempo_reinciar_assalto = 15; --tempo para reiniciar assalto em minutos
		max_and_min_money = {50000, 150000};  --dinheiro maximo e minimo givado no assalto
		tempo_cofre = 7; -- tempo para digitar a senha em segundos !
		aclPolicial = 'Corporação';
		volumeSound = 1.8,
		blipassalto = 36,

		tempobolsa = 120;
	};
	AssaltoConfig = {
		{area = {1317.095, -886.535, 39.578, 25}; pedcfg = {155, 1324.971, -878.697, 39.578, 185}, cofrecfg = {964, 1308.604, -879.571, 39.578 -1, 0, 0, 0}, blip = 17}; -- x, y, tamanho area (/showcol) pra ver, skin do ped ,pos x,y,z  e tambem posicao e rotação do cofre
		{area = {2262.604, 955.298, 10.82, 20}; pedcfg = {155, 2274.615, 947.258, 10.82, 356}, cofrecfg = {964, 2249.921, 945.457, 10.82 -1, 0, 0, 90}, blip = 17}; -- x, y, tamanho area (/showcol) pra ver, skin do ped ,pos x,y,z  e tambem posicao e rotação do cofre
		{area = {2509.101, 1227.194, 10.82, 20}; pedcfg = {215,2508.131, 1217.025, 10.82, 356}, cofrecfg = {964, 2502.581, 1217.082, 10.82 -1, 0, 0, 90}, blip = 17}; -- x, y, tamanho area (/showcol) pra ver, skin do ped ,pos x,y,z  e tambem posicao e rotação do cofre
		{area = {1843.573, -1849.023, 13.654, 20}; pedcfg = {215, 1853.801, -1840.14, 13.654, 177}, cofrecfg = {964, 1858.458, -1840.553, 13.654 -1, 0, 0, 0}, blip = 17}; -- x, y, tamanho area (/showcol) pra ver, skin do ped ,pos x,y,z  e tambem posicao e rotação do cofre
		{area = {2675.885, -1116.747, 69.757, 20}; pedcfg = {215, 2682.819, -1127.842, 69.756, 3}, cofrecfg = {964, 2671.361, -1119.93, 69.755 -1, 0, 0, 0}, blip = 17}; -- x, y, tamanho area (/showcol) pra ver, skin do ped ,pos x,y,z  e tambem posicao e rotação do cofre

		
		--{area = {2529.356, -1531.51, 24.131, 13}; pedcfg = {310, 2523.047, -1533.042, 24.131, 180}, cofrecfg = {964, 2525, -1537.30, 23.60 -0.3, 0, 0, 180},blip = 17}; -- x, y, tamanho area (/showcol) pra ver, skin do ped ,pos x,y,z  e tambem posicao e rotação do cofre

	};
}





msgClient = function(msg,type) -- infobox client
	return exports['guetto_notify']:showInfobox(type, msg)
end



msgServer = function(player,msg,type) -- infobox server
	return exports['guetto_notify']:showInfobox(player, type, msg)
end