#!/bin/bash

docker build -t phoenix-backend2:latest ./api/

helm install backend-helm ./backend_helm_chart