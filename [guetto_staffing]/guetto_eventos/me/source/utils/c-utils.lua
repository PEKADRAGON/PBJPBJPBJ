local color_animation = {};

_getPlayerName = getPlayerName;
function getPlayerName(element)
    return _getPlayerName(element):gsub("#%x%x%x%x%x%x", "") or _getPlayerName(element);
end

function formatNumber(number) 
    while true do      
        number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1.%2');
        if (k == 0) then      
            break;
        end  
    end  
    return number;
end

function math.round(number, decimals, method)
    decimals = decimals or 0;
    local factor = 10 ^ decimals;
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor;
    else return tonumber(("%."..decimals.."f"):format(number)); end
end

function fadeButton(id, duration, r2, g2, b2, alpha, verify)
    if (not color_animation[id]) then
        color_animation[id] = {id = id, duration = duration, alpha = alpha, r = r2, g = g2, b = b2, lastR = r2, lastG = g2, lastB = b2, lastA = alpha, tick = nil};
    end

    if (r2 ~= color_animation[id].lastR or g2 ~= color_animation[id].lastG or b2 ~= color_animation[id].lastB or alpha ~= color_animation[id].lastA) then
        color_animation[id].tick = getTickCount();
        color_animation[id].lastR = r2;
        color_animation[id].lastG = g2;
        color_animation[id].lastB = b2;
        color_animation[id].lastA = alpha;

    elseif (color_animation[id].r == r2 and color_animation[id].g == g2 and color_animation[id].b == b2 and color_animation[id].alpha == alpha) then
        color_animation[id].tick = nil;
    end

    if (color_animation[id].tick) then
        local interpolate = {interpolateBetween(color_animation[id].r, color_animation[id].g, color_animation[id].b, r2, g2, b2, (getTickCount() - color_animation[id].tick) / color_animation[id].duration, 'Linear')};
        local interpolateAlpha = interpolateBetween(color_animation[id].alpha, 0, 0, alpha, 0, 0, (getTickCount() - color_animation[id].tick) / color_animation[id].duration, 'Linear');

        color_animation[id].r = interpolate[1];
        color_animation[id].g = interpolate[2];
        color_animation[id].b = interpolate[3];
        color_animation[id].alpha = interpolateAlpha;
    end

    if (verify and ((verify > 0 and verify < 255) and true or false) or false) then
        color_animation[id].alpha = alpha;
    end

    return tocolor(color_animation[id].r, color_animation[id].g, color_animation[id].b, color_animation[id].alpha);
end