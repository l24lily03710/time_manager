# Time Manager

Time Manager est une application Elixir/Phoenix pour gérer les horaires de travail, les utilisateurs et les horloges.

## Configuration requise

- [Elixir](https://elixir-lang.org/) (version 1.15.7)
- [Phoenix](https://www.phoenixframework.org/) (version 1.5.3)
- [PostgreSQL](https://www.postgresql.org/) (version X.X.X)

## Lancement du backend

1. Clonez ce dépôt sur votre machine locale :

```shell
git clone https://github.com/votre-utilisateur/time-manager.git
```

2. rendez vous dans /api/ :

```shell
cd /api
```

3. Créez l'image docker :

```shell
docker-compose build
```


4. Lancez l'image docker :

```shell
docker-compose up
```

5. L'api est disponible à cette adresse avec un reverse proxy nginx :

```shell
http://localhost:8000
```

## Lancement du front-end

1. Clonez ce dépôt sur votre machine locale :

```shell
git clone https://github.com/votre-utilisateur/time-manager.git
```

2. rendez vous dans /front/time_manager_front :

```shell
cd /front/time_manager_front/
```

3. Créez l'image docker :

```shell
docker build -t vuejs/time_manager_front .
```


4. Lancez l'image docker :

```shell
docker run -it -p 8080:8080 --rm --name time_manager_front_1 vuejs/time_manager_front
```

5. Le front est disponible à cette adresse :

```shell
http://127.0.0.1:8080/
```