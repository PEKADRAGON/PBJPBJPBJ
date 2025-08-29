local instance = {}
local position = Vector2((1920 - 627 ) / 2, (1080 - 694 ) / 2)

instance.animations = {}

instance.svg = {
    
    ['slot'] = svgCreate(103 , 102 , [[
        <svg width="103" height="102" viewBox="0 0 103 102" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="103" height="102" fill="white"/>
        </svg>
    ]]);

    
    ['line'] = svgCreate(82 , 233 , [[
        <svg width="82" height="233" viewBox="0 0 82 233" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect x="0.5" y="0.5" width="81" height="232" rx="6.5" stroke="white"/>
        </svg>
    ]]);

    ['slot-hotbar'] = svgCreate(99 , 99 , [[
        <svg width="99" height="99" viewBox="0 0 99 99" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="98.0448" height="98.0448" rx="1.44184" fill="white"/>
        </svg>
    ]]);

    ['icon-capacity'] = svgCreate(12 , 12 , [[
        <svg width="12" height="12" viewBox="0 0 12 12" fill="none" xmlns="http://www.w3.org/2000/svg">
            <g clip-path="url(#clip0_228_20)">
            <path d="M11.9597 10.4501L10.248 3.6033C10.159 3.24729 9.86272 3.00049 9.52451 3.00049H8.1124C8.19608 2.76494 8.25022 2.51486 8.25022 2.25049C8.25022 1.00783 7.24287 0.000488281 6.00022 0.000488281C4.75756 0.000488281 3.75021 1.00783 3.75021 2.25049C3.75021 2.51486 3.80412 2.76494 3.88803 3.00049H2.47592C2.13771 3.00049 1.84123 3.24752 1.7524 3.6033L0.0402929 10.4501C-0.154941 11.2308 0.383887 12.0003 1.12568 12.0003H10.8745C11.6161 12.0003 12.1549 11.2308 11.9597 10.4501ZM5.99998 3.00025C5.58654 3.00025 5.24998 2.66369 5.24998 2.25025C5.24998 1.83682 5.58654 1.50025 5.99998 1.50025C6.41342 1.50025 6.74998 1.83682 6.74998 2.25025C6.74998 2.66369 6.41342 3.00025 5.99998 3.00025Z" fill="white"/>
            </g>
            <defs>
            <clipPath id="clip0_228_20">
            <rect width="12" height="12" fill="white"/>
            </clipPath>
            </defs>
        </svg>
    ]]);

    ['rectangle-enable-hotbar'] = svgCreate(16 , 15 , [[
        <svg width="16" height="15" viewBox="0 0 16 15" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="16" height="15" rx="2" fill="white"/>
        </svg>
    ]]);

    ['rectangle-modal-item'] = svgCreate(57 , 53 , [[
        <svg width="57" height="53" viewBox="0 0 57 53" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="57" height="53" rx="2" fill="white"/>
        </svg>
    ]]);
   
    ['slots-inventory-hotbar'] = svgCreate(98, 112, [[
        <svg width="98" height="112" viewBox="0 0 98 112" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect opacity="0.6" width="98" height="112" rx="1.44184" fill="white" fill-opacity="0.12"/>
        </svg>
    ]]);

    ['slot-inventory-stroke'] = svgCreate(98, 112, [[
        <svg width="98" height="112" viewBox="0 0 98 112" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect opacity="0.6" x="0.5" y="0.5" width="97" height="111" rx="0.941835" stroke="#A3A3A3"/>
        </svg>
    ]]);

}

instance.categories = {
    {24 , 82 , 34 , 40 , 'assets/images/icon-bag.png', 'bag'};
    {19 , 154 , 45 , 47 , 'assets/images/icon-food.png', 'food'};
    {16 , 221 , 50 , 50 , 'assets/images/icon-ilegal.png', 'ilegal'};
}

instance['hot-bar'] = {
    {702, 928, 98, 112};
    {807, 928, 98, 112};
    {911, 928, 98, 112};
    {1016, 928, 98, 112};
    {1121, 928, 98, 112};
}

function getItensByIndex (index)
    if not (index) then 
        return 0 
    end

    if not instance.inventory or not instance.inventory.itens[instance.window] then 
        return false
    end

    for i = 1, #instance.inventory.itens[instance.window] do 
        if instance.inventory.itens[instance.window][i].slot == tonumber(index) then 
            return true, i
        end
    end

    return false
end

function getItemHotBar (item)
    if not (item) then 
        return false 
    end

    if not instance.inventory then 
        return false
    end

    for i, v in ipairs (instance.inventory.hotbar) do 
        if (v ~= 'nil' and v == tonumber(item)) then 
            return true, i 
        end
    end

    return false
end

function getItensHotBarByIndex (index)
    if not (index) then 
        return 0 
    end

    if not instance.inventory then 
        return false
    end

 
    for i, v in ipairs (instance.inventory.hotbar) do 
        if (v ~= 'nil' and index == i) then 
            return i, v 
        end
    end

    return false
end

function getClientItem (item)
    if not instance.inventory then 
        return 0 
    end

    local settings = config.itens[tonumber(item)]

    if not settings then 
        return 0 
    end

    for index = 1,  #instance.inventory.itens[settings.category] do 
        if instance.inventory.itens[settings.category][index].item == tonumber(item) then 
            return instance.inventory.itens[settings.category][index].amount, index 
        end
    end
    
    return 0
end

function draw ( )

    local alpha = animation.get('alpha');
    modal_y = animation.get('modal');
    y = animation.get('offSetY');

    instance.buttons = {}

    dxDrawImage(0, 0, 1920, 1080, 'assets/images/blur.png', 0, 0, 0, tocolor(255, 255, 255, alpha))

    local offSetX, offSetY = position.x + 95 , y + 61 

    if not (instance.inventory) then 
        return false 
    end

    for i = 1, 20  do 
        local i_scroll = i + instance.scroll;

        local bool, index = getItensByIndex (i_scroll)

        dxDrawImage(offSetX, offSetY, 103 , 102 , instance.svg['slot'], 0, 0, 0, instance.inventory.slots >= i and tocolor(53, 53, 53, 0.53 * alpha) or tocolor(53, 53, 53, 0.31 * alpha))
        
        if (bool) then 
            local data = instance.inventory.itens[instance.window][index];
            local file = 'assets/itens/'..(data.item)..'.png'

            if instance.item_move ~= index and fileExists(file) then 
                dxDrawImage(offSetX + 103  / 2 - 70  / 2, offSetY + 102  / 2 - 70  / 2, 70 , 70 , file, 0, 0, 0, tocolor(255, 255, 255, alpha))
                dxDrawText(data.amount..'x', offSetX + 35 , offSetY + 5 , 56 , 26 , tocolor(143, 143, 143, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 14), 'right', 'top')
            end

        end

        if instance.inventory.slots >= i then 
            instance.buttons['slots:'..i_scroll] = {offSetX, offSetY, 103 , 102 }
        end

        offSetX = offSetX + 105  
    
        if (i % 5 == 0) then 
            offSetX = position.x + 95  
            offSetY = offSetY + 105 
        end
    
    end

    if instance.inventory.slots < 20 then 
        dxDrawImage(position.x + 221 , y + 346 , 43 , 53 , 'assets/images/icon-lock.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawText('Expansão de slot.', position.x + 279 , y + 340 , 137 , 26 , tocolor(212, 214, 225, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
        dxDrawText('Compre mais 5 slots por 20GP ou\nse torne um vip.', position.x + 279 , y + 364 , 223 , 40 , tocolor(89, 89, 89, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
    end

    local totalContentHeight = 414

    local numVisibleSlots = 40

    local slotHeight = totalContentHeight / numVisibleSlots

    local offSetScroll = y + 61 + slotHeight * instance.scroll

    dxDrawRectangle(position.x + 627, y + 61, 4, 414, tocolor(39, 39, 39, alpha))

    dxDrawRectangle(position.x + 627, offSetScroll, 4, 82, tocolor(89, 89, 89, alpha))

    
    dxDrawText(
        'Mochila | Personagem', position.x + 143 , y + 3 , 143 , 26 , tocolor(212, 214, 225, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top'
    )

    dxDrawText(
        'Aqui você poderá ver seus itens.', position.x + 143 , y + 23 , 137 , 26 , tocolor(89, 89, 89, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top'
    )

    dxDrawText(
        'ATALHOS RAPIDO', position.x + 95 , y + 558 , 137 , 26 , tocolor(212, 214, 225, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 15), 'left', 'top'
    )
    
    dxDrawText(
        'Habilitar hotbar.', position.x + 510 , y + 557 , 137 , 26 , tocolor(143, 143, 143, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 14), 'left', 'top'
    )
    
    dxDrawImage(
        position.x, y + 61 , 82 , 233 , "assets/images/line.png", 0, 0, 0, tocolor(35, 37, 37, alpha)
    )

    for i, v in ipairs ( instance.categories ) do 
        dxDrawImage(
            position.x + v[1], y + v[2], v[3], v[4], v[5], 0, 0, 0, instance.window == v[6] and tocolor(193, 159, 114, alpha) or isCursorOnElement(position.x + v[1], y + v[2], v[3], v[4]) and tocolor(193, 159, 114, alpha) or tocolor(56, 56, 57, alpha)
        )

        instance.buttons['windows:'..i] = {position.x + v[1], y + v[2], v[3], v[4]}
    end

    dxDrawImage(
        position.x + 95 , y + 4  , 37 , 37 , 'assets/images/bag-icon.png', 0, 0, 0, tocolor(255, 255, 255, alpha)
    )

    dxDrawRectangle(
        position.x + 236 , y + 567 , 230 , 1 , tocolor(255, 255, 255, 0.12 * alpha)
    )

    local consumed, max_consumed = instance.inventory.player.actualWeight, instance.inventory.player.maxWeight

    dxDrawRectangle(
        position.x + 95 , y + 519 , 524 , 6 , tocolor(39, 39, 39, alpha)
    )

    dxDrawRectangle(
        position.x + 95 , y + 519 , 524  * consumed / max_consumed, 6 , tocolor(193, 159, 114, alpha)
    )

    dxDrawImage(
        position.x + 97 , y + 497 , 12 , 12 , instance.svg['icon-capacity'], 0, 0, 0, tocolor(255, 255, 255, alpha)
    )

    dxDrawText(
        'Capacidade', position.x + 119 , y + 497 , 59 , 18 , tocolor(221, 221, 221, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 11), 'left', 'top'
    )

    dxDrawText(
        '#FFFFFF'..string.format('%.1f', consumed)..' /#3D3D3D'..string.format('%.1f', max_consumed)..' kg', position.x + 560 , y + 497 , 59 , 18 , tocolor(221, 221, 221, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 11), 'left', 'top', false, false, false, true
    )

    dxDrawImage(
        position.x + 484 , y + 560 , 16 , 15 , instance.svg['rectangle-enable-hotbar'], 0, 0, 0, tocolor(40, 41, 46, alpha)
    )

    instance.buttons['button:enable-hotbar'] = {position.x + 484 , y + 560 , 16 , 15}

    if instance.inventory['enable-hotbar'] == 'false' and isCursorOnElement(position.x + 484 , y + 560 , 16 , 15 ) then 
        
        dxDrawImage(
            position.x + 484  + 16  / 2 - 10  / 2, y + 560  + 15  / 2 - 7  / 2, 10 , 7 , 'assets/images/icon-check.png', 0, 0, 0, tocolor(255, 255, 255, alpha)
        )

    elseif instance.inventory['enable-hotbar'] == 'true' then 
        dxDrawImage(
            position.x + 484  + 16  / 2 - 10  / 2, y + 560  + 15  / 2 - 7  / 2, 10 , 7 , 'assets/images/icon-check.png', 0, 0, 0, tocolor(255, 255, 255, alpha)
        )
    end

    local offSetX = position.x + 95 
    for i = 1, 5 do 
        local index, value = getItensHotBarByIndex ( i )

        dxDrawImage(
            offSetX, y + 596 , 98 , 98 , instance.svg['slot-hotbar'], 0, 0, 0, tocolor(23, 23, 24, 0.37 * alpha)
        )

        if (index and index == i) then 
            local file = 'assets/itens/'..(value)..'.png'
            if fileExists(file) then 
                dxDrawImage(
                    offSetX + 98 / 2 - 69 / 2, y + 596 + 98 / 2 - 60 / 2, 69, 60, file, 0, 0, 0, tocolor(255, 255, 255, alpha)
                )
            end
        else
            dxDrawText(
                i, offSetX, y + 596 , 98 , 98 , tocolor(143, 143, 143, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 18), 'center', 'center'
            )
        end

        instance.buttons['inventory-hotbar:'..i] = {offSetX, y + 596 , 98 , 98}

        offSetX = offSetX + (98  + 7 )
    end

    if instance.item_move then 
        local cx, cy = getCursorPosition()
        local tx, ty = 1920 * cx, 1080 * cy
        local data = instance.inventory.itens[instance.window][instance.item_move];
        if data then 
            local file = 'assets/itens/'..(data.item)..'.png'
            if fileExists(file) then 
                dxDrawImage(tx - 70  / 2, ty - 70  / 2, 70 , 70 , file, 0, 0, 0, tocolor(255, 255, 255, alpha))
            end
        end
    end

    if instance["proposal"] and type(instance["proposal"]) == "table" then 
        local item = instance["proposal"].item;
        local quantidade = instance["proposal"].quantidade
        local settings = config["itens"][item]

        local file = 'assets/itens/'..(item)..'.png'

        if fileExists(file) then 

            dxDrawImage(
                position.x + 627 + 13, y + 61, 209, 110, 'assets/images/rectangle-proposal.png', 0, 0, 0, tocolor(255, 255, 255, alpha)
            )

            dxDrawText(
                'Deseja receber os itens abaixo,\nclique em confirmar.', position.x + 627 + 24, y + 13 + 61, 177, 31, tocolor(89, 89, 89, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 13), 'left', 'center'
            )

            dxDrawText(
                settings["name"], position.x + 627 + 74, y + 108, 177, 31, tocolor(212, 214, 225, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 13), 'left', 'center'
            )

            dxDrawText(
                quantidade.."x", position.x + 627 + 74, y + 129, 56, 26, tocolor(143, 143, 143, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 13), 'left', 'center'
            )

            dxDrawImage(
                position.x + 627 + 20, y + 114, 45, 36, file, 0, 0, 0, tocolor(255, 255, 255, alpha)
            )

            dxDrawImage(
                position.x + 627 + 13, y + 174, 209, 41, "assets/images/rectangle-proposal.png", 0, 0, 0, isCursorOnElement(position.x + 627 + 13, y + 174, 209, 41) and tocolor(255, 255, 255, 0.80 * alpha) or tocolor(255, 255, 255, alpha)
            )

            dxDrawImage(
                position.x + 627 + 13, y + 218, 209, 41, "assets/images/rectangle-proposal.png", 0, 0, 0, isCursorOnElement(position.x + 627 + 13, y + 218, 209, 41) and tocolor(255, 255, 255, 0.80 * alpha) or tocolor(255, 255, 255, alpha)
            )

            dxDrawText(
                "CONFIRMAR", position.x + 627 + 13, y + 174, 209, 41, tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("regular", 13), "center", "center"
            )

            dxDrawText(
                "RECUSAR", position.x + 627 + 13, y + 218, 209, 41, tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("regular", 13), "center", "center"
            )

        end
    end

    if instance.modal and type(instance.modal) == 'table' then 
        local settings = config['itens'][instance.modal.data.item]
        local modal_alpha = animation.get('modal-alpha');

        dxDrawImage(instance.modal.x, modal_y, 201 , 154 , 'assets/images/rectangle-item.png', 0, 0, 0, tocolor(255, 255, 255, modal_alpha))

        dxDrawText(
            settings.name, instance.modal.x + 12 , modal_y + 11 , 122 , 26 , tocolor(143, 143, 143, modal_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top'
        )

        dxDrawText(
            string.format('%.1f', settings.weight * instance.modal.data.amount)..' kg', instance.modal.x + 153 , modal_y + 11 , 36 , 26 , tocolor(143, 143, 143, modal_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'right', 'top'
        )

        dxDrawText(
            'Use as opções abaixo para fazer\ninteração com o item.', instance.modal.x + 12 , modal_y + 35 , 177 , 40 , tocolor(143, 143, 143, modal_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 13), 'left', 'top'
        )

        dxDrawImage(
            instance.modal.x + 12 , modal_y + 86 , 57 , 53 , instance.svg['rectangle-modal-item'], 0, 0, 0, instance['modal-use'] == "usar" and tocolor(193, 159, 114, modal_alpha) or isCursorOnElement(instance.modal.x + 12 , modal_y + 86 , 57 , 53 ) and tocolor (193, 159, 114, modal_alpha) or tocolor(38, 38, 38, modal_alpha)
        )

        dxDrawImage(
            instance.modal.x + 72 , modal_y + 86 , 57 , 53 , instance.svg['rectangle-modal-item'], 0, 0, 0, instance['modal-use'] == "dropar" and tocolor(193, 159, 114, modal_alpha) or isCursorOnElement(instance.modal.x + 72 , modal_y + 86 , 57 , 53 ) and tocolor (193, 159, 114, modal_alpha) or tocolor(38, 38, 38, modal_alpha)
        )

        dxDrawImage(
            instance.modal.x + 132 , modal_y + 86 , 57 , 53, instance.svg['rectangle-modal-item'], 0, 0, 0, instance['modal-use'] == "enviar" and tocolor(193, 159, 114, modal_alpha) or isCursorOnElement(instance.modal.x + 132 , modal_y + 86 , 57 , 53 ) and tocolor (193, 159, 114, modal_alpha) or  tocolor(38, 38, 38, modal_alpha)
        )
        
        dxDrawImage(
            instance.modal.x + 23 , modal_y + 88 , 35 , 35 , 'assets/images/icon-use.png', 0, 0, 0, tocolor(255, 255, 255, modal_alpha)
        )

        dxDrawImage(
            instance.modal.x + 84 , modal_y + 88 , 35 , 35 , 'assets/images/icon-drop.png', 0, 0, 0, tocolor(255, 255, 255, modal_alpha)
        )

        dxDrawImage(
            instance.modal.x + 143 , modal_y + 88 , 35 , 35 , 'assets/images/icon-send.png', 0, 0, 0, tocolor(255, 255, 255, modal_alpha)
        )

        dxDrawText(
            'USAR', instance.modal.x + 28 , modal_y + 121 , 26 , 12 , tocolor(255, 255, 255, modal_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 13), 'center', 'top'
        ) 

        dxDrawText(
            'LARGAR', instance.modal.x + 82 , modal_y + 121 , 38 , 12 , tocolor(255, 255, 255, modal_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 13), 'center', 'top'
        ) 

        dxDrawText(
            'ENVIAR', instance.modal.x + 144 , modal_y + 121 , 34 , 12 , tocolor(255, 255, 255, modal_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 13), 'center', 'top'
        ) 


        if (instance['modal-use']) then 

            dxDrawImage(
                instance.modal.x + 201  + 5 , modal_y, 209 , 110 , 'assets/images/rectangle-use.png', 0, 0, 0, tocolor(16, 16, 16, 0.63 * modal_alpha)
            )
    
            if instance['modal-use'] == "usar" then 
                dxDrawText(
                    'Escolha a quantidade que deseja\nusar.', instance.modal.x + 201  + 5  + 12 , modal_y + 11 , 177 , 40 , tocolor(89, 89, 89, modal_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 13), 'left', 'top'
                )
            elseif instance["modal-use"] == "dropar" then 
                dxDrawText(
                    'Escolha a quantidade que deseja\nlargar.', instance.modal.x + 201  + 5  + 12 , modal_y + 11 , 177 , 40 , tocolor(89, 89, 89, modal_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 13), 'left', 'top'
                )
            elseif instance["modal-use"] == "enviar" then 
                dxDrawText(
                    'Escolha a quantidade que deseja\nenviar.', instance.modal.x + 201  + 5  + 12 , modal_y + 11 , 177 , 40 , tocolor(89, 89, 89, modal_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 13), 'left', 'top'
                )
            end
            
            dxDrawText(
                'Quantidade', instance.modal.x + 201  + 5 + 11 , modal_y + 52 , 177 , 40 , tocolor(212, 214, 225, modal_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'top'
            )
    
            dxDrawImage(
                instance.modal.x + 201  + 5, modal_y + 113 , 209 , 41 , 'assets/images/button-item.png', 0, 0, 0, isCursorOnElement(instance.modal.x + 201  + 5 , modal_y + 113 , 209 , 41 ) and tocolor(193, 159, 114, 0.63 * modal_alpha) or tocolor(16, 16, 16, 0.63 * modal_alpha)
            )
    
            dxDrawText(
                'CONFIRMAR', instance.modal.x + 201  + 5 , modal_y + 113 , 209 , 41 , tocolor(255, 255, 255, modal_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center'
            )

            local qnt = slidebar.getSlidePercent('amount-slide')
            
            slidebar.create("amount-slide", {
                instance.modal.x + 201  + 5 + 12, modal_y + 84, 186, 4
            }, tocolor(34, 34, 35, alpha), tocolor(193, 159, 114, alpha), instance.modal.data.amount, alpha)

            dxDrawText(
                qnt..'x', instance.modal.x + 201  + 5 + 180, modal_y + 52, 18, 26, tocolor(212, 214, 225, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'right', 'top' 
            )

        end

        if instance.visible and modal_alpha <= 0 then 
            instance.modal = false 
        end
    end

    if not instance.visible and alpha <= 0 then 
        removeEventHandler('onClientRender', root, draw)
        slidebar.destroyAllSlid()
        instance['modal-use'] = false
        instance.modal = false 
    end
end

addEventHandler('onClientRender', root, function ( )
    if instance.inventory and instance.inventory['enable-hotbar'] == 'true' then 
        for i = 1, #instance['hot-bar'] do 
            local v = instance['hot-bar'][i]
            local bool, index = getItensHotBarByIndex ( i )
            dxDrawImage(
                v[1], v[2], v[3], v[4], instance.svg['slots-inventory-hotbar'], 0, 0, 0, tocolor(255, 255, 255, 255)
            )
            dxDrawImage(
                v[1], v[2], v[3], v[4], instance.svg['slot-inventory-stroke'], 0, 0, 0, tocolor(255, 255, 255, 255)
            )
            if (bool) then 
                local file = 'assets/itens/'..(index)..'.png'
                if fileExists(file) then 
                    dxDrawImage(
                        v[1] + v[3] / 2 - 69 / 2, v[2] + v[4] / 2 - 60 / 2, 69, 60, file, 0, 0, 0, tocolor(255, 255, 255, 255)
                    )
                end
            else
                dxDrawText(
                    i, v[1], v[2], v[3], v[4], tocolor(143, 143, 143, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 18), 'center', 'center'
                )
            end
        end
    end
end)

function onPlayerClick (button, state)
    if button == 'left' then 
        if state == 'down' then 
            instance.select = false;

            for i, v in pairs (instance.buttons) do 
                if isCursorOnElement(unpack(v)) then 
                    instance.select = i 
                    break 
                end
            end

            if instance.select then
                local separate = split(instance.select, ':')
                if separate[1] == 'slots' then 
                    local bool, index = getItensByIndex (tonumber(separate[2]))
                    if (bool) then 
                        local data = instance.inventory.itens[instance.window][index];
                        if instance.modal then 
                            instance.modal = false 
                            slidebar.destroyAllSlid()
                            instance['modal-use'] = false
                        end
                        instance.item_move = index
                    end
                end
            end

            if (instance["proposal"]) then 
                if isCursorOnElement(position.x + 627 + 13, y + 174, 209, 41) then -- CONFIRMAR
                    triggerServerEvent(
                        "onPlayerAccpetProposal", resourceRoot, instance["proposal"]["item"], instance["proposal"]["quantidade"]
                    )
                    toggle(false)
                    instance["proposal"] = false
                elseif isCursorOnElement(position.x + 627 + 13, y + 218, 209, 41) then -- RECUSAR
                    toggle(false)
                    triggerServerEvent(
                        "onPlayerDeclineProposal", resourceRoot, instance["proposal"]["item"], instance["proposal"]["quantidade"]
                    )
                    instance["proposal"] = false
                end
            end
         
            if instance.modal then 
                if isCursorOnElement(instance.modal.x + 12 , modal_y + 86 , 57 , 53 ) then  -- Usar
                    if (instance['modal-use'] and instance['modal-use'] == "usar") then 
                        slidebar.destroyAllSlid()
                        instance['modal-use'] = false
                    else
                        instance['modal-use'] = "usar" 
                    end
                elseif isCursorOnElement(instance.modal.x + 72 , modal_y + 86 , 57 , 53 ) then  -- Largar
                    if (instance['modal-use'] and instance['modal-use'] == "dropar") then 
                        slidebar.destroyAllSlid()
                        instance['modal-use'] = false
                    else
                        instance['modal-use'] = "dropar" 
                    end
                elseif isCursorOnElement(instance.modal.x + 132 , modal_y + 86 , 57 , 53 ) then  -- Enviar
                    if (instance['modal-use'] and instance['modal-use'] == "enviar") then 
                        slidebar.destroyAllSlid()
                        instance['modal-use'] = false
                    else
                        instance['modal-use'] = "enviar" 
                    end
                end
            end
        elseif state == 'up' then 
            if (instance.modal and type(instance.modal) == 'table') then 
                local x = instance.modal.x
                if isCursorOnElement(x + 201  + 5 , modal_y + 113 , 209 , 41 ) then 
                    if (tonumber(slidebar.getSlidePercent('amount-slide')) <= 0) then 
                        return sendMessageClient("Selecione uma quantidade!", "error")
                    end
                    if instance['modal-use'] then 
                        if instance['modal-use'] == 'dropar' then 
                            triggerServerEvent(
                                "onPlayerDropItem", resourceRoot, instance.modal['data'], tonumber(slidebar.getSlidePercent('amount-slide'))
                            )
                            toggle(false)
                        elseif instance['modal-use'] == "usar" then 
                            triggerServerEvent(
                                "onPlayerUseItem", resourceRoot, instance.modal['data'], tonumber(slidebar.getSlidePercent('amount-slide'))
                            )
                            toggle(false)
                        elseif instance["modal-use"] == "enviar" then 
                            triggerServerEvent(
                                "onPlayerSendItem", resourceRoot, instance.modal['data'], tonumber(slidebar.getSlidePercent('amount-slide'))
                            )
                            toggle(false)
                        end
                    end
                end
            end
            if instance.item_move then 
                for i, v in pairs (instance.buttons) do 
                    if split(i, ':')[1] == 'slots' then 
                        if isCursorOnElement(unpack(v)) then 
                            local bool, index = getItensByIndex (tonumber(split(i, ':')[2]))

                            if bool then 
                                instance.inventory.itens[instance.window][index].slot = instance.inventory.itens[instance.window][instance.item_move].slot 
                                instance.inventory.itens[instance.window][instance.item_move].slot = tonumber(split(i, ':')[2])
                            else
                                instance.inventory.itens[instance.window][instance.item_move].slot = tonumber(split(i, ':')[2])
                            end

                            
                            if instance.modal then 
                                animation.exec('modal', instance.modal.y + 102  / 2 - 154  / 2, instance.modal.y, 400, 'OutQuad')
                                animation.exec('modal-alpha', 255, 0, 400, 'OutQuad')
                            end
                            instance['modal-use'] = false
                            slidebar.destroyAllSlid()
                            triggerServerEvent("inventoryUpdateClient", resourceRoot, instance.inventory)
                        end
                    end
                end
                local offSetX = position.x + 95 
                for i = 1, 5 do 
                    if isCursorOnElement(offSetX, y + 596 , 98 , 98) then 
                        if instance.item_move then 
                            local bool = getItemHotBar (instance.inventory.itens[instance.window][instance.item_move].item)
                            if not bool then 
                                instance.inventory.hotbar[i] = instance.inventory.itens[instance.window][instance.item_move].item
                                triggerServerEvent("inventoryUpdateClient", resourceRoot, instance.inventory)
                            end
                        end
                        break 
                    end
                    offSetX = offSetX + (98  + 7 )
                end
                instance.item_move = false 
            end
            if instance.select then 
                local separate = split(instance.select, ':')
                if separate[1] == 'windows' then 
                    instance.window = instance.categories[tonumber(separate[2])][6]
                    if instance.modal then 
                        animation.exec('modal', instance.modal.y + 102  / 2 - 154  / 2, instance.modal.y, 400, 'OutQuad')
                        animation.exec('modal-alpha', 255, 0, 400, 'OutQuad')
                        instance['modal-use'] = false
                        slidebar.destroyAllSlid()
                    end
                elseif separate[1] == 'button' then 
                    if separate[2] == 'enable-hotbar' then 
                        if instance.inventory['enable-hotbar'] == 'false' then 
                            instance.inventory['enable-hotbar'] = 'true'
                        else
                            instance.inventory['enable-hotbar'] = 'false'
                        end
                        triggerServerEvent("inventoryUpdateClient", resourceRoot, instance.inventory)
                    end
                end
            end
        end
    elseif button == 'right' then 
        if state == 'down' then 
            for i, v in pairs (instance.buttons) do 
                if split(i, ':')[1] == 'slots' then 
                    if isCursorOnElement(unpack(v)) then 
                        local bool, index = getItensByIndex (tonumber(split(i, ':')[2]))
                        if (bool and not animation.isRunning('modal')) then 
                            local cx, cy = getCursorPosition();
                            local tx, ty = 1920 * cx, 1080 * cy
                            if not instance.modal then 
                                instance.modal = {
                                    x =  tx,
                                    y = ty,
                                    data = instance.inventory.itens[instance.window][index];
                                }
                                animation.exec('modal', ty, ty + 102  / 2 - 154  / 2, 400, 'OutQuad')
                                animation.exec('modal-alpha', 0, 255, 400, 'OutQuad')
                            else
                                animation.exec('modal', ty + 102  / 2 - 154  / 2, ty, 400, 'OutQuad')
                                animation.exec('modal-alpha', 255, 0, 400, 'OutQuad')
                                instance['modal-use'] = false
                                slidebar.destroyAllSlid()
                            end
                            break
                        end
                    end
                end
            end
            local offSetX = position.x + 95 
            for i = 1, 5 do 
                if isCursorOnElement(offSetX, y + 596 , 98 , 98) then 
                    local index, value = getItensHotBarByIndex ( i )
                    if index and (index == i) then
                        instance.inventory.hotbar[index] = 'nil' 
                        triggerServerEvent("inventoryUpdateClient", resourceRoot, instance.inventory)
                    end
                end
                offSetX = offSetX + (98  + 7 )
            end
        end
    end
end

function toggle ( state )

    if instance.delay and getTickCount ( ) - instance.delay <= 400 then 
        return false 
    end

    if state and not instance.visible then 
        instance.visible = true 

        if not (instance.window) then 
            instance.window = 'bag'
        end
        
        instance.buttons = false;
        instance.item_move = false;
        
        instance.modal = false;
        instance.scroll = 0;

        instance['modal-use'] = false;
        
        showChat(false)
        showCursor(true)

        animation.exec('alpha', 0, 255, 400, 'OutQuad')
        animation.exec('offSetY', 0, 193 , 400, 'OutQuad')

        triggerServerEvent("inventoryRequestItens", resourceRoot)


        setElementData(localPlayer, 'guetto.open.inventory', true)

        addEventHandler('onClientRender', root, draw)
        addEventHandler('onClientClick', root, onPlayerClick)

    elseif not state and instance.visible then 
        instance.visible = false 
        showChat(true)
        showCursor(false)
        animation.exec('alpha', 255, 0, 400, 'OutQuad')
        animation.exec('offSetY', 193 , 0, 400, 'OutQuad')
        if instance.modal then 
            animation.exec('modal', instance.modal.y + 102  / 2 - 154  / 2, instance.modal.y, 400, 'OutQuad')
            animation.exec('modal-alpha', 255, 0, 400, 'OutQuad')
        end

        setElementData(localPlayer, 'guetto.open.inventory', false)
        removeEventHandler('onClientClick', root, onPlayerClick)
    end
    instance.delay = getTickCount()
end

addEventHandler('onClientResourceStart', resourceRoot, 
    function ( )
        instance.animations.alpha = animation.new('alpha', 0, 0, 400, 'OutQuad', false);
        instance.animations.offSetY = animation.new('offSetY', 0, 0, 400, 'OutQuad', false);
        instance.animations.modal = animation.new('modal', 0, 0, 400, 'OutQuad', false);
        instance.animations.modal_alpha = animation.new('modal-alpha', 0, 0, 400, 'OutQuad', false);
    end 
)

bindKey('b', 'down', function ( )
    toggle(not instance.visible and true or false)
end)


createEventHandler("inventoryClientUpdate", resourceRoot, function (inventory)
    instance.inventory = inventory;
end)

addEventHandler('onClientResourceStart', resourceRoot, function ( )
    triggerServerEvent("inventoryRequestItens", resourceRoot)
end)

local keys = {
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
}

addEventHandler("onClientKey", root, function ( button, press )
    if (instance.visible) then 
        if button == "mouse_wheel_down" and press then 
            if (instance.inventory.slots + instance.scroll < 40) then 
                instance.scroll = instance.scroll + 5
            end
        elseif button == "mouse_wheel_up" and press then
            if instance.scroll > 0 then 
                instance.scroll = instance.scroll - 5
            end
        end
    end
    if keys[tonumber(button)] and press then 
        if (spam and getTickCount ( ) - spam <= 5000) then 
            return sendMessageClient("Aguarde 5 segundos para usar o item novamente!", "info")
        end
        local index, value = getItensHotBarByIndex ( tonumber(button) )
        if index then 
            triggerServerEvent("onPlayerUseItem", resourceRoot, {item = value}, 1)
        end
    end
end)

createEventHandler("TogglePlayerProposal", resourceRoot, function (item, quantidade)
    if not (instance["proposal"]) then 
        instance["proposal"] = {
            item = item,
            quantidade = quantidade
        }
    end
    toggle(true)
end)