local config = getConfig ();
local instance = {};
instance.positions = {};
instance.scroll = {};
instance.calls = {};
instance.countService = 0;
instance.stars = {0, 0};

-- position's resource.
instance.positions = {
    call = Vector2 (middle.x - respc (780)/2, middle.y - respc (505)/2);
    manager = Vector2 (middle.x - respc (1068)/2, middle.y - respc (707)/2);
    avaliation = Vector2 (middle.x - respc (472)/2, middle.y - respc (235)/2);
};

-- scroll's resource.
instance.scroll = {
    calls = {
        proxPage = 0;
        max = 10;
        selected = false;
    };
};

-- function's resource.
local function onClientRender ()
    instance.buttons = false;

    if not (instance.page ~= 'realize-call') then
        local alpha = animation.get ('Call.alpha');
        local moviment = animation.get ('Call.moviment');

        dxDrawImage (instance.positions.call.x, moviment, respc (780), respc (505), 'assets/images/call/bg_background.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawImage (instance.positions.call.x + respc (37), moviment + respc (32), respc (32), respc (32), 'assets/images/call/ic_bug.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawImage (instance.positions.call.x + respc (37), moviment + respc (81), respc (519), respc (66), 'assets/images/call/bg_reason.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ('PAINEL DE CHAMADOS', instance.positions.call.x + respc (91), moviment + respc (35), respc (207), respc (26), tocolor (212, 214, 225, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 18), 'left', 'center');
        
        dxDrawImage (instance.positions.call.x + respc (497), moviment + respc (97), respc (34), respc (34), 'assets/images/call/ic_select.png', 0, 0, 0, (isCursorOnElement (instance.positions.call.x + respc (497), moviment + respc (97), respc (34), respc (34)) and button.exec ('select-btn', 500, {255, 255, 255, alpha}, alpha) or button.exec ('select-btn', 500, {212, 214, 225, alpha}, alpha)));

        if (isCursorOnElement (instance.positions.call.x + respc (497), moviment + respc (97), respc (34), respc (34))) then
            instance.buttons = {type = 'button:select:panel'};
        end

        local selectSection = interpolate (instance.select and 0 or 1.009, instance.select and 1.009 or 0, 0.1, 'selectSection');
        local alphaSection = interpolate (selectSection >= 1 and 0 or 1, selectSection >= 1 and 1 or 0, 0.2, 'alphaSection');

        dxDrawImage (instance.positions.call.x + respc (33), moviment + respc (155), respc (519), respc (148) * selectSection, 'assets/images/call/bg_reasons.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        for i = 1, 3 do
            local spacing = (i - 1) * 35;

            dxDrawText (config.Reasons[i], instance.positions.call.x + respc (58), moviment + respc (179) + respc (spacing), respc (207), respc (26), (instance.index == i and tocolor (243, 182, 125, alpha * alphaSection) or tocolor (212, 214, 225, alpha * alphaSection * 0.47)), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 18), 'left', 'center');

            if (isCursorOnElement (instance.positions.call.x + respc (58), moviment + respc (179) + respc (spacing), respc (207), respc (26))) then
                instance.buttons = {type = 'button:select:reason', data = i};
            end
        end

        if (instance.select) then
            dxEditboxDestroy ('editbox:reason');
        else
            dxDrawImage (instance.positions.call.x + respc (37), moviment + respc (156), respc (713), respc (223), 'assets/images/call/bg_reasonCall.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
            dxDrawText ('Descreva o motivo', instance.positions.call.x + respc (53), moviment + respc (173), respc (190), respc (26), tocolor (212, 214, 225, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Medium.ttf', 18), 'left', 'center');
            dxCreateEditbox ('editbox:reason', {instance.positions.call.x + respc (53), moviment + respc (199), respc (679), respc (120)}, 250, {tocolor (89, 89, 89, alpha), tocolor (89, 89, 89, alpha)}, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 15), 'Escreva aqui', false, false, false, false, true);
        end

        dxDrawImage (instance.positions.call.x + respc (566), moviment + respc (81), respc (184), respc (66), 'assets/images/call/bg_close.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ('FECHAR', instance.positions.call.x + respc (589), moviment + respc (101), respc (139), respc (26), (isCursorOnElement (instance.positions.call.x + respc (566), moviment + respc (81), respc (184), respc (66)) and button.exec ('close-btn', 500, {255, 255, 255, alpha}, alpha) or button.exec ('close-btn', 500, {212, 214, 225, alpha * 0.47}, alpha)), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 18), 'center', 'center');

        if (isCursorOnElement (instance.positions.call.x + respc (566), moviment + respc (81), respc (184), respc (66))) then
            instance.buttons = {type = 'button:close:panel', data = 'close'};
        end

        dxDrawText ('Motivo:', instance.positions.call.x + respc (53), moviment + respc (100), respc (190), respc (26), tocolor (212, 214, 225, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Medium.ttf', 18), 'left', 'center');
        dxDrawText (config.Reasons[instance.index], instance.positions.call.x + respc (131), moviment + respc (100), respc (207), respc (26), tocolor (212, 214, 225, alpha * 0.47), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 18), 'left', 'center');

        dxDrawImage (instance.positions.call.x + respc (37), moviment + respc (396), respc (713), respc (66), 'assets/images/call/bg_button.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ('ENVIAR CHAMADO', instance.positions.call.x + respc (293), moviment + respc (416), respc (201), respc (26), (isCursorOnElement (instance.positions.call.x + respc (37), moviment + respc (396), respc (713), respc (66)) and button.exec ('call-btn', 500, {255, 255, 255, alpha}, alpha) or button.exec ('call-btn', 500, {212, 214, 225, alpha * 0.47}, alpha)), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 18), 'center', 'center');

        if (isCursorOnElement (instance.positions.call.x + respc (37), moviment + respc (396), respc (713), respc (66))) then
            instance.buttons = {type = 'button:send:call', data = instance.index};
        end
    elseif not (instance.page ~= 'manager-call') then
        local alpha = animation.get ('Manager.alpha');
        local moviment = animation.get ('Manager.moviment');

        dxDrawImage (instance.positions.manager.x, moviment, respc (1068), respc (707), 'assets/images/manager/bg_background.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawImage (instance.positions.manager.x + respc (58), moviment + respc (26), respc (36), respc (36), 'assets/images/manager/ic_hammer.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ('PAINEL DE CHAMADOS', instance.positions.manager.x + respc (112), moviment + respc (31), respc (207), respc (26), tocolor (212, 214, 225, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 18), 'left', 'center');
        
        dxDrawImage (instance.positions.manager.x + respc (44), moviment + respc (90), respc (322), respc (560), 'assets/images/manager/bg_calls.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ('SOLICITAÇÕES', instance.positions.manager.x + respc (126), moviment + respc (101), respc (159), respc (26), tocolor (212, 214, 225, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Medium.ttf', 15), 'center', 'center');
        
        line = 0;
        for i, v in ipairs (instance.calls) do
            if (i > instance.scroll.calls.proxPage and line < instance.scroll.calls.max) then
                line = line + 1;
                local pos = (moviment + respc (170) - respc (47) + (line * respc (47)));

                dxDrawImage (instance.positions.manager.x + respc (76), pos + respc (2), respc (24), respc (24), 'assets/images/manager/ic_call.png', 0, 0, 0, ((instance.scroll.calls.selected == line or isCursorOnElement (instance.positions.manager.x + respc (76), pos, respc (208), respc (26))) and button.exec ('call-'..line, 500, {255, 255, 255, alpha}, alpha) or button.exec ('call-'..line, 500, {156, 156, 156, alpha}, alpha)));
                dxDrawText ('Chamado #'..(v.idCall), instance.positions.manager.x + respc (109), pos, respc (175), respc (26), ((instance.scroll.calls.selected == line or isCursorOnElement (instance.positions.manager.x + respc (76), pos, respc (208), respc (26))) and button.exec ('callT-'..line, 500, {243, 182, 125, alpha}, alpha) or button.exec ('callT-'..line, 500, {156, 156, 156, alpha}, alpha)), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 15), 'left', 'center');

                if (isCursorOnElement (instance.positions.manager.x + respc (76), pos, respc (208), respc (26))) then
                    instance.buttons = {type = 'button:select:scroll', data = line};
                end
            end
        end

        dxDrawImage (instance.positions.manager.x + respc (820), moviment + respc (20), respc (207), respc (48), 'assets/images/manager/bg_support.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawImage (instance.positions.manager.x + respc (833), moviment + respc (31), respc (26), respc (26), 'assets/images/manager/ic_global.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ('Suporte', instance.positions.manager.x + respc (874), moviment + respc (31), respc (50), respc (26), tocolor (255, 255, 255, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 15), 'left', 'center');
        dxDrawText (instance.countService or 0, instance.positions.manager.x + respc (986), moviment + respc (31), respc (28), respc (26), tocolor (255, 255, 255, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 15), 'right', 'center');
        
        dxDrawImage (instance.positions.manager.x + respc (391), moviment + respc (90), respc (648), respc (116), 'assets/images/manager/bg_infos.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawImage (instance.positions.manager.x + respc (419), moviment + respc (126), respc (46), respc (46), 'assets/images/manager/ic_user.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ('Chamado de', instance.positions.manager.x + respc (480), moviment + respc (120), respc (131), respc (26), tocolor (212, 214, 225, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Medium.ttf', 15), 'left', 'center');
        dxDrawText ((instance.scroll.calls.selected ~= false and (instance.calls[instance.scroll.calls.selected].name..'#'..instance.calls[instance.scroll.calls.selected].id) or 'Indefinido'), instance.positions.manager.x + respc (480), moviment + respc (151), respc (143), respc (26), tocolor (89, 89, 89, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 18), 'left', 'center');
        
        time2 = 0;
        if (instance.scroll.calls.selected ~= false) then
            time2 = instance.tick - (instance.calls[instance.scroll.calls.selected].timeWaited);
            time2 = convertTime (time2);
        else
            time2 = 0;
        end

        dxDrawImage (instance.positions.manager.x + respc (696), moviment + respc (128), respc (40), respc (40), 'assets/images/manager/ic_clock.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ('Tempo de espera', instance.positions.manager.x + respc (750), moviment + respc (120), respc (149), respc (26), tocolor (212, 214, 225, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Medium.ttf', 15), 'left', 'center');
        dxDrawText ((instance.scroll.calls.selected ~= false and time2 or 'Indefinido'), instance.positions.manager.x + respc (753), moviment + respc (151), respc (143), respc (26), tocolor (89, 89, 89, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 18), 'left', 'center');
        
        dxDrawImage (instance.positions.manager.x + respc (391), moviment + respc (217), respc (362), respc (62), 'assets/images/manager/bg_reason.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ('Motivo:', instance.positions.manager.x + respc (419), moviment + respc (235), respc (66), respc (26), tocolor (212, 214, 225, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Medium.ttf', 18), 'left', 'center');
        dxDrawText ((instance.scroll.calls.selected ~= false and instance.calls[instance.scroll.calls.selected].reason or 'Indefinido'), instance.positions.manager.x + respc (502), moviment + respc (235), respc (141), respc (26), tocolor (89, 89, 89, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 18), 'left', 'center');
        
        time = 0;
        if (instance.scroll.calls.selected ~= false) then
            time = convertTimestamp (instance.calls[instance.scroll.calls.selected].hourCalled);
        else
            time = 0;
        end

        dxDrawImage (instance.positions.manager.x + respc (761), moviment + respc (217), respc (278), respc (62), 'assets/images/manager/bg_hour.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ('Horário:', instance.positions.manager.x + respc (780), moviment + respc (235), respc (89), respc (26), tocolor (212, 214, 225, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Medium.ttf', 18), 'left', 'center');
        dxDrawText ((instance.scroll.calls.selected ~= false and time or 'Indefinido'), instance.positions.manager.x + respc (864), moviment + respc (235), respc (114), respc (26), tocolor (89, 89, 89, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 18), 'left', 'center');

        dxDrawImage (instance.positions.manager.x + respc (391), moviment + respc (290), respc (648), respc (266), 'assets/images/manager/bg_description.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ('Breve descrição.', instance.positions.manager.x + respc (419), moviment + respc (308), respc (190), respc (26), tocolor (212, 214, 225, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Medium.ttf', 18), 'left', 'center');
        
        if not (instance.scroll.calls.selected) then
            dxDrawText ('SEM DESCRIÇÃO', instance.positions.manager.x + respc (414), moviment + respc (388), respc (602), respc (70), tocolor (89, 89, 89, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 15), 'center', 'center');
        else
            dxDrawText (instance.calls[instance.scroll.calls.selected].description, instance.positions.manager.x + respc (419), moviment + respc (335), respc (602), respc (70), tocolor (89, 89, 89, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 15), 'left', 'top', false, true);
        end

        dxDrawImage (instance.positions.manager.x + respc (391), moviment + respc (575), respc (648), respc (75), 'assets/images/manager/bg_button.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ((instance.scroll.calls.selected ~= false and 'ACEITAR CHAMADO' or 'SELECIONE O CHAMADO'), instance.positions.manager.x + respc (391), moviment + respc (575), respc (648), respc (75), (isCursorOnElement (instance.positions.manager.x + respc (391), moviment + respc (575), respc (648), respc (75)) and button.exec ('select-btn', 500, {255, 255, 255, alpha}, alpha) or button.exec ('select-btn', 500, {212, 214, 225, alpha * 0.47}, alpha)), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 18), 'center', 'center');

        if (isCursorOnElement (instance.positions.manager.x + respc (391), moviment + respc (575), respc (648), respc (75))) then
            instance.buttons = {type = 'button:accept:call', data = instance.scroll.calls.selected};
        end
    elseif not (instance.page ~= 'avaliation-call') then
        local alpha = animation.get ('Avaliation.alpha');
        local moviment = animation.get ('Avaliation.moviment');

        dxDrawImage (instance.positions.avaliation.x, moviment, respc (472), respc (198), 'assets/images/avaliation/bg_background.png', 0, 0, 0, tocolor (255, 255, 255, alpha));
        dxDrawText ('Avaliação', instance.positions.avaliation.x + respc (141), moviment + respc (22), respc (190), respc (26), tocolor (212, 214, 225, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Medium.ttf', 18), 'center', 'center');

        dxDrawText ('Faça sua avaliação para este atendimento sendo 1 estrela\nruim e 5 ótimo.', instance.positions.avaliation.x + respc (23), moviment + respc (52), respc (426), respc (36), tocolor (89, 89, 89, alpha), 1, dxCreateFont ('assets/fonts/SFProDisplay-Regular.ttf', 15), 'center', 'center');

        dxDrawImage (instance.positions.avaliation.x + respc (71), moviment + respc (103), respc (330), respc (50), 'assets/images/avaliation/ic_stars.png', 0, 0, 0, tocolor (45, 46, 48, alpha));

        local starsInterpolate = interpolate (0, instance.stars[1], 0.1, 'stars');
        dxDrawImageSection (instance.positions.avaliation.x + respc (71), moviment + respc (103), respc (330) * starsInterpolate, respc (50), 0, 0, 330 * starsInterpolate, 50, 'assets/images/avaliation/ic_stars.png', 0, 0, 0, tocolor (243, 182, 125, alpha));

        if (isCursorOnElement (instance.positions.avaliation.x + respc (71), moviment + respc (103), respc (50), respc (50))) then
            instance.buttons = {type = 'button:change:stars', data = {0.2, 1}};
        elseif (isCursorOnElement (instance.positions.avaliation.x + respc (141), moviment + respc (103), respc (50), respc (50))) then
            instance.buttons = {type = 'button:change:stars', data = {0.4, 2}};
        elseif (isCursorOnElement (instance.positions.avaliation.x + respc (211), moviment + respc (103), respc (50), respc (50))) then
            instance.buttons = {type = 'button:change:stars', data = {0.6, 3}};
        elseif (isCursorOnElement (instance.positions.avaliation.x + respc (281), moviment + respc (103), respc (50), respc (50))) then
            instance.buttons = {type = 'button:change:stars', data = {0.8, 4}};
        elseif (isCursorOnElement (instance.positions.avaliation.x + respc (351), moviment + respc (103), respc (50), respc (50))) then
            instance.buttons = {type = 'button:change:stars', data = {1, 5}};
        end
    end
end

local function onClientClick (button, state)
    if not (button == 'left' and state == 'down') then
        return false;
    end

    if not (instance.visible) then
        return false;
    end

    local buttons = instance.buttons;

    if not (buttons) then
        return false;
    end

    if not (instance.page ~= 'realize-call') then
        if not (buttons.type ~= 'button:close:panel') then
            onClientManager (buttons.data);
        elseif not (buttons.type ~= 'button:select:panel') then
            instance.select = not instance.select;
        elseif not (buttons.type ~= 'button:select:reason') and instance.select then
            if not (instance.select) then
                return false;
            end
            if not (instance.index ~= buttons.data) then
                return false;
            end

            instance.index = buttons.data;
            instance.select = false;
        elseif not (buttons.type ~= 'button:send:call') then
            if (instance.select) then
                return false;
            end

            local descriptionCall = dxEditboxGetText ('editbox:reason');

            if (descriptionCall.len == 0) then
                message ('client', 'Descreva o motivo do chamado.', 'error');
                return false;
            end

            if (descriptionCall.len <= 10) then
                message ('client', 'Digite mais de 10 caracterios.', 'error');
                return false;
            end

            triggerServerEvent ('atlas_resources.managerCall', resourceRoot, {
                actionName = 'call';
                args = {
                    reason = config.Reasons[buttons.data];
                    description = descriptionCall.content;
                };
            });
        end
    elseif not (instance.page ~= 'manager-call') then
        if not (buttons.type ~= 'button:select:scroll') then
            if not (instance.scroll.calls.selected ~= buttons.data) then
                instance.scroll.calls.selected = false;
            else
                instance.scroll.calls.selected = buttons.data;
            end
        elseif not (buttons.type ~= 'button:accept:call') then
            if not (instance.scroll.calls.selected) then
                return false;
            end

            triggerServerEvent ('atlas_resources.managerCall', resourceRoot, {
                actionName = 'accept-call';
                args = {
                    id = instance.calls[instance.scroll.calls.selected].id;
                };
            });
        end
    elseif not (instance.page ~= 'avaliation-call') then
        if not (buttons.type ~= 'button:change:stars') then
            instance.stars = buttons.data;

            onClientManager ('close-avaliation');
            triggerServerEvent ('atlas_resources.managerCall', resourceRoot, {
                actionName = 'stars';
                args = {
                    quantity = instance.stars[2];
                    staff = instance.staffPlayer;
                };
            });
        end
    end
end

function onClientManager (method, ...)
    if not (method and tostring (method)) then
        return false;
    end

    local POST = {...};

    if not (method ~= 'show') then
        if not (not instance.visible and not animation.isRunning ('Call.moviment')) then
            return false;
        end

        instance.visible = true;
        instance.select = false;
        instance.page = 'realize-call';
        instance.index = 1;
        animation.exec ('Call.alpha', 0, 255, 500, 'Linear');
        animation.exec ('Call.moviment', instance.positions.call.y + 40, instance.positions.call.y, 500, 'OutQuad');

        showChat (false);
        showCursor (true);
        dxEditboxDestroy ('editbox:reason');
        addEventHandler ('onClientClick', root, onClientClick);
        addEventHandler ('onClientRender', root, onClientRender);
    elseif not (method ~= 'close') then
        if not (instance.visible and not animation.isRunning ('Call.moviment')) then
            return false;
        end

        instance.visible = false;
        animation.exec ('Call.alpha', 255, 0, 500, 'Linear');
        animation.exec ('Call.moviment', instance.positions.call.y, instance.positions.call.y + 40, 500, 'InQuad');

        removeEventHandler ('onClientClick', root, onClientClick); 
        setTimer (function ()
            showChat (true);
            showCursor (false);
            removeEventHandler ('onClientRender', root, onClientRender);
        end, 490, 1)
    elseif not (method ~= 'show-manager') then
        if not (not instance.visible and not animation.isRunning ('Manager.moviment')) then
            return false;
        end

        instance.visible = true;
        instance.page = 'manager-call';
        instance.calls = POST[1];
        instance.tick = POST[2];

        animation.exec ('Manager.alpha', 0, 255, 500, 'Linear');
        animation.exec ('Manager.moviment', instance.positions.manager.y + 40, instance.positions.manager.y, 500, 'OutQuad');

        instance.countService = 0;
        for i, v in ipairs (getElementsByType ('player')) do
            if (getElementData (v, config.Datas.staff)) then
                instance.countService = instance.countService + 1;
            end
        end

        showChat (false);
        showCursor (true);
        bindKey ('backspace', 'down', close);
        bindKey ('mouse_wheel_down', 'down', scrollbar);
        bindKey ('mouse_wheel_up', 'down', scrollbar);
        addEventHandler ('onClientClick', root, onClientClick);
        addEventHandler ('onClientRender', root, onClientRender);
    elseif not (method ~= 'close-manager') then
        if not (instance.visible and not animation.isRunning ('Manager.moviment')) then
            return false;
        end

        instance.visible = false;
        instance.scroll.calls.selected = false;
        animation.exec ('Manager.alpha', 255, 0, 500, 'Linear');
        animation.exec ('Manager.moviment', instance.positions.manager.y, instance.positions.manager.y + 40, 500, 'InQuad');

        removeEventHandler ('onClientClick', root, onClientClick);
        unbindKey ('backspace', 'down', close);
        unbindKey ('mouse_wheel_down', 'down', scrollbar);
        unbindKey ('mouse_wheel_up', 'down', scrollbar);
        setTimer (function ()
            showChat (true);
            showCursor (false);
            removeEventHandler ('onClientRender', root, onClientRender);
        end, 490, 1)
    elseif not (method ~= 'show-avaliation') then
        if not (not instance.visible and not animation.isRunning ('Avaliation.moviment')) then
            return false;
        end

        instance.visible = true;
        instance.page = 'avaliation-call';
        instance.staffPlayer = nil;
        instance.staffPlayer = POST[1];
        instance.stars = {0, 0};
        animation.exec ('Avaliation.alpha', 0, 255, 500, 'Linear');
        animation.exec ('Avaliation.moviment', instance.positions.avaliation.y + 40, instance.positions.avaliation.y, 500, 'OutQuad');

        showChat (false);
        showCursor (true);
        addEventHandler ('onClientClick', root, onClientClick);
        addEventHandler ('onClientRender', root, onClientRender);
    elseif not (method ~= 'close-avaliation') then
        if not (instance.visible and not animation.isRunning ('Avaliation.moviment')) then
            return false;
        end

        instance.visible = false;
        animation.exec ('Avaliation.alpha', 255, 0, 500, 'Linear');
        animation.exec ('Avaliation.moviment', instance.positions.avaliation.y, instance.positions.avaliation.y + 40, 500, 'InQuad');

        removeEventHandler ('onClientClick', root, onClientClick);
        setTimer (function ()
            showChat (true);
            showCursor (false);
            removeEventHandler ('onClientRender', root, onClientRender);
        end, 490, 1)
    end
end
createEventHandler ('atlas_resources.clientManagerPanel', resourceRoot, onClientManager);

function close (button)
    if not (button) then
        return false;
    end

    if not (button ~= 'backspace') then
        onClientManager ('close-manager');
    end
end

function scrollbar (button)
    if not (button) then
        return false;
    end

    if not (button ~= 'mouse_wheel_down') then
        if not (instance.scroll.calls.proxPage >= #instance.calls - instance.scroll.calls.max) then
            instance.scroll.calls.proxPage = instance.scroll.calls.proxPage + 1;
        end
    elseif not (button ~= 'mouse_wheel_up') then
        if not (instance.scroll.calls.proxPage > 0) then
            instance.scroll.calls.proxPage = instance.scroll.calls.proxPage - 1;
        end
    end    
end

-- event's resource.
addEventHandler ('onClientResourceStart', resourceRoot, function ()
    animation.new ('Call.alpha', 0, 255, 500, 'Linear', true);
    animation.new ('Call.moviment', 0, 0, 500, 'OutQuad');
    animation.new ('Manager.alpha', 0, 255, 500, 'Linear', true);
    animation.new ('Manager.moviment', 0, 0, 500, 'OutQuad');
    animation.new ('Avaliation.alpha', 0, 255, 500, 'Linear', true);
    animation.new ('Avaliation.moviment', 0, 0, 500, 'OutQuad');
end);