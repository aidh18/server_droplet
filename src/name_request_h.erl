%% @doc Handler for package and location services.
-module(name_request_h).

-export([init/2]).

-define(SERVER,'logic@logic.aidanstacey.com').
-define(LOGIC,logic).

init(Req0,Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{<<"user_id">> := User_id} = jsx:decode(Data),
	Result = erpc:call(?SERVER,?LOGIC,request_name_api,[binary_to_term(User_id)]),

	if
		is_list(Result)->
			Response = cowboy_req:reply(200,#{
				<<"content-type">> => <<"text/json">>
			},term_to_binary(Result),Req0),
			{ok,Response,Opts};
		Result =:= 500->
			Response = cowboy_req:reply(200,#{
				<<"content-type">> => <<"text/json">>
			},term_to_binary("500"),Req0),
			{ok,Response,Opts};
		true->
			Response = cowboy_req:reply(200,#{
				<<"content-type">> => <<"text/json">>
			},term_to_binary("Invalid"),Req0),
			{ok,Response,Opts}
	end.

