%% @doc Handler for package and location services.
-module(name_update_h).

-export([init/2]).

-define(SERVER,'logic@logic.aidanstacey.com').
-define(LOGIC,logic).

init(Req0,Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{<<"user_id">> := User_id,<<"name">> := Name} = jsx:decode(Data),
	Result = erpc:cast(?SERVER,?LOGIC,update_name_api,[binary_to_list(User_id),binary_to_list(Name)]),

	Encoded_message = jsx:encode(Result),
	Response = cowboy_req:reply(200,#{
		<<"content-type">> => <<"text/json">>
	},Encoded_message,Req0),
	{ok,Response,Opts}.