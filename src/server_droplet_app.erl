%%%-------------------------------------------------------------------
%% @doc db_access public API
%% @end
%%%-------------------------------------------------------------------

-module(server_droplet_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
	    {'_', [
		%{"/", cowboy_static, {priv_file, db_access, "static/index.html"}},
			{"/", toppage_h, []},
			{"/package_transferred",package_transferred_h,[]},
			{"/delivered",delivered_h,[]},
			{"/location_request",location_request_h,[]},
			{"/location_update",location_update_h,[]}
	    ]}
	]),

	PrivDir = code:priv_dir(server_droplet),
	%tls stands for transport layer security
        {ok,_} = cowboy:start_tls(https_listener, [
                  		{port, 443},
						{certfile, PrivDir ++ "/ssl/fullchain.pem"},
						{keyfile, PrivDir ++ "/ssl/privkey.pem"}
              			], #{env => #{dispatch => Dispatch}}),
	server_droplet_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
