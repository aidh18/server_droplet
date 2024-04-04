%% @doc Handler for package and location services.
-module(location_request_h).

-export([init/2]).

-define(SERVER, 'logic@logic.aidanstacey.com').
-define(LOGIC, logic).

init(Req0, Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	Package_id = binary_to_list(Data),
	Result = erpc:call(?SERVER, ?LOGIC, request_location_api, [Package_id]),

	if
		is_tuple(Result)->
			{Lat,Long} = Result,
			Json = #{<<"lat">>=> Lat, <<"long">>=> Long},
			Encoded_message = jsx:encode(Json),
			Response = cowboy_req:reply(200, #{
				<<"content-type">> => <<"text/json">>
			}, Encoded_message, Req0),
			{ok, Response, Opts};
		Result =:= 500->
			Response = cowboy_req:reply(200, #{
				<<"content-type">> => <<"text/json">>
			}, list_to_binary("500"), Req0),
			{ok, Response, Opts};
		true->
			Response = cowboy_req:reply(200, #{
				<<"content-type">> => <<"text/json">>
			}, list_to_binary(Result), Req0),
			{ok, Response, Opts}
	end.


