%% @doc Handler for package and location services.
-module(location_request_h).

-export([init/2]).

-define(SERVER, 'logic@logic.aidanstacey.com').
-define(LOGIC, logic).

init(Req0, Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	Package_id = jsx:decode(Data),
	Result = erpc:call(?SERVER, ?LOGIC, request_location_api, [Package_id]),
	        
	Encoded_message = jsx:encode(Result),
	Response = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/json">>
	}, Encoded_message, Req0),
	{ok, Response, Opts}.
