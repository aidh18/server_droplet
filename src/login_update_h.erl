%% @doc Handler for package and location services.
-module(login_update_h).

-export([init/2]).

-define(SERVER,'logic@logic.aidanstacey.com').
-define(LOGIC,logic).

init(Req0,Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{<<"username">> := New_username,<<"password">> := New_password} = jsx:decode(Data),
	Result = erpc:cast(?SERVER,?LOGIC,update_login,[{binary_to_list(New_username),binary_to_list(New_password)}]),

	Encoded_message = jsx:encode(Result),
	Response = cowboy_req:reply(200,#{
		<<"content-type">> => <<"text/json">>
	},Encoded_message,Req0),
	{ok,Response,Opts}.
