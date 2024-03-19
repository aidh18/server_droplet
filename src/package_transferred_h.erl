%% @doc Handler for package and location services.
-module(package_transferred_h).

-export([init/2]).

-define(SERVER, 'logic@logic.aidanstacey.com').
-define(LOGIC, logic).

init(Req0, Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{location_id := Location_id, package_id := Package_id} = jsx:decode(Data),
	Result = erpc:call(?SERVER, ?LOGIC, transfer_package, [{Package_id, Location_id}]),
	        
	Encoded_message = jsx:encode(Result),
	Response = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/json">>
	}, Encoded_message, Req0),
	{ok, Response, Opts}.
