 FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client

# Create app directory and copy the Elixir projects into it.
RUN mkdir -p /app/time_manager
WORKDIR /app/time_manager
COPY . /app/time_manager
COPY entrypoint.sh /app/time_manager/entrypoint.sh
# Install Hex package manager.
# By using `--force`, we don’t need to type “Y” to confirm the installation.
RUN mix local.hex --force

# Compile the project.
RUN mix do compile
SHELL ["/bin/bash", "-c"]
RUN chmod +x /app/time_manager/entrypoint.sh

CMD ["/app/time_manager/entrypoint.sh"]


