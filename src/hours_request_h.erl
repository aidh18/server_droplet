%% @doc Handler for package and location services.
-module(hours_request_h).

-export([init/2]).

-define(SERVER,'logic@logic.aidanstacey.com').
-define(LOGIC,logic).

init(Req0,Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	User_id = binary_to_list(Data),
	Result = erpc:cast(?SERVER,?LOGIC,request_hours_api,[binary_to_list(User_id)]),

	if
		is_map(Result)->
			Encoded_message = jsx:encode(Result),
			Response = cowboy_req:reply(200,#{
				<<"content-type">> => <<"text/json">>
			},Encoded_message,Req0),
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


