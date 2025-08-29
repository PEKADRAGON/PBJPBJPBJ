class 'button' {
    constructor = function (self)
        self.fadeAnimation = {}
    end;

    exec = function (self, id, duration, r2, g2, b2, alpha, verify)
        if (not self.fadeAnimation[id]) then
            self.fadeAnimation[id] = {id = id, duration = duration, alpha = alpha, r = r2, g = g2, b = b2, lastR = r2, lastG = g2, lastB = b2, lastA = alpha, tick = nil};
        end
    
        if (r2 ~= self.fadeAnimation[id].lastR or g2 ~= self.fadeAnimation[id].lastG or b2 ~= self.fadeAnimation[id].lastB or alpha ~= self.fadeAnimation[id].lastA) then
            self.fadeAnimation[id].tick = getTickCount ();
            self.fadeAnimation[id].lastR = r2;
            self.fadeAnimation[id].lastG = g2;
            self.fadeAnimation[id].lastB = b2;
            self.fadeAnimation[id].lastA = alpha;
    
        elseif (self.fadeAnimation[id].r == r2 and self.fadeAnimation[id].g == g2 and self.fadeAnimation[id].b == b2 and self.fadeAnimation[id].alpha == alpha) then
            self.fadeAnimation[id].tick = nil;
        end
    
        if (self.fadeAnimation[id].tick) then
            local interpolate = {interpolateBetween (self.fadeAnimation[id].r, self.fadeAnimation[id].g, self.fadeAnimation[id].b, r2, g2, b2, (getTickCount () - self.fadeAnimation[id].tick) / self.fadeAnimation[id].duration, 'Linear')};
            local interpolateAlpha = interpolateBetween (self.fadeAnimation[id].alpha, 0, 0, alpha, 0, 0, (getTickCount () - self.fadeAnimation[id].tick) / self.fadeAnimation[id].duration, 'Linear');
    
            self.fadeAnimation[id].r = interpolate[1];
            self.fadeAnimation[id].g = interpolate[2];
            self.fadeAnimation[id].b = interpolate[3];
            self.fadeAnimation[id].alpha = interpolateAlpha;
        end
    
        if (verify and ((verify > 0 and verify < 255) and true or false) or false) then
            self.fadeAnimation[id].alpha = alpha;
        end
    
        return tocolor (self.fadeAnimation[id].r, self.fadeAnimation[id].g, self.fadeAnimation[id].b, self.fadeAnimation[id].alpha);
    end;
}
    
button = new 'button' ();