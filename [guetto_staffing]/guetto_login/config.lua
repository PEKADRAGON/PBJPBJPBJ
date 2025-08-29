config = {

    ["Others"] = {

        ["discord"] = "discord.gg/rpguetto",
        ["max.accounts"] = 1,

    };

    ["sounds"] = {
        { ["title"] = "Tema do servidor", ["url"] = "https://cdn.discordapp.com/attachments/1237888694292058194/1267196790059303013/WIU_-_Vidigal.mp3?ex=66a9e2ba&is=66a8913a&hm=10110903ac1e1e089f783e6aa9d166efa40f4089f5f52758b2c3a943e319719f&" };
    };

    ["logs"] = {
        ["login"] = "https://discordapp.com/api/webhooks/1246895305958359142/jk2WhTh6IOsnSbEZbuabP6zikwX8j8RniJfpZKeWmDvAyEGU3lXMv-2se9bXMFi2ccN_",
        ["register"] = "https://discordapp.com/api/webhooks/1246895305958359142/jk2WhTh6IOsnSbEZbuabP6zikwX8j8RniJfpZKeWmDvAyEGU3lXMv-2se9bXMFi2ccN_",
    };

    ["midia"] = {
        "Convite de amigos",
        "Youtube/Streaming",
        "Lista do MTA:SA",
        "Outros"    
    };

    sendMessageClient = function(message, type)
        return exports['guetto_notify']:showInfobox(type, message)
    end;
 
    sendMessageServer = function(player, message, type)
        return exports['guetto_notify']:showInfobox(player, type, message)
    end;

}

function registerEventHandler ( event, ... )
    addEvent( event, true )
    addEventHandler( event, ... )
end;

function messageDiscord(message, link)
	sendOptions = {
	    queueName = "dcq",
	    connectionAttempts = 3,
	    connectTimeout = 5000,
	    formFields = {
	        content="```\n"..message.."```"
	    },
	}
	fetchRemote(link, sendOptions, function () return end)
end

