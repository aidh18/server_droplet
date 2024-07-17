%% @doc Handler for package and location services.
-module(login_request_h).

-export([init/2]).

-define(SERVER,'logic@logic.aidanstacey.com').
-define(LOGIC,logic).

init(Req0,Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{<<"username">> := Username,<<"password">> := Password} = jsx:decode(Data),
	Result = erpc:call(?SERVER,?LOGIC,request_login_api,[binary_to_list(Username),binary_to_list(Password)]),
	io:format(Result),

	if
		is_list(Result)->
			Response = cowboy_req:reply(200,#{
				<<"content-type">> => <<"text/json">>
			},list_to_binary(Result),Req0),
			{ok,Response,Opts};
		Result =:= 500->
			Response = cowboy_req:reply(200,#{
				<<"content-type">> => <<"text/json">>
			},list_to_binary("500"),Req0),
			{ok,Response,Opts};
		true->
			Response = cowboy_req:reply(200,#{
				<<"content-type">> => <<"text/json">>
			},list_to_binary("Invalid"),Req0),
			{ok,Response,Opts}
	end.


