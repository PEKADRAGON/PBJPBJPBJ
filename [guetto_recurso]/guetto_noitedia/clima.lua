function messageC (message, type)
    return exports['guetto_notify']:showInfobox(type, message)
end

addCommandHandler("noite",
    function()
        messageC("Você trocou para o horário da noite!", "success");
        setMinuteDuration(21600000);
        setTime(00, 00);
    end
);

addCommandHandler("dia",
    function()
        messageC("Você trocou para o horário do dia!", "success");
        setMinuteDuration(21600000);
        setTime(12, 00);
    end
);