local config = getConfig ();
local instance = {};
instance.positions = {};

-- position's resource.
instance.positions = {};

-- function's resource.
function onClientRender ()
    local alpha = animation.get ('Domination.alpha');
    moviment = animation.get ('Domination.moviment');

    instance.buttons = false;
end

function onClientClick (button, state)
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
end

function onClientManager (actionName, ...)
    if not (actionName and tostring (actionName)) then
        return false;
    end

    local POST = {...};

    if not (actionName ~= 'show') then
        if not (not instance.visible and not animation.isRunning ('Domination.moviment')) then
            return false;
        end

        instance.visible = true;
        animation.exec ('Domination.alpha', 0, 255, 500, 'Linear');
        animation.exec ('Domination.moviment', 0, 0, 500, 'OutQuad');

        showChat (false);
        showCursor (true);
        addEventHandler ('onClientRender', getRootElement (), onClientRender);
        addEventHandler ('onClientClick', getRootElement (), onClientClick);
    elseif not (actionName ~= 'close') then
        if not (instance.visible and not animation.isRunning ('Domination.moviment')) then
            return false;
        end

        instance.visible = false;
        animation.exec ('Domination.alpha', 255, 0, 500, 'Linear');
        animation.exec ('Domination.moviment', 0, 0, 500, 'InQuad');

        removeEventHandler ('onClientClick', getRootElement (), onClientClick);
        setTimer (function ()
            showChat (true);
            showCursor (false);
            removeEventHandler ('onClientRender', getRootElement (), onClientRender);
        end, 490, 1)
    end
end
addCustomEventHandler ('atlas_resources.onClientManagerDomination', resourceRoot, onClientManager);

-- event's resource.
function instance:start ()
    animation.new ('Domination.alpha', 0, 255, 500, 'Linear', true);
    animation.new ('Domination.moviment', 0, 0, 500, 'OutQuad');
end
addEventHandler ('onClientResourceStart', resourceRoot, instance.start);