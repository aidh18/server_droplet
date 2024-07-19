-module(map_to_string).
-export([format_map/1,format_inner_map/1,format_simple_map/1]).


format_map(Map) ->
    OuterPairs = maps:fold(fun(Key,InnerMap,Acc) ->
                                  InnerString = format_inner_map(InnerMap),
                                  OuterString = io_lib:format("\"~p\"!~p",[Key,InnerString]),
                                  Acc ++ [OuterString]
                              end,[],Map),
    OuterString = string:join(OuterPairs,"|"),
    lists:flatten(OuterString).

format_inner_map(InnerMap) ->
    InnerPairs = maps:fold(fun(Key,Value,Acc) ->
                                  InnerString = io_lib:format("\"~p\"?\"~p\"",[Key,Value]),
                                  Acc ++ [InnerString]
                              end,[],InnerMap),
    string:join(InnerPairs,"+").

format_simple_map(Map) ->
    Pairs = maps:fold(fun(Key,Value,Acc) ->
                                String = io_lib:format("\"~p\"!\"~p\"",[Key,Value]),
                                Acc ++ [String]
                            end,[],Map),
    ResultString = string:join(Pairs,"|"),
    lists:flatten(ResultString).

