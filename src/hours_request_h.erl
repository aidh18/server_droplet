%% @doc Handler for package and location services.
-module(hours_request_h).

-export([init/2,create_map/2,is_employer/1,format_result/2]).

-define(SERVER,'logic@logic.aidanstacey.com').
-define(LOGIC,logic).

init(Req0,Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{<<"is_employer">> := Employer,<<"user_id">> := User_id} = jsx:decode(Data),
	Is_employer = is_employer(Employer),
	Result = erpc:call(?SERVER,?LOGIC,request_hours_api,[Employer,binary_to_list(User_id)]),

	if
		is_list(Result) orelse is_map(Result)->
			Formatted_result = format_result(Result,Employer),
			Response = cowboy_req:reply(200,#{
				<<"content-type">> => <<"text/json">>
			},list_to_binary(Formatted_result),Req0),
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

format_result(Result,true)->
	Result_map = create_map(Result,#{}),
	map_to_string:format(Result_map);
format_result(Result,false)->
	Result_map = create_map(Result,#{}),
	map_to_string:format(Result_map).

create_map(Result,_) when is_map(Result)->
	Result;
create_map([],Map)->
	Map;
create_map([[Employee_id,Hours] | Rest],Map)->
	New_map = maps:put(Employee_id,Hours,Map),
	create_map(Rest,New_map);
create_map(Single,Map)->
	[Employee_id,Hours] = Single,
	maps:put(Employee_id,Hours,Map).

is_employer(Employer)->
	case Employer of
		1-> true;
		0-> false;
		_-> false
	end.