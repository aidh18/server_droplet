%% @doc Handler for package and location services.
-module(location_update_h).

-export([init/2]).

-define(SERVER, 'logic@logic.aidanstacey.com').
-define(LOGIC, logic).

init(Req0, Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{<<"location_id">> := Location_id, <<"lat">> := Lat, <<"long">> := Long} = jsx:decode(Data),
	Result = erpc:cast(?SERVER, ?LOGIC, update_location_api, [{binary_to_list(Location_id),{Lat,Long}}]),
	        
	Encoded_message = jsx:encode(Result),
	Response = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/json">>
	}, Encoded_message, Req0),
	{ok, Response, Opts}.
