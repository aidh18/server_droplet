%% @doc Handler for package and location services.
-module(location_request_h).

-export([init/2]).

-define(SERVER, 'logic@logic.aidanstacey.com').
-define(LOGIC, logic).

init(Req0, Opts) ->
	io:format(Req0),
	io:format(Req0),
	io:format(Req0),
	io:format(Req0),
	io:format(Req0),
	io:format(Req0),
	io:format(Req0),
	io:format(Req0),
	io:format(Req0),
	io:format(Req0),
	io:format(Req0),
	io:format(Req0),
	{ok,Data,_} = cowboy_req:read_body(Req0),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	io:format(Data),
	Package_id = binary_to_list(Data),
	io:format(Package_id),
	io:format(Package_id),
	io:format(Package_id),
	io:format(Package_id),
	io:format(Package_id),
	io:format(Package_id),
	io:format(Package_id),
	io:format(Package_id),
	io:format(Package_id),
	io:format(Package_id),
	io:format(Package_id),
	io:format(Package_id),
	io:format(Package_id),
	io:format(Package_id),
	Result = erpc:call(?SERVER, ?LOGIC, request_location_api, [Package_id]),

	Encoded_message = jsx:encode(Result),
	Response = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/json">>
	}, Encoded_message, Req0),
	{ok, Response, Opts}.
