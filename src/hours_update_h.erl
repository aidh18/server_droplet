%% @doc Handler for package and location services.
-module(hours_update_h).

-export([init/2,create_json/2]).

-define(SERVER,'logic@logic.aidanstacey.com').
-define(LOGIC,logic).

init(Req0,Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{<<"user_id">> := User_id,<<"date">> := Date,<<"hours">> := Hours} = jsx:decode(Data),
	Result = erpc:cast(?SERVER,?LOGIC,update_hours_api,[binary_to_list(User_id),binary_to_list(Date),Hours]),

	Encoded_message = jsx:encode(Result),
	Response = cowboy_req:reply(200,#{
		<<"content-type">> => <<"text/json">>
	},Encoded_message,Req0),
	{ok,Response,Opts}.

create_json([],Json)->
	Json;
create_json([[Employee_id, Hours] | Rest], Json)->
	New_json = maps:put(Employee_id, Hours, Json),
    create_json(Rest, New_json).