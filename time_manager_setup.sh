#!/bin/bash


. $HOME/.asdf/asdf.sh

# mix phx.new time_manager --no-html --no-webpack --binary-id

mix ecto.create

mix phx.gen.context TimeManagerContext User users username:string email:string
mix phx.gen.context TimeManagerContext Clock clocks time:naive_datetime status:boolean user:references:users
mix phx.gen.context TimeManagerContext WorkingTime workingtimes start:datetime end:datetime user:references:users

mix ecto.migrate

mix phx.gen.json TimeManagerContext User users username:string email:string:unique --no-context --no-schema
mix phx.gen.json TimeManagerContext Clock clocks time:naive_datetime status:boolean user:references:users --no-context --no-schema
mix phx.gen.json TimeManagerContext WorkingTime workingtimes start:naive_datetime end:naive_datetime user:references:users --no-context --no-schema

mix ecto.migrate
