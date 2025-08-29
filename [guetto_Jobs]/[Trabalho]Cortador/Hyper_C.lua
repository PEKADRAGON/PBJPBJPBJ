local _event = addEvent
local _eventH = addEventHandler
fonts = {};

register =
function(event, ...)
    _event(event, true)
    _eventH(event, ...)
end

Regular = {
    [18] = dxCreateFont('ui/Fonts/MontserratRegular.ttf', 18);
};

RenderBind =
function()
    --dxDrawText("Pressione #"..Hyper_Config.Gerais.ColorHEX.."'M' #FFFFFFe Clique no #"..Hyper_Config.Gerais.ColorHEX.."Ped #FFFFFFpara iniciar", 0, 641, 1366, 686, tocolor(255, 255, 255, 255), 1.00, Regular[16], "center", "center", false, false, false, true, false)
    dxDrawText("Pressione #"..Hyper_Config.Gerais.ColorHEX.."'"..Hyper_Config.Gerais.BindCursor.."' #FFFFFFe clique no #"..Hyper_Config.Gerais.ColorHEX.."Ped #FFFFFFpara iniciar", 0, 641, 1365, 48, tocolor(255,255,255, 255), 1.0, Regular[18], "center", "center", false, false, false, true, false)
end

register(getResourceName(getThisResource())..'OpenBind', getRootElement(), function(i)
    if not Event('onClientRender', getRootElement(), RenderBind) then
        addEventHandler('onClientRender', getRootElement(), RenderBind)
        Index = i
    end
end)

register(getResourceName(getThisResource())..'CloseBind', getRootElement(), function()
    if Event('onClientRender', getRootElement(), RenderBind) then
        removeEventHandler('onClientRender', getRootElement(), RenderBind)
        Index = nil
    end
end)


--exports["Blur"]:dxDrawBluredRectangle(0, 0, 1920, 1080, tocolor(110, 110, 110, alpha))
--getResourceName(getThisResource())..

--[[
    Event -- puxa se há o evento

    Cursor -- cursor para funções

    Redondo -- retangulo Redondo

    dxTextCenter -- Text no meio do retangulo

    --função de svg
    dxSetBlendMode('add') -- Melhorar a qualidade do elemento SVG
    drawRect(1634, 800, 150, 100, 10, tocolor(203, 204, 205, 255), '#FF0000', 10, false)
    dxSetBlendMode('blend')

    getFont('ui/Fonts/Montserrat-Bold.ttf', 12)

    getTimeLeft(Timer)

    convertNumber(number)
]]--