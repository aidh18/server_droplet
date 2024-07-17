%% @doc Handler for package and location services.
-module(settings_update_h).

-export([init/2]).

-define(SERVER,'logic@logic.aidanstacey.com').
-define(LOGIC,logic).

init(Req0,Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{<<"user_id">> := User_id,<<"setting_type">> := Setting_type,<<"setting">> := Setting} = jsx:decode(Data),
	Result = erpc:cast(?SERVER,?LOGIC,update_settings,[binary_to_list(User_id),binary_to_list(Setting_type),list_to_binary(Setting)]),

	Encoded_message = jsx:encode(Result),
	Response = cowboy_req:reply(200,#{
		<<"content-type">> => <<"text/json">>
	},Encoded_message,Req0),
	{ok,Response,Opts}.
