# time_manager_front

## Project setup
```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```

### Lints and fixes files
```
npm run lint
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).



docker build -t vuejs/time_manager_front .


docker run -it -p 8080:8080 --rm --name time_manager_front_1 vuejs/time_manager_front http-server -p 8080 --cors