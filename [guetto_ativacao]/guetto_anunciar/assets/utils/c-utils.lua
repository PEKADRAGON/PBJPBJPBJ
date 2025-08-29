function dxGetTextHeight(text, fScale, font)
    if (text) and (fScale) and (font) then
        local fHeight = dxGetFontHeight(1, font)
        local h = fHeight
        for _, world in string.gmatch(text, "\n") do
            h = h+fHeight
        end
        return h, fHeight
    end
end

local fonts = {}
function getFont(font, size)
    local index = font .. size

    if not fonts[index] then
        fonts[index] = dxCreateFont('assets/fonts/' .. font .. '.ttf', size)
    end

    return fonts[index]
end