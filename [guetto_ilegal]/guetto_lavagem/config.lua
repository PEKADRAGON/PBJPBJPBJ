config = {
    ["system"] = {
        ["permissions"] = {"Console", "TDC", "UT", "PCC", "YKZ", "BDM"};
        ["command"] = "lv";
        ["percentage.limit"] = 30;  
    };
}

-- TD7 ate 17/07

function sendMessage (action, element, message, type)
    if action == "client" then
        return exports['guetto_notify']:showInfobox(type, message)
    elseif action == "server" then
        return exports['guetto_notify']:showInfobox(element, type, message)
    end
end