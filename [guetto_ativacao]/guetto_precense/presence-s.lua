--[[
    https://discord.com/developers/applications <- LINK DISCORD DEVELOPERS PAGE
    CREATE APPLICATION (WITH YOUR SERVER NAME)
    INSERT YOUR SERVER LOGO
    COPY THIS APPLICATION ID
--]]

local application = {
    id = "1220476565993951364", -- Application ID

    server = {
        name = "GUETTO CITY ROLEPLAY",
        logo = "https://i.imgur.com/hjAbdWR.gif",
    },

    buttons = {
        [1] = {
            use = true,
            name = "DISCORD",
            link = "https://discord.gg/rpguetto"
        },

        [2] = {
            use = true,
            name = "ENTRAR CIDADE",
            link = "mtasa://158.69.187.181:22133"
        }
    }
};

addEventHandler("onPlayerResourceStart", root,
    function(theResource)
        if (theResource == getThisResource()) then
            triggerClientEvent(source, "addPlayerRichPresence", resourceRoot, application);
        end
    end
);

addEventHandler("onPlayerLogin", root,
  function()
        triggerClientEvent(source, "addPlayerRichPresence", resourceRoot, application);
  end
);