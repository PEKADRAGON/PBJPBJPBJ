addEvent('SQX.offVoice', true)
addEventHandler('SQX.offVoice', root,
function(player, state)
    if (state == true) then
        setPlayerVoiceIgnoreFrom(player, root)
    else
        setPlayerVoiceIgnoreFrom(player, nil)
    end
end)

