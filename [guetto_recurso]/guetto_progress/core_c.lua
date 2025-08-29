--  _//     _//_///////      _//       _////     _/////    _////////  _// //     --
--  _//     _//_//    _// _//   _//  _//    _//  _//   _// _//      _//    _//   --
--  _//     _//_//    _//_//       _//        _//_//    _//_//       _//         --
--  _//     _//_///////  _//       _//        _//_//    _//_//////     _//       --
--  _//     _//_//       _//       _//        _//_//    _//_//            _//    --
--  _//     _//_//        _//   _//  _//     _// _//   _// _//      _//    _//   --
--    _/////   _//          _////      _////     _/////    _////////  _// //     --
--                                                                               --
--     Discord: https://discord.com/invite/XRaMsVbUP2, Desenvolvedor: K4RLOW     --

local __PIXELS =  __GLOBAL.configuration.pixels 
if __PIXELS == 'low' or __PIXELS == 'medium' or __PIXELS == 'high' or __PIXELS == 'ultra' then
    if __PIXELS == 'lowr' then __DEFAULT_PIXELS = 64 end
    if __PIXELS == 'medium' then __DEFAULT_PIXELS = 128 end
    if __PIXELS == 'high' then __DEFAULT_PIXELS = 256 end
    if __PIXELS == 'ultra' then __DEFAULT_PIXELS = 512 end
else
    return
end

local __events = require('events')
local __async = require('async')
__async:setPriority(2500, 250)

-- UTIL ACESS CONFIGURATION

local conf = __GLOBAL.configuration

-- TABLES FUNCTIONS 

local __TEXTURE = {}
local __CLOTHE = {}
local __SHADER = {}
local __PIXEL = {}

-- TABLE RECEIVER PROPS

local __PEDCOLOR = {}
local __CLOTHES = {}
local __SHADERS = {}
local __TEXTURES = {}

-- TEXTURE RAW

__TEXTURE.raw = [[
	texture tex;
	technique replace {
		pass P0 {
			Texture[0] = tex;
		}
	}
]]

__TEXTURE.raw2 = [[
    texture Tex0;

    #include "shaders/mta-helper.fx"

    float4 sColor = float4(1, 1, 1, 1);


    sampler2D Sampler0 = sampler_state 
    {
        Texture = <Tex0>;
    };

    struct PSInput
    {
        float4 Position : POSITION0;
        float4 Diffuse : COLOR0;
        float2 TexCoord0 : TEXCOORD0;
        float2 TexCoord1 : TEXCOORD1;
    };

    float4 PixelShaderFunction(PSInput PS) : COLOR0
    {
        float4 texel0 = tex2D(Sampler0, PS.TexCoord0);
        float4 skinTone = sColor;
        float4 finalColor = (texel0 * (PS.Diffuse  * skinTone));
        return finalColor;
    }

//    float4 PS_Main(float2 texCoord : TEXCOORD0) : COLOR
//    {
//        float2 uv = texCoord;
//        float4 color0 = tex2D(Sampler0, uv);
//        return color0; 
//    }

    technique colorize 
    { 
//        pass P0 
//        { 
//            PixelShader = compile ps_2_0 PS_Main();
//        }
        pass P0
        { 
            PixelShader = compile ps_2_0 PixelShaderFunction(); 
        } 
    } 
]]

-- LOAD PED MODELS

for id, response in pairs(conf.models) do
    local txd = engineLoadTXD(response.txd)
    engineImportTXD(txd, response.skin)
    local dff = engineLoadDFF(response.dff, response.skin)
    engineReplaceModel(dff, response.skin, true)
end

-- LOAD PED ANIMATIONS

-- for id, response in pairs(conf.animation) do
--     engineLoadIFP(response.ifp, 'upcodes > animation '..response.skin)
-- end

-- CREATE NEW ANIMATION

__create_animation = function(element, gender)
    if conf.animation[gender] then
        -- local replaces = getElementData(element, 'upcodes > animation effect')
        -- if replaces then
        --     for id, response in pairs(replaces) do
        --         engineRestoreAnimation(element, 'upcodes > animation '..conf.animation[gender].skin, response)
        --     end
        -- end

        -- setElementData(element, 'upcodes > animation effect', conf.animation[gender].replaces)
        -- setElementModel(element, conf.models[gender].skin)

        for id, response in pairs(conf.animation[gender].replaces) do
            engineReplaceAnimation(element, 'ped', response, 'upcodes > animation '..conf.animation[gender].skin, response)
        end
    end
end

-- REMOVE PED CLOTHE

local __removeClothe = function(element, model, bodypart, name, pedcolor, table)
    for id, response in pairs(table) do
        __addClothe(element, model, response.bodypart, response.name, 0, pedcolor)
    end
end

-- ADD PED CLOTHE

__addClothe = function(element, model, bodypart, name, color, pedcolor, tcolor)
    if conf.models[model] then
        local isTatto = string.find(bodypart, 'tatto/')

        if conf['ped']['clothe'][model] and (isTatto or (conf['ped']['clothe'][model][bodypart] and conf['ped']['clothe'][model][bodypart][name])) then
            local color = tonumber(color)
            
            if not color then return end
            
            if not __PIXEL[element] then return end

            local pedcolor = pedcolor or __PEDCOLOR[element] or 5

            if color > 0 then
                if not __CLOTHES[element] then
                    __CLOTHES[element] = {}
                end

                if not __SHADERS[element] then
                    __SHADERS[element] = {}
                end

                if not __TEXTURES[model] then
                    __TEXTURES[model] = {}
                end

                if not __CLOTHES[element][model] then
                    __CLOTHES[element][model] = {}
                end

                if not __SHADERS[element][model] then
                    __SHADERS[element][model] = {}
                end

                if not __CLOTHES[element][model][bodypart] then
                    __CLOTHES[element][model][bodypart] = {}
                end

                if not __SHADERS[element][model][bodypart] then
                    __SHADERS[element][model][bodypart] = {}
                end

                if not __TEXTURES[model][bodypart] then
                    __TEXTURES[model][bodypart] = {}
                end

                if not __TEXTURES[model][bodypart][name] then
                    __TEXTURES[model][bodypart][name] = {}
                end

                if not __TEXTURES[model][bodypart][name][color] then    
                    if isTatto then
                        if fileExists(':cpx_assets/cpx_character/'..bodypart..'/'..color..'.png') then
                            __TEXTURES[model][bodypart][name][color] = dxCreateTexture(':cpx_assets/cpx_character/'..bodypart..'/'..color..'.png', 'argb')
                        else
                            return
                        end
                    else
                        if fileExists(':cpx_assets/cpx_character/clothes/'..model..'/'..bodypart..'/'..name..'/'..color..'.png') then
                            __TEXTURES[model][bodypart][name][color] = dxCreateTexture(':cpx_assets/cpx_character/clothes/'..model..'/'..bodypart..'/'..name..'/'..color..'.png', 'argb')
                        else
                            __TEXTURES[model][bodypart][name][color] = dxCreateTexture(':cpx_assets/cpx_character/clothes/'..model..'/'..bodypart..'/'..name..'/'..__PIXEL[element]..'/'..color..'.png', 'argb')
                        end
                    end
                end

                if not tcolor and __CLOTHES[element][model][bodypart] and __CLOTHES[element][model][bodypart].name == name then
                    if __CLOTHES[element][model][bodypart].color == color then return end
                end
                
                if __SHADERS[element][model][bodypart].shader then
                    destroyElement(__SHADERS[element][model][bodypart].shader)
                end

                if not isTatto then
                    if __CLOTHES[element][model][bodypart].name ~= name then
                        if conf['ped']['clothe'][model][bodypart][name].remove and #conf['ped']['clothe'][model][bodypart][name].remove > 0 then
                            __removeClothe(element, model, bodypart, name, __PEDCOLOR[element], conf['ped']['clothe'][model][bodypart][name].remove)
                        end
                    end

                    if conf['ped']['clothe'][model][bodypart][name].apply and #conf['ped']['clothe'][model][bodypart][name].apply > 0 then            
                        for id, response in pairs(conf['ped']['clothe'][model][bodypart][name].apply) do
                            if response.color == 'body' then
                                __addClothe(element, model, response.bodypart, response.name, __PEDCOLOR[element])
                            else
                                __addClothe(element, model, response.bodypart, response.name, response.color)
                            end
                        end
                    end

                    if tcolor and (tcolor[1] and tcolor[2] and tcolor[3]) and (tcolor[1] ~= 255 and tcolor[2] ~= 255 and tcolor[3] ~= 255) then
                        if conf['ped']['overlays'][bodypart] then
                            __SHADERS[element][model][bodypart] = {shader = dxCreateShader(__TEXTURE.raw2, 0, 0, true, "ped"), name = name, color = color}
                        else
                            __SHADERS[element][model][bodypart] = {shader = dxCreateShader(__TEXTURE.raw2, 0, 0, false, "ped"), name = name, color = color}
                        end
                        
                        __CLOTHES[element][model][bodypart] = {name = name, color = color, tex = conf['ped']['clothe'][model][bodypart][name].tex}
                    
                        if type(__TEXTURES[model][bodypart][name][color]) ~= 'table' then
                            
                            dxSetShaderValue(__SHADERS[element][model][bodypart].shader, "Tex0", __TEXTURES[model][bodypart][name][color])
                            dxSetShaderValue(__SHADERS[element][model][bodypart].shader, "sColor", {tcolor[1] / 255, tcolor[2] / 255, tcolor[3] / 255, 1})
                            
                            engineApplyShaderToWorldTexture(__SHADERS[element][model][bodypart].shader, __CLOTHES[element][model][bodypart].tex, element, true)
                        end
                    else
                        if conf['ped']['overlays'][bodypart] then
                            __SHADERS[element][model][bodypart] = {shader = dxCreateShader(__TEXTURE.raw, 0, 0, true, "ped"), name = name, color = color}
                        else
                            __SHADERS[element][model][bodypart] = {shader = dxCreateShader(__TEXTURE.raw, 0, 0, false, "ped"), name = name, color = color}
                        end
                        
                        __CLOTHES[element][model][bodypart] = {name = name, color = color, tex = conf['ped']['clothe'][model][bodypart][name].tex}
                    
                        if type(__TEXTURES[model][bodypart][name][color]) ~= 'table' then
                            dxSetShaderValue(__SHADERS[element][model][bodypart].shader, "tex", __TEXTURES[model][bodypart][name][color])
                            engineApplyShaderToWorldTexture(__SHADERS[element][model][bodypart].shader, __CLOTHES[element][model][bodypart].tex, element, true)
                        end
                    end
                else
                    __SHADERS[element][model][bodypart] = {shader = dxCreateShader(__TEXTURE.raw, 0, 0, true, "ped"), name = name, color = color}
                    __CLOTHES[element][model][bodypart] = {name = name, color = color, tex = name}
                
                    if type(__TEXTURES[model][bodypart][name][color]) ~= 'table' then
                        dxSetShaderValue(__SHADERS[element][model][bodypart].shader, "tex", __TEXTURES[model][bodypart][name][color])
                        engineApplyShaderToWorldTexture(__SHADERS[element][model][bodypart].shader, __CLOTHES[element][model][bodypart].tex, element, true)
                    end
                end
            else
                if not isTatto then
                    if conf['ped']['clothe'][model][bodypart][name].remove and #conf['ped']['clothe'][model][bodypart][name].remove > 0 then            
                        for id, response in pairs(conf['ped']['clothe'][model][bodypart][name].remove) do
                            if response.color == 'body' then
                                __addClothe(element, model, response.bodypart, response.name, __PEDCOLOR[element])
                            else
                                __addClothe(element, model, response.bodypart, response.name, response.color)
                            end
                        end
                    end
                end

                if  __CLOTHES[element] and __CLOTHES[element][model] and __CLOTHES[element][model][bodypart] and __CLOTHES[element][model][bodypart].name == name and __CLOTHES[element][model][bodypart].color > 0 then
                    if isElement(__SHADERS[element][model][bodypart].shader) then
                        engineRemoveShaderFromWorldTexture(__SHADERS[element][model][bodypart].shader, __CLOTHES[element][model][bodypart].tex, element)    
                        
                        if isElement(__SHADERS[element][model][bodypart].shader) then
                            destroyElement(__SHADERS[element][model][bodypart].shader)
                        end

                        __SHADERS[element][model][bodypart].shader = nil
                        __CLOTHES[element][model][bodypart] = nil
                    end
                end
            end
        end
    else
        error("@"..getResourceName(getThisResource())..' Invalid model character')
    end
end

-- UPDATE PED CLOTHE

local __updateClothe = function(element, clothe, model, ped, pixels)
    if element and clothe and model and ped and clothe[model] and ped[model] then
        local pixels = pixels

        __PIXEL[element] = pixels
        __PEDCOLOR[element] = ped[model]

        for id, response in pairs(clothe[model]) do
            __addClothe(element, model, id, response.name, response.color, ped[model], response.tcolor)
        end
    end
end



-- addEventHandler( "onClientElementStreamIn", root, 
--     function ()
--         if getElementType(source) == "player" and isPedDead(source) == false then
--             local x, y, z = getElementPosition(localPlayer)
--             local xh, xy, xz = getElementPosition(source)
--             local distance = getDistanceBetweenPoints3D(x, y, z, xh, xy, xz )
--             if distance < 5 then
                
--             end
--         end
--     end
-- )


-- REGISTER EVENT

__events.onEvent('upcodes > set player clothe', root, __addClothe)
__events.onEvent('upcodes > update player clothe', root, __updateClothe)
__events.onEvent('upcodes > animation', root, __create_animation)

-- EXPORTS

function setPlayerColor(element, ...)
    if not element then return error("@"..getResourceName(getThisResource()).." function setPlayerColor argument 1 it's "..type(element).."") end

    triggerServerEvent('upcodes > setPlayerColor', element, ...)
end

function setPlayerGender(element, ...)
    if not element then return error("@"..getResourceName(getThisResource()).." function setPlayerGender argument 1 it's "..type(element).."") end

    triggerServerEvent('upcodes > setPlayerGender', element, ...)
end

function setPlayerClothe(element, ...)
    if not element then return error("@"..getResourceName(getThisResource()).." function setPlayerClothe argument 1 it's "..type(element).."") end
    __addClothe(element, ...)
end


addEventHandler('onClientResourceStop', root,
    function(res)
        if getThisResource() ~= res then return end

        -- SHADER

        for _, player in next, getElementsByType('player') do
            if __SHADERS[player] then
                for model, _ in next, __SHADERS[player] do
                    for _, result in next, __SHADERS[player][model] do
                        if isElement(result.shader) then
                            destroyElement(result.shader)
                        end
                    end    
                end    
            end
        end

        -- TEXTURE

        for model, _ in next, __TEXTURES do
            if __TEXTURES[model] then
                for bodypart, _ in next, __TEXTURES[model] do
                    for name, _ in next, __TEXTURES[model][bodypart] do
                        for color, texture in next, __TEXTURES[model][bodypart][name] do
                            if isElement(texture) then
                                destroyElement(texture)
                            end
                        end    
                    end    
                end    
            end
        end
    end
)