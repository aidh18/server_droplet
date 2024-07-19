%% @doc Handler for package and location services.
-module(hours_request_h).

-export([init/2,create_map/2,is_employer/1]).

-define(SERVER,'logic@logic.aidanstacey.com').
-define(LOGIC,logic).

init(Req0,Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{<<"is_employer">> := Employer,<<"user_id">> := User_id} = jsx:decode(Data),
	Is_employer = is_employer(Employer),
	Result = erpc:call(?SERVER,?LOGIC,request_hours_api,[Is_employer,binary_to_list(User_id)]),

	if
		is_list(Result) orelse is_map(Result)->
			Result_map = create_map(Result,#{}),
			Result_string = map_to_string:format_map(maps:to_list(Result_map)),
			Response = cowboy_req:reply(200,#{
				<<"content-type">> => <<"text/json">>
			},list_to_binary(Result_string),Req0),
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

create_map(Result,_) when is_map(Result)->
	Result;
create_map([],Map)->
	Map;
create_map([[Employee_id, Hours] | Rest], Map)->
	New_map = maps:put(Employee_id, Hours, Map),
	create_map(Rest, New_map).

is_employer(Employer)->
	case Employer of
		"true"-> true;
		"false"-> false;
		_-> false
	end.
