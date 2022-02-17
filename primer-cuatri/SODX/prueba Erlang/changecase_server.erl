-module(changecase_server).
-export([start/0, loop/0]). %declaracion de las 2 funciones que va a tener, el /x indica la cantidad de argumentos que va a tener la función

start() ->
    spawn(changecase_server, loop, []). %con el spawn creamos u nuevo proceso
    
loop() ->
    receive
        % pattern matching
        {Client, {Str, uppercase}} -> %sender, para cualquier mensaje que reciba ( Str )
            Client ! {self(), string:to_upper(Str)}; %I want to replay to this Client, the I indicate the process ID
        {Client, {Str, lowercase}} ->
            Client ! {self(), string:to_lower(Str)} %client es respondido con esto
    end,
    loop(). %asi cuando acabe volvemos a llamar al loop
