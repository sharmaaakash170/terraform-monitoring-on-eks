const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function(app) {
  app.use(
    '/api',
    createProxyMiddleware({
      target: 'http://a0e72b77a635a46df8cabe892b6d65bd-477770728.us-east-1.elb.amazonaws.com:8000',
      changeOrigin: true,
      pathRewrite: {
        '^/api': '',
      },
    })
  );
};