%%%-------------------------------------------------------------------
%% @doc db_access public API
%% @end
%%%-------------------------------------------------------------------

-module(server_droplet_app).

-behaviour(application).

-export([start/2,stop/1]).

start(_Type,_Args) ->
	Dispatch = cowboy_router:compile([
	    {'_',[
		%{"/",cowboy_static,{priv_file,db_access,"static/index.html"}},
			{"/",toppage_h,[]},
			{"/employees_add",employees_add_h,[]},
			{"/hours_request",hours_request_h,[]},
			{"/hours_update",hours_update_h,[]},
			{"/login_request",login_request_h,[]},
			{"/login_update",login_update_h,[]},
			{"/name_request",name_request_h,[]},
			{"/name_update",name_update_h,[]},
			{"/settings_request",settings_request_h,[]},
			{"/settings_update",settings_update_h,[]}
	    ]}
	]),

	PrivDir = code:priv_dir(server_droplet),
	%tls stands for transport layer security
        {ok,_} = cowboy:start_tls(https_listener,[
                  		{port,443},
						{certfile,PrivDir ++ "/ssl/fullchain.pem"},
						{keyfile,PrivDir ++ "/ssl/privkey.pem"}
              			],#{env => #{dispatch => Dispatch}}),
	server_droplet_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
