local alpha = {0, 0, 0}
local isEventHandlerAdded = false 

local svg = {
    ['icon-close'] = svgCreate(26, 26, [[
        <svg width="26" height="26" viewBox="0 0 26 26" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M12.9999 14.5165L7.69154 19.8249C7.49293 20.0235 7.24015 20.1228 6.9332 20.1228C6.62626 20.1228 6.37348 20.0235 6.17487 19.8249C5.97626 19.6263 5.87695 19.3735 5.87695 19.0665C5.87695 18.7596 5.97626 18.5068 6.17487 18.3082L11.4832 12.9999L6.17487 7.69154C5.97626 7.49293 5.87695 7.24015 5.87695 6.9332C5.87695 6.62626 5.97626 6.37348 6.17487 6.17487C6.37348 5.97626 6.62626 5.87695 6.9332 5.87695C7.24015 5.87695 7.49293 5.97626 7.69154 6.17487L12.9999 11.4832L18.3082 6.17487C18.5068 5.97626 18.7596 5.87695 19.0665 5.87695C19.3735 5.87695 19.6263 5.97626 19.8249 6.17487C20.0235 6.37348 20.1228 6.62626 20.1228 6.9332C20.1228 7.24015 20.0235 7.49293 19.8249 7.69154L14.5165 12.9999L19.8249 18.3082C20.0235 18.5068 20.1228 18.7596 20.1228 19.0665C20.1228 19.3735 20.0235 19.6263 19.8249 19.8249C19.6263 20.0235 19.3735 20.1228 19.0665 20.1228C18.7596 20.1228 18.5068 20.0235 18.3082 19.8249L12.9999 14.5165Z" fill="white"/>
        </svg>
    ]]),
    ['rectangle-router'] = svgCreate(338, 46, [[
        <svg width="338" height="46" viewBox="0 0 338 46" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="338" height="46" rx="2" fill="white"/>
        </svg>
    ]])
}

local slots = {
    {822, 472, 117, 19};
    {822, 515, 117, 19};
    {822, 558, 117, 19};

    {1005, 472, 117, 19};
    {1005, 515, 117, 19};
    {1005, 558, 117, 19};
}

local function draw ( )
    local fade = interpolateBetween (alpha[1], 0, 0, alpha[2], 0, 0, (getTickCount() - alpha[3]) / 400, 'Linear')

    dxDrawRoundedRectangle(762, 381, 396, 318, tocolor(24, 24, 24, 0.95 * fade), 8)
    dxDrawImage(1102, 413, 26, 26, svg['icon-close'], 0, 0, 0, isCursorOnElement(1102, 413, 26, 26) and tocolor(255, 75, 75, fade) or tocolor(168, 168, 168, fade))

    dxDrawText('ROTAS', 791, 401, 52, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('bold', 15), 'left', 'center')
    dxDrawText('Pegue itens de acordo com a rota.', 791, 424, 229, 19, tocolor(133, 133, 133, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')

    if (router_data) then 
        for i, v in ipairs ( router_data.routes ) do 
            if slots[i] then 
                
                if (config["Imagens"][v]) then 
                    dxDrawImage(slots[i][1] - 18 - 14, slots[i][2] + slots[i][4] / 2 - 18 / 2 + 3, 18, 18, config["Imagens"][v], 0, 0, 0, router_select == i and tocolor(193, 159, 114, fade) or isCursorOnElement(slots[i][1], slots[i][2], slots[i][3], slots[i][4]) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, 255))
                end

                dxDrawText('Rota de '..v, slots[i][1], slots[i][2], slots[i][3], slots[i][4], router_select == i and tocolor(193, 159, 114, fade) or isCursorOnElement(slots[i][1], slots[i][2], slots[i][3], slots[i][4]) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
            end
        end
    end


    dxDrawImage(791, 614, 338, 46, svg['rectangle-router'], 0, 0, 0, isCursorOnElement(791, 614, 338, 46) and tocolor(193, 159, 114, 0.80 * fade) or tocolor(193, 159, 114, fade))
    dxDrawText('COMEÇAR ROTA', 791, 616, 338, 46, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')
end 

local function toggle ( state )
    if state and not isEventHandlerAdded then 
        isEventHandlerAdded = true 
        router_select = 0
        alpha = {0, 255, getTickCount()}
        showCursor(true)
        showChat(false)
        addEventHandler('onClientRender', root, draw)
    elseif not state and isEventHandlerAdded then 
        isEventHandlerAdded = false
        alpha = {255, 0, getTickCount()}
        showCursor(false)
        showChat(true)
        setTimer(function()
            removeEventHandler('onClientRender', root, draw)
        end, 400, 1)
    end
end

addEventHandler('onClientClick', root,
    function ( button, state )
        if button == 'left' and state == 'down' and isEventHandlerAdded then 
            for i, v in ipairs ( router_data.routes ) do 
                if slots[i] then 
                    if isCursorOnElement(slots[i][1], slots[i][2], slots[i][3], slots[i][4]) then 
                        router_select = i
                        break 
                    end
                end
            end
            if isCursorOnElement(1102, 413, 26, 26) then 
                toggle(false)
            elseif isCursorOnElement(791, 614, 338, 46) then 
                if router_select ~= 0 then 
                    triggerServerEvent('onPlayerStartRouter', resourceRoot, router_data.routes[router_select])
                    toggle(false)
                else
                    config.sendMessageClient('Selecione uma rota!', 'error')
                end
            end
        end
    end
)

addEvent('onPlayerToggleRouter', true)
addEventHandler('onPlayerToggleRouter', resourceRoot,
    function ( data )
        toggle(true)
        router_data = data
    end
)

local stats_handler = false 

local bg = svgCreate(357, 93, [[
    <svg width="357" height="93" viewBox="0 0 357 93" fill="none" xmlns="http://www.w3.org/2000/svg">
        <g filter="url(#filter0_b_431_168)">
        <rect width="357" height="93" rx="8" fill="#181818" fill-opacity="0.95"/>
        </g>
        <defs>
        <filter id="filter0_b_431_168" x="-24" y="-24" width="405" height="141" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
        <feFlood flood-opacity="0" result="BackgroundImageFix"/>
        <feGaussianBlur in="BackgroundImageFix" stdDeviation="12"/>
        <feComposite in2="SourceAlpha" operator="in" result="effect1_backgroundBlur_431_168"/>
        <feBlend mode="normal" in="SourceGraphic" in2="effect1_backgroundBlur_431_168" result="shape"/>
        </filter>
        </defs>
    </svg>
]])
local icon = svgCreate(16, 16, [[
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M11.39 8C13.542 6.635 15 4.012 15 1C15 0.661 14.981 0.328 14.946 0H1.05498C1.01875 0.332098 1.00072 0.665931 1.00098 1C1.00098 4.012 2.45798 6.635 4.60998 8C2.45798 9.365 1.00098 11.988 1.00098 15C1.00098 15.339 1.01998 15.672 1.05498 16H14.946C14.982 15.672 15 15.339 15 15C15 11.988 13.542 9.365 11.39 8ZM2.49998 15C2.49998 12.079 3.75298 9.603 5.99998 8.786V7.214C3.75298 6.397 2.49998 3.92 2.49998 1H13.5C13.5 3.921 12.247 6.397 9.99998 7.214V8.786C12.247 9.603 13.5 12.08 13.5 15H2.49998ZM9.68198 10.462C8.56198 9.827 8.50098 9.003 8.49998 8.503V7.499C8.49998 6.999 8.55898 6.172 9.68398 5.536C10.286 5.187 10.806 4.656 11.2 3.999H4.79998C5.19498 4.656 5.71598 5.187 6.31798 5.537C7.43798 6.172 7.49898 6.996 7.49998 7.496V8.5C7.49998 9 7.44098 9.827 6.31598 10.463C5.18098 11.122 4.33598 12.427 4.07998 14H11.919C11.663 12.426 10.817 11.121 9.68098 10.462H9.68198Z" fill="white"/>
    </svg>
]])

local function drawRouterStats ( )

    local time = interpolateBetween(timer_route[1], 0, 0, 0, 0, 0, ((getTickCount() - timer_route[3]) / timer_route[1]), 'Linear')
    local min, sec = convertTime(time)

    dxDrawImage(283+80, 959-25, 330, 100, bg, 0, 0, 0, tocolor(255, 255, 255, 155))
   -- dxDrawImage(545, 998, 16, 16, icon, 0, 0, 0, tocolor(255, 255, 255, 255))

    dxDrawText('ROTA DE '..(router_type)..'', 342+35, 982-25, 117, 19, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')
    dxDrawText('Coletas:', 310+70, 1012-14, 55, 19, tocolor(148, 148, 148, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')

    dxDrawText(min..':'..sec, 570+30, 994, 55, 19, tocolor(148, 148, 148, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 20), 'left', 'top')
    dxDrawText(current_router..'/'..max_router, 379+80, 1013-15, 34, 23, tocolor(193, 159, 114, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')

--[[
    if (config["Imagens"][router_type]) then 
       -- dxDrawImage(310+115, 982-30, 18, 18, config["Imagens"][router_type], 0, 0, 0, tocolor(255, 255, 255, 255))
    end
]]
end


function routerStats ( state )
    if state and not stats_handler then 
        stats_handler = true 
        addEventHandler('onClientRender', root, drawRouterStats)
    elseif not state and stats_handler then 
        stats_handler = false 
        removeEventHandler('onClientRender', root, drawRouterStats)
        timer_route = nil
    end
end

addEvent("OnPlayerRouterDraw", true)
addEventHandler("OnPlayerRouterDraw", resourceRoot,
    function ( index, max, _type )
        current_router = index 
        max_router = max
        
        if (timer and isTimer(timer)) then 
            killTimer(timer)
        end

        timer_route = {config["Others"]["time"] * 60000, 0, getTickCount()}
        router_type = _type

        timer = setTimer(function()
            triggerServerEvent("onPlayerTimerFinish", resourceRoot)
        end, config["Others"]["time"] * 60000, 1)

        routerStats(true)
    end
)

addEvent("onPlayerRouterFinish", true)
addEventHandler('onPlayerRouterFinish', resourceRoot, 
    function ( )

        if (timer and isTimer(timer)) then 
            killTimer(timer)
        end

        routerStats(false)
    end
)


function convertTime(ms) 
    local min = math.floor ( ms/30000 ) 
    local sec = math.floor( (ms/1000)%60 ) 
    return min, sec 
end