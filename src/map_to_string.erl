-module(map_to_string).
-export([format_map/1,format_inner_map/1]).


format_map(Map) ->
    OuterPairs = maps:fold(fun(Key, InnerMap, Acc) ->
                                  InnerString = format_inner_map(InnerMap),
                                  OuterString = io_lib:format("\"~s\"!~s", [Key, InnerString]),
                                  Acc ++ [OuterString]
                              end, [], Map),
    OuterString = string:join(OuterPairs, "|"),
    lists:flatten(OuterString).

format_inner_map(InnerMap) ->
    InnerPairs = maps:fold(fun(Key, Value, Acc) ->
                                  InnerString = io_lib:format("\"~s\"?\"~s\"", [Key, Value]),
                                  Acc ++ [InnerString]
                              end, [], InnerMap),
    string:join(InnerPairs, "+").

