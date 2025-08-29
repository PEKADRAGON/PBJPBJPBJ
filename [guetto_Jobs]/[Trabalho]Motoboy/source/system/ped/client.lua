local function onClientEvents(...)
    if (eventName == 'onClientClick') then
        local b, s, _, _, _, _, _, element = ...

        if (s == 'down' and b == 'left') then
            if (isElement(element) and getElementType(element) == 'ped' and element == ped.ped) then
                if (getDistanceBetweenPoints3D(Vector3(getElementPosition(localPlayer)), Vector3(getElementPosition(ped.ped))) <= 2) then
                    triggerServerEvent('receptTrigger_route_s', localPlayer, 'cameraInPed')
                else
                    exports['FR_DxMessages']:addBox(localPlayer, 'Chegue mais proximo do cliente.','error')

                   -- triggerServerEvent('notify', localPlayer, localPlayer, 'erro', 'Chegue mais proximo do cliente.')
                end
            end
        end
    end
end

class 'ped' {
    constructor = function(self, id, pos, rot)
        self.ped = createPed(id, pos.x, pos.y, pos.z)
        setElementRotation(self.ped, rot.x, rot.y, rot.z)

        self.blip = createBlipAttachedTo(self.ped, 41)

        addEventHandler('onClientClick', root, onClientEvents)

        ped = self
    end,

    delete = function(self)
        removeEventHandler('onClientClick', root, onClientEvents)

        destroyElement(self.blip)
        destroyElement(self.ped)

        self = nil
        ped = nil
    end,

    animation = function(self, ...)
        setPedAnimation(self.ped, ...)
    end,

    cameraInPed = function(self)
        local position = Vector3(getElementPosition(self.ped))
        local rotation = Vector3(getElementRotation(self.ped))

        local dx, dy = dirMove(rotation.z)
        local dx, dy = position.x + dx * 2, position.y + dy * 2

        rotateCamera(rotation.z + 180, 0.6, dx, dy, position.z)
    end
}

addCustomEventHandler('receptTrigger_ped_c', function(type, ...)
    if (type == 'new') then
        if (ped) then
            ped:delete()
        end

        ped = new 'ped'(config.peds[...][1][math.random(#config.peds[...][1])], config.peds[...][2], config.peds[...][3])
    elseif (type == 'delete') then
        if (ped) then
            ped:delete()
        end
    elseif (type == 'animation') then
        if (ped) then
            ped:animation(...)
        end
    elseif (type == 'cameraInPed') then
        if (ped) then
            ped:cameraInPed(...)
        end
    elseif (type == 'checkDistance') then
        if (ped) then
            if (getDistanceBetweenPoints3D(Vector3(getElementPosition(localPlayer)), Vector3(getElementPosition(ped.ped))) <= 10) then
                if (getDistanceBetweenPoints3D(Vector3(getElementPosition(localPlayer)), Vector3(getElementPosition(ped.ped))) > 2) then
                    triggerServerEvent('receptTrigger_route_s', localPlayer, 'getBag')
                else
                    exports['FR_DxMessages']:addBox(localPlayer, 'Afaste-se um pouco do cliente.','error')
                --    triggerServerEvent('notify', localPlayer, localPlayer, 'erro', 'Afaste-se um pouco do cliente.')
                end
            else
                exports['FR_DxMessages']:addBox(localPlayer, 'Chegue mais proximo do cliente.','error')
                --triggerServerEvent('notify', localPlayer, localPlayer, 'erro', 'Chegue mais proximo do cliente.')
            end
        end
    end
end)

function dirMove(rot)
    if rot > 180 then
        rot = 180 - (rot - 180)
    else
        rot = -rot
    end

	local x = math.sin(math.rad(rot))
	local y = math.cos(math.rad(rot))
	return x, y
end

function rotateCamera(rot, rotz, x, y, z, fov)
    local dx, dy = dirMove(rot)
    
    setCameraMatrix(x, y, z + 1, x + dx, y + dy, z + (rotz or 0.6), 0, fov or 70)
end