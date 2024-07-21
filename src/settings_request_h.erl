%% @doc Handler for package and location services.
-module(settings_request_h).

-export([init/2]).

-define(SERVER,'logic@logic.aidanstacey.com').
-define(LOGIC,logic).

init(Req0,Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{<<"user_id">> := User_id} = jsx:decode(Data),
	Result = erpc:call(?SERVER,?LOGIC,request_settings_api,[binary_to_list(User_id)]),

	if
		is_list(Result) orelse is_map(Result)->
			Formatted_result = map_to_string:format(Result),
			Response = cowboy_req:reply(200,#{
				<<"content-type">> => <<"text/json">>
			},list_to_binary(Formatted_result),Req0),
			{ok,Response,Opts};
		Result =:= 500->
			Response = cowboy_req:reply(200,#{
				<<"content-type">> => <<"text/json">>
			},list_to_binary("500"),Req0),
			{ok,Response,Opts};
		true->
			Response = cowboy_req:reply(200,#{
				<<"content-type">> => <<"text/json">>
			},list_to_binary(Result),Req0),
			{ok,Response,Opts}
	end.
