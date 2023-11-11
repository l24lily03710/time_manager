module.exports = {
  devServer: {
    proxy: {
      '/api': {
        target: 'http://localhost:8000', // Your NGINX server
        changeOrigin: true,
        pathRewrite: {
          '^/api': '/api', // If your Phoenix app's API routes have a base path of '/api'
        },
      },
    },
  },
};
