config = {
    adminPanel = {
        permissions = {"Console", "Creator", "Diretor-Geral", "Diretor", "Diretor-Geral-Adjunto", "Vice-diretor", "Gerência", "Superiores", "Moderador-geral", "Moderador", "Suporte", "Ajudante", "Estagiário"};
        aclsVerification = {"Console", "Creator", "Diretor-Geral", "Diretor", "Diretor-Geral-Adjunto", "Vice-diretor", "Gerência", "Superiores", "Moderador-geral", "Suporte", "Moderador", "Ajudante"};
        --aclsVerification = {};
        automatic_password = "guetto27021997@";
    };

    permissionsFunctions = {
        ["Console"] = {
            start = true; -- Iniciar recurso.
            stop = true; -- Parar recurso.
            restart = true; -- Reiniciar recurso.
            weather = true; -- Setar clima.
            time = true; -- Setar hora.
            gamespeed = true; -- Setar velocidade do jogo.
            waveheight = true; -- Setar altura das ondas.
            fpslimit = true; -- Setar limite de FPS.
            gravitation = true; -- Setar gravidade.
            clear_chat = true; -- Limpar chat.
            on_going_maintenance = true; -- Colocar servidor em manutenção.
            set_password_automatic = true; -- Setar senha automaticamente.
            kick_all_players = true; -- Kickar todos os players.
            start_maintenance = true; -- Iniciar manutenção.
            reset_password = true; -- Resetar senha.
            set_password = true; -- Setar senha.
            set_gametype = true; -- Setar gametype.
            manage_acl = true; -- Gerenciar ACL.
            execute_command = true; -- Executar comando lado server/client.
            punishment = true; -- Permissão para banir.
            tphere = true; -- Permissão para teleportar player até você.
            tp = true; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = true; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player. (BUGADO)
            setnick = true; -- Permissão para setar nick.
            setvida = true; -- Permissão para setar vida.
            setcolete = true; -- Permissão para setar colete.
            setweapons = true; -- Permissão para setar armas.
            setmoney = true; -- Permissão para setar dinheiro.
            setvehicle = true; -- Permissão para setar veículo.
            setdimension = true; -- Permissão para setar dimensão.
            setinterior = true; -- Permissão para setar interior.
            repair = true; -- Permissão para reparar veículo.
            destroy = true; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };

        ["Creator"] = {
            start = true; -- Iniciar recurso.
            stop = true; -- Parar recurso.
            restart = true; -- Reiniciar recurso.
            weather = true; -- Setar clima.
            time = true; -- Setar hora.
            gamespeed = true; -- Setar velocidade do jogo.
            waveheight = true; -- Setar altura das ondas.
            fpslimit = true; -- Setar limite de FPS.
            gravitation = true; -- Setar gravidade.
            clear_chat = true; -- Limpar chat.
            on_going_maintenance = true; -- Colocar servidor em manutenção.
            set_password_automatic = true; -- Setar senha automaticamente.
            kick_all_players = true; -- Kickar todos os players.
            start_maintenance = true; -- Iniciar manutenção.
            reset_password = true; -- Resetar senha.
            set_password = true; -- Setar senha.
            set_gametype = true; -- Setar gametype.
            manage_acl = true; -- Gerenciar ACL.
            execute_command = true; -- Executar comando lado server/client.
            punishment = true; -- Permissão para banir.
            tphere = true; -- Permissão para teleportar player até você.
            tp = true; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = true; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player.
            setnick = true; -- Permissão para setar nick.
            setvida = true; -- Permissão para setar vida.
            setcolete = true; -- Permissão para setar colete.
            setweapons = true; -- Permissão para setar armas.
            setmoney = true; -- Permissão para setar dinheiro.
            setvehicle = true; -- Permissão para setar veículo.
            setdimension = true; -- Permissão para setar dimensão.
            setinterior = true; -- Permissão para setar interior.
            repair = true; -- Permissão para reparar veículo.
            destroy = true; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };

        ["Diretor-Geral"] = {
            start = false; -- Iniciar recurso.
            stop = false; -- Parar recurso.
            restart = false; -- Reiniciar recurso.
            weather = true; -- Setar clima.
            time = true; -- Setar hora.
            gamespeed = false; -- Setar velocidade do jogo.
            waveheight = false; -- Setar altura das ondas.
            fpslimit = true; -- Setar limite de FPS.
            gravitation = false; -- Setar gravidade.
            clear_chat = true; -- Limpar chat.
            on_going_maintenance = false; -- Colocar servidor em manutenção.
            set_password_automatic = false; -- Setar senha automaticamente.
            kick_all_players = false; -- Kickar todos os players.
            start_maintenance = false; -- Iniciar manutenção.
            reset_password = false; -- Resetar senha.
            set_password = false; -- Setar senha.
            set_gametype = false; -- Setar gametype.
            manage_acl = true; -- Gerenciar ACL.
            execute_command = false; -- Executar comando lado server/client.
            punishment = false; -- Permissão para banir.
            tphere = true; -- Permissão para teleportar player até você.
            tp = true; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = true; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player.
            setnick = true; -- Permissão para setar nick.
            setvida = true; -- Permissão para setar vida.
            setcolete = true; -- Permissão para setar colete.
            setweapons = true; -- Permissão para setar armas.
            setmoney = true; -- Permissão para setar dinheiro.
            setvehicle = true; -- Permissão para setar veículo.
            setdimension = true; -- Permissão para setar dimensão.
            setinterior = true; -- Permissão para setar interior.
            repair = true; -- Permissão para reparar veículo.
            destroy = true; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };

        ["Diretor"] = {
            start = false; -- Iniciar recurso.
            stop = false; -- Parar recurso.
            restart = false; -- Reiniciar recurso.
            weather = false; -- Setar clima.
            time = false; -- Setar hora.
            gamespeed = false; -- Setar velocidade do jogo.
            waveheight = false; -- Setar altura das ondas.
            fpslimit = false; -- Setar limite de FPS.
            gravitation = false; -- Setar gravidade.
            clear_chat = true; -- Limpar chat.
            on_going_maintenance = false; -- Colocar servidor em manutenção.
            set_password_automatic = false; -- Setar senha automaticamente.
            kick_all_players = false; -- Kickar todos os players.
            start_maintenance = false; -- Iniciar manutenção.
            reset_password = false; -- Resetar senha.
            set_password = false; -- Setar senha.
            set_gametype = false; -- Setar gametype.
            manage_acl = true; -- Gerenciar ACL.
            execute_command = false; -- Executar comando lado server/client.
            punishment = true; -- Permissão para banir.
            tphere = true; -- Permissão para teleportar player até você.
            tp = true; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = true; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player.
            setnick = true; -- Permissão para setar nick.
            setvida = true; -- Permissão para setar vida.
            setcolete = true; -- Permissão para setar colete.
            setweapons = true; -- Permissão para setar armas.
            setmoney = false; -- Permissão para setar dinheiro.
            setvehicle = true; -- Permissão para setar veículo.
            setdimension = true; -- Permissão para setar dimensão.
            setinterior = true; -- Permissão para setar interior.
            repair = true; -- Permissão para reparar veículo.
            destroy = true; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };

        
        ["Diretor-Geral-Adjunto"] = {
            start = false; -- Iniciar recurso.
            stop = false; -- Parar recurso.
            restart = false; -- Reiniciar recurso.
            weather = false; -- Setar clima.
            time = false; -- Setar hora.
            gamespeed = false; -- Setar velocidade do jogo.
            waveheight = false; -- Setar altura das ondas.
            fpslimit = false; -- Setar limite de FPS.
            gravitation = false; -- Setar gravidade.
            clear_chat = true; -- Limpar chat.
            on_going_maintenance = false; -- Colocar servidor em manutenção.
            set_password_automatic = false; -- Setar senha automaticamente.
            kick_all_players = false; -- Kickar todos os players.
            start_maintenance = false; -- Iniciar manutenção.
            reset_password = false; -- Resetar senha.
            set_password = false; -- Setar senha.
            set_gametype = false; -- Setar gametype.
            manage_acl = true; -- Gerenciar ACL.
            execute_command = false; -- Executar comando lado server/client.
            punishment = true; -- Permissão para banir.
            tphere = true; -- Permissão para teleportar player até você.
            tp = true; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = true; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player.
            setnick = true; -- Permissão para setar nick.
            setvida = true; -- Permissão para setar vida.
            setcolete = true; -- Permissão para setar colete.
            setweapons = true; -- Permissão para setar armas.
            setmoney = false; -- Permissão para setar dinheiro.
            setvehicle = true; -- Permissão para setar veículo.
            setdimension = true; -- Permissão para setar dimensão.
            setinterior = true; -- Permissão para setar interior.
            repair = true; -- Permissão para reparar veículo.
            destroy = true; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };

        ["Vice-diretor"] = {
            start = false; -- Iniciar recurso.
            stop = false; -- Parar recurso.
            restart = false; -- Reiniciar recurso.
            weather = false; -- Setar clima.
            time = false; -- Setar hora.
            gamespeed = false; -- Setar velocidade do jogo.
            waveheight = false; -- Setar altura das ondas.
            fpslimit = false; -- Setar limite de FPS.
            gravitation = false; -- Setar gravidade.
            clear_chat = true; -- Limpar chat.
            on_going_maintenance = false; -- Colocar servidor em manutenção.
            set_password_automatic = false; -- Setar senha automaticamente.
            kick_all_players = false; -- Kickar todos os players.
            start_maintenance = false; -- Iniciar manutenção.
            reset_password = false; -- Resetar senha.
            set_password = false; -- Setar senha.
            set_gametype = false; -- Setar gametype.
            manage_acl = false; -- Gerenciar ACL.
            execute_command = false; -- Executar comando lado server/client.
            punishment = true; -- Permissão para banir.
            tphere = true; -- Permissão para teleportar player até você.
            tp = true; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = true; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player.
            setnick = true; -- Permissão para setar nick.
            setvida = true; -- Permissão para setar vida.
            setcolete = true; -- Permissão para setar colete.
            setweapons = true; -- Permissão para setar armas.
            setmoney = false; -- Permissão para setar dinheiro.
            setvehicle = true; -- Permissão para setar veículo.
            setdimension = true; -- Permissão para setar dimensão.
            setinterior = true; -- Permissão para setar interior.
            repair = true; -- Permissão para reparar veículo.
            destroy = true; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };

        ["Gerência"] = {
            start = false; -- Iniciar recurso.
            stop = false; -- Parar recurso.
            restart = false; -- Reiniciar recurso.
            weather = false; -- Setar clima.
            time = false; -- Setar hora.
            gamespeed = false; -- Setar velocidade do jogo.
            waveheight = false; -- Setar altura das ondas.
            fpslimit = false; -- Setar limite de FPS.
            gravitation = false; -- Setar gravidade.
            clear_chat = true; -- Limpar chat.
            on_going_maintenance = false; -- Colocar servidor em manutenção.
            set_password_automatic = false; -- Setar senha automaticamente.
            kick_all_players = false; -- Kickar todos os players.
            start_maintenance = false; -- Iniciar manutenção.
            reset_password = false; -- Resetar senha.
            set_password = false; -- Setar senha.
            set_gametype = false; -- Setar gametype.
            manage_acl = false; -- Gerenciar ACL.
            execute_command = false; -- Executar comando lado server/client.
            punishment = false; -- Permissão para banir.
            tphere = true; -- Permissão para teleportar player até você.
            tp = true; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = true; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player.
            setnick = true; -- Permissão para setar nick.
            setvida = true; -- Permissão para setar vida.
            setcolete = true; -- Permissão para setar colete.
            setweapons = false; -- Permissão para setar armas.
            setmoney = false; -- Permissão para setar dinheiro.
            setvehicle = true; -- Permissão para setar veículo.
            setdimension = true; -- Permissão para setar dimensão.
            setinterior = true; -- Permissão para setar interior.
            repair = true; -- Permissão para reparar veículo.
            destroy = true; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };

        ["Superiores"] = {
            start = false; -- Iniciar recurso.
            stop = false; -- Parar recurso.
            restart = false; -- Reiniciar recurso.
            weather = false; -- Setar clima.
            time = false; -- Setar hora.
            gamespeed = false; -- Setar velocidade do jogo.
            waveheight = false; -- Setar altura das ondas.
            fpslimit = false; -- Setar limite de FPS.
            gravitation = false; -- Setar gravidade.
            clear_chat = true; -- Limpar chat.
            on_going_maintenance = false; -- Colocar servidor em manutenção.
            set_password_automatic = false; -- Setar senha automaticamente.
            kick_all_players = false; -- Kickar todos os players.
            start_maintenance = false; -- Iniciar manutenção.
            reset_password = false; -- Resetar senha.
            set_password = false; -- Setar senha.
            set_gametype = false; -- Setar gametype.
            manage_acl = false; -- Gerenciar ACL.
            execute_command = false; -- Executar comando lado server/client.
            punishment = false; -- Permissão para banir.
            tphere = true; -- Permissão para teleportar player até você.
            tp = true; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = true; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player.
            setnick = true; -- Permissão para setar nick.
            setvida = true; -- Permissão para setar vida.
            setcolete = true; -- Permissão para setar colete.
            setweapons = false; -- Permissão para setar armas.
            setmoney = false; -- Permissão para setar dinheiro.
            setvehicle = true; -- Permissão para setar veículo.
            setdimension = true; -- Permissão para setar dimensão.
            setinterior = true; -- Permissão para setar interior.
            repair = true; -- Permissão para reparar veículo.
            destroy = true; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };

        ["Moderador-geral"] = {
            start = false; -- Iniciar recurso.
            stop = false; -- Parar recurso.
            restart = false; -- Reiniciar recurso.
            weather = false; -- Setar clima.
            time = false; -- Setar hora.
            gamespeed = false; -- Setar velocidade do jogo.
            waveheight = false; -- Setar altura das ondas.
            fpslimit = false; -- Setar limite de FPS.
            gravitation = false; -- Setar gravidade.
            clear_chat = true; -- Limpar chat.
            on_going_maintenance = false; -- Colocar servidor em manutenção.
            set_password_automatic = false; -- Setar senha automaticamente.
            kick_all_players = false; -- Kickar todos os players.
            start_maintenance = false; -- Iniciar manutenção.
            reset_password = false; -- Resetar senha.
            set_password = false; -- Setar senha.
            set_gametype = false; -- Setar gametype.
            manage_acl = false; -- Gerenciar ACL.
            execute_command = false; -- Executar comando lado server/client.
            punishment = false; -- Permissão para banir.
            tphere = false; -- Permissão para teleportar player até você.
            tp = false; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = false; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player.
            setnick = false; -- Permissão para setar nick.
            setvida = false; -- Permissão para setar vida.
            setcolete = false; -- Permissão para setar colete.
            setweapons = false; -- Permissão para setar armas.
            setmoney = false; -- Permissão para setar dinheiro.
            setvehicle = false; -- Permissão para setar veículo.
            setdimension = false; -- Permissão para setar dimensão.
            setinterior = false; -- Permissão para setar interior.
            repair = false; -- Permissão para reparar veículo.
            destroy = false; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };

        ["Moderador"] = {
            start = false; -- Iniciar recurso.
            stop = false; -- Parar recurso.
            restart = false; -- Reiniciar recurso.
            weather = false; -- Setar clima.
            time = false; -- Setar hora.
            gamespeed = false; -- Setar velocidade do jogo.
            waveheight = false; -- Setar altura das ondas.
            fpslimit = false; -- Setar limite de FPS.
            gravitation = false; -- Setar gravidade.
            clear_chat = true; -- Limpar chat.
            on_going_maintenance = false; -- Colocar servidor em manutenção.
            set_password_automatic = false; -- Setar senha automaticamente.
            kick_all_players = false; -- Kickar todos os players.
            start_maintenance = false; -- Iniciar manutenção.
            reset_password = false; -- Resetar senha.
            set_password = false; -- Setar senha.
            set_gametype = false; -- Setar gametype.
            manage_acl = false; -- Gerenciar ACL.
            execute_command = false; -- Executar comando lado server/client.
            punishment = false; -- Permissão para banir.
            tphere = false; -- Permissão para teleportar player até você.
            tp = false; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = false; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player.
            setnick = false; -- Permissão para setar nick.
            setvida = false; -- Permissão para setar vida.
            setcolete = false; -- Permissão para setar colete.
            setweapons = false; -- Permissão para setar armas.
            setmoney = false; -- Permissão para setar dinheiro.
            setvehicle = false; -- Permissão para setar veículo.
            setdimension = false; -- Permissão para setar dimensão.
            setinterior = false; -- Permissão para setar interior.
            repair = false; -- Permissão para reparar veículo.
            destroy = false; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };
        
        ["Suporte"] = {
            start = false; -- Iniciar recurso.
            stop = false; -- Parar recurso.
            restart = false; -- Reiniciar recurso.
            weather = false; -- Setar clima.
            time = false; -- Setar hora.
            gamespeed = false; -- Setar velocidade do jogo.
            waveheight = false; -- Setar altura das ondas.
            fpslimit = false; -- Setar limite de FPS.
            gravitation = false; -- Setar gravidade.
            clear_chat = false; -- Limpar chat.
            on_going_maintenance = false; -- Colocar servidor em manutenção.
            set_password_automatic = false; -- Setar senha automaticamente.
            kick_all_players = false; -- Kickar todos os players.
            start_maintenance = false; -- Iniciar manutenção.
            reset_password = false; -- Resetar senha.
            set_password = false; -- Setar senha.
            set_gametype = false; -- Setar gametype.
            manage_acl = false; -- Gerenciar ACL.
            execute_command = false; -- Executar comando lado server/client.
            punishment = false; -- Permissão para banir.
            tphere = false; -- Permissão para teleportar player até você.
            tp = false; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = false; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player.
            setnick = false; -- Permissão para setar nick.
            setvida = false; -- Permissão para setar vida.
            setcolete = false; -- Permissão para setar colete.
            setweapons = false; -- Permissão para setar armas.
            setmoney = false; -- Permissão para setar dinheiro.
            setvehicle = false; -- Permissão para setar veículo.
            setdimension = false; -- Permissão para setar dimensão.
            setinterior = false; -- Permissão para setar interior.
            repair = false; -- Permissão para reparar veículo.
            destroy = false; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };

        ["Ajudante"] = {
            start = false; -- Iniciar recurso.
            stop = false; -- Parar recurso.
            restart = false; -- Reiniciar recurso.
            weather = false; -- Setar clima.
            time = false; -- Setar hora.
            gamespeed = false; -- Setar velocidade do jogo.
            waveheight = false; -- Setar altura das ondas.
            fpslimit = false; -- Setar limite de FPS.
            gravitation = false; -- Setar gravidade.
            clear_chat = false; -- Limpar chat.
            on_going_maintenance = false; -- Colocar servidor em manutenção.
            set_password_automatic = false; -- Setar senha automaticamente.
            kick_all_players = false; -- Kickar todos os players.
            start_maintenance = false; -- Iniciar manutenção.
            reset_password = false; -- Resetar senha.
            set_password = false; -- Setar senha.
            set_gametype = false; -- Setar gametype.
            manage_acl = false; -- Gerenciar ACL.
            execute_command = false; -- Executar comando lado server/client.
            punishment = false; -- Permissão para banir.
            tphere = false; -- Permissão para teleportar player até você.
            tp = false; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = false; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player.
            setnick = false; -- Permissão para setar nick.
            setvida = false; -- Permissão para setar vida.
            setcolete = false; -- Permissão para setar colete.
            setweapons = false; -- Permissão para setar armas.
            setmoney = false; -- Permissão para setar dinheiro.
            setvehicle = false; -- Permissão para setar veículo.
            setdimension = false; -- Permissão para setar dimensão.
            setinterior = false; -- Permissão para setar interior.
            repair = false; -- Permissão para reparar veículo.
            destroy = false; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };

        ["Estagiário"] = {
            start = false; -- Iniciar recurso.
            stop = false; -- Parar recurso.
            restart = false; -- Reiniciar recurso.
            weather = false; -- Setar clima.
            time = false; -- Setar hora.
            gamespeed = false; -- Setar velocidade do jogo.
            waveheight = false; -- Setar altura das ondas.
            fpslimit = false; -- Setar limite de FPS.
            gravitation = false; -- Setar gravidade.
            clear_chat = false; -- Limpar chat.
            on_going_maintenance = false; -- Colocar servidor em manutenção.
            set_password_automatic = false; -- Setar senha automaticamente.
            kick_all_players = false; -- Kickar todos os players.
            start_maintenance = false; -- Iniciar manutenção.
            reset_password = false; -- Resetar senha.
            set_password = false; -- Setar senha.
            set_gametype = false; -- Setar gametype.
            manage_acl = false; -- Gerenciar ACL.
            execute_command = false; -- Executar comando lado server/client.
            punishment = false; -- Permissão para banir.
            tphere = false; -- Permissão para teleportar player até você.
            tp = false; -- Permissão para teleportar até um player.
            kick = true; -- Permissão para kickar player.
            mute = false; -- Permissão para mutar player.
            resetaccount = false; -- Permissão para resetar a conta do player.
            setnick = false; -- Permissão para setar nick.
            setvida = false; -- Permissão para setar vida.
            setcolete = false; -- Permissão para setar colete.
            setweapons = false; -- Permissão para setar armas.
            setmoney = false; -- Permissão para setar dinheiro.
            setvehicle = false; -- Permissão para setar veículo.
            setdimension = false; -- Permissão para setar dimensão.
            setinterior = false; -- Permissão para setar interior.
            repair = false; -- Permissão para reparar veículo.
            destroy = false; -- Permissão para destruir veículo.
            spect = true; -- Permissão para espectar player.
        };
    };

    weatherTemp = {
        [0] = "Blue Sky, Sunny";
        [1] = "Blue Sky, Sunny";
        [2] = "Blue Sky, Clouds";
        [3] = "Blue Sky, Clouds";
        [4] = "Blue Sky, Clouds";
        [5] = "Blue Sky, Clouds";
        [6] = "Blue Sky, Clouds";
        [7] = "Blue Sky, Clouds";
        [8] = "Storming";
        [9] = "Cloudy and Foggy";
        [10] = "Clear Blue Sky";
        [11] = "Sunny, Scorching Hot";
        [12] = "Very Dull, Colourless, Hazy";
        [13] = "Very Dull, Colourless, Hazy";
        [14] = "Very Dull, Colourless, Hazy";
        [15] = "Very Dull, Colourless, Hazy";
        [16] = "Dull, Cloudy, Rainy";
        [17] = "Sunny, Scorching Hot";
        [18] = "Sunny, Scorching Hot";
        [19] = "Sandstorm";
    };

    weapons = { -- name, id, weaponID, quantity
        {"M4A1", 7, 4, 300};
        {"AK-47", 8, 1, 300};
        {"DEAGLE", 6, 2, 300};
    };

    punishment = {
        others = {
            command = "despunir";
            permissions = {"Console", "Creator", "Diretor-Geral", "Diretor", "Vice-diretor"};
        };

        prison = {
            pos = {1543.14734, -1353.29407, 329.47400, 999};
            pos_exit = {1579.22180, -1331.79199, 16.48438, 0};
        };

        reasons = {
            {
                name = "RDM";
                minutes = 240;
            };
    
            {
                name = "VDM";
                minutes = 150;
            };
    
            {
                name = "PG (Leve)";
                minutes = 120;
            };
            
            {
                name = "PG (Grave)";
                minutes = 240;
            };
            
            {
                name = "Meta-Gaming (Leve)";
                minutes = 120;
            };
    
            {
                name = "Meta-Gaming (Grave)";
                minutes = 200;
            };
    
            {
                name = "Combat-log";
                minutes = 240;
            };
            
            {
                name = "Revenge kill";
                minutes = 240;
            };

            {
                name = "Forçar RP";
                minutes = 60;
            };

            {
                name = "Dark RP";
                minutes = 1000;
            };

            {
                name = "Abuso de bugs";
                minutes = 1440;
            };

            {
                name = "OCC";
                minutes = 200;
            };

            {
                name = "Ofensa a jogador (1º vez)";
                minutes = 240;
            };

            {
                name = "Ofensa a jogador (2º vez)";
                minutes = 300;
            };

            {
                name = "Anti-VV";
                minutes = 250;
            };

            {
                name = "Area verde em geral";
                minutes = 180;
            };

            {
                name = "Regras poluição visual";
                minutes = 30;
            };
            
            {
                name = "Regras gerais leve";
                minutes = 120;
            };

            {
                name = "Regras gerais médio";
                minutes = 200;
            };

            {
                name = "má fé/marcação";
                minutes = 180;
            };
        };
    };

    logs = {
        log = true;
        web_hook = "https://discordapp.com/api/webhooks/1246891598583955487/_D4sAtqXWLqyqgtuOJrvFEB12ZNkXj6lh79sIGvVoZFPBWSEWlOLdHAD1T3wWP5rrN-P";
    };
}

function sendMessage (action, element, message, type)
    if action == "client" then
        return exports['guetto_notify']:showInfobox(type, message)
    elseif action == "server" then
        return exports['guetto_notify']:showInfobox(element, type, message)
    end
end