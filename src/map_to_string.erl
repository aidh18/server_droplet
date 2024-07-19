-module(map_to_string).
-export([format/1,replace_char/3,filter_char/2]).



format(Start)->
    Zero = lists:flatten(io_lib:format("~p",[Start])),
    One = filter_char(Zero,$\s),
    Two = filter_char(One,$=),
    Three = filter_char(Two,$#),
    Four = replace_char(Three,$,,$_),
    Five = replace_char(Four,123,$.),
    Six = replace_char(Five,$",$!),
    Seven = replace_char(Six,125,$,),
    Eight = replace_char(Seven,$>,$'),
    Eight.


replace_char(String, Replace, New) ->
    lists:map(fun(Char) -> if Char =:= Replace -> New; true -> Char end end, String).

filter_char(String, Filter) ->
    lists:filter(fun(Char) -> Char =/= Filter end, String).
