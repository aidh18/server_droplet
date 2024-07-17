%% @doc Handler for package and location services.
-module(hours_update_h).

-export([init/2]).

-define(SERVER,'logic@logic.aidanstacey.com').
-define(LOGIC,logic).

init(Req0,Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{<<"user_id">> := User_id,<<"date">> := Date,<<"hours">> := Hours} = jsx:decode(Data),
	Result = erpc:cast(?SERVER,?LOGIC,update_hours_api,[binary_to_term(User_id),binary_to_term(Date),binary_to_term(Hours)]),

	Encoded_message = jsx:encode(Result),
	Response = cowboy_req:reply(200,#{
		<<"content-type">> => <<"text/json">>
	},Encoded_message,Req0),
	{ok,Response,Opts}.
