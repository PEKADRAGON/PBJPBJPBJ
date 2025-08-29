config = {

    ["Markers"] = {

        ["Pegar"] = {

            ---DESERTO
            {-334.027, 2224.561, 42.488, "cylinder",  1.5, 139, 100, 255, 0, item = 101, amount = {100, 300} };
            {-329.179, 2229.064, 42.692, "cylinder",  1.5, 139, 100, 255, 0, item = 102, amount = {100, 300} };
            {-328.353, 2221.717, 42.969, "cylinder",  1.5, 139, 100, 255, 0, item = 103, amount = {100, 300} };
            {-330.31, 2215.262, 42.49, "cylinder",  1.5, 139, 100, 255, 0,   item = 104, amount = {100, 300} };
            {-330.751, 2218.128, 42.49, "cylinder",  1.5, 139, 100, 255, 0,  item = 105, amount = {100, 300} };
            {-326.166, 2215.825, 43.704, "cylinder",  1.5, 139, 100, 255, 0, item = 106, amount = {100, 300} };

           --[[
            --DESERTO
            {-334.027, 2224.561, 42.488, "cylinder",  1.5, 139, 100, 255, 0, item = 107, amount = {100, 300} };
            {-329.179, 2229.064, 42.692, "cylinder",  1.5, 139, 100, 255, 0, item = 108, amount = {100, 300} };
            {-328.353, 2221.717, 42.969, "cylinder",  1.5, 139, 100, 255, 0, item = 109, amount = {100, 300} };
            {-330.31, 2215.262, 42.49, "cylinder",  1.5, 139, 100, 255, 0,   item = 110, amount = {100, 300} };
            {-330.751, 2218.128, 42.49, "cylinder",  1.5, 139, 100, 255, 0,  item = 111, amount = {100, 300} };
            {-326.166, 2215.825, 43.704, "cylinder",  1.5, 139, 100, 255, 0, item = 112, amount = {100, 300} };

            {-326.166, 2215.825, 43.704, "cylinder",  1.5, 139, 100, 255, 0, item = 113, amount = {100, 300} };
            {-326.166, 2215.825, 43.704, "cylinder",  1.5, 139, 100, 255, 0, item = 114, amount = {100, 300} };
            {-326.166, 2215.825, 43.704, "cylinder",  1.5, 139, 100, 255, 0, item = 115, amount = {100, 300} };
           ]]
           


        };


        ["Entregar"] = {

            {1901.878, -2019.714, 13.547, "cylinder",  1.5, 139, 100, 255, 0};

        };

    };

    sendMessageClient = function(message, type)
        return exports['guetto_notify']:showInfobox(type, message)
    end;
 
    sendMessageServer = function(player, message, type)
        return exports['guetto_notify']:showInfobox(player, type, message)
    end;

}

function addCustomEvent (event, ...)
    addEvent(event, true)
    addEventHandler(event, ...)
end