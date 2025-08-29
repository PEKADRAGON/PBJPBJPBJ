class 'Animation'{
    constructor = function(self, initial, finish, duration, easing)
        self.initial = initial
        self.finish = finish
        self.duration = duration
        self.easing = easing
        self.tick = nil
    end,

    exec = function(self, initial, finish, duration, easing)
        self.initial = initial
        self.finish = finish
        self.duration = (duration and duration or self.duration)
        self.easing = (easing and easing or self.easing)
        self.tick = getTickCount()
    end,

    get = function(self)
        local animation = self

        if (not animation.tick) then return animation.finish end
        local progress = (getTickCount() - animation.tick) / animation.duration

        if (progress >= 1) then
            self.tick = nil
            return animation.finish
        end

        return interpolateBetween(
            animation.initial, 0, 0,
            animation.finish, 0, 0,
            progress, animation.easing
        )
    end,

    isFinish = function(self)
        return (not self.tick)
    end,
}