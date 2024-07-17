%% @doc Handler for package and location services.
-module(employees_add_h).

-export([init/2]).

-define(SERVER,'logic@logic.aidanstacey.com').
-define(LOGIC,logic).

init(Req0,Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	#{<<"employer_id">> := Employer_id,<<"employee_id">> := Employee_id} = jsx:decode(Data),
	Result = erpc:cast(?SERVER,?LOGIC,add_employees_api,[binary_to_list(Employer_id),binary_to_list(Employee_id)]),

	Encoded_message = jsx:encode(Result),
	Response = cowboy_req:reply(200,#{
		<<"content-type">> => <<"text/json">>
	},Encoded_message,Req0),
	{ok,Response,Opts}.
