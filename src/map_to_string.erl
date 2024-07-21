-module(map_to_string).
-export([format/1,replace_char/3,filter_char/2]).



format(Start)->
    Zero = lists:flatten(io_lib:format("~p",[Start])),
    io:format("\n\n\n\nGetting item:"),
    io:format(Zero),
    io:format("\n\n\n\n"),
    One = filter_char(Zero,$\s),
    Two = filter_char(One,$=),
    Three = filter_char(Two,$#),
    Four = replace_char(Three,$,,$_),
    Five = replace_char(Four,123,$.),
    Six = replace_char(Five,$",$!),
    Seven = replace_char(Six,125,$,),
    Eight = replace_char(Seven,$>,$'),
    filter_char(Eight,$\n).


replace_char(String, Replace, New) ->
    lists:map(fun(Char) -> if Char =:= Replace -> New; true -> Char end end, String).

filter_char(String, Filter) ->
    lists:filter(fun(Char) -> Char =/= Filter end, String).
