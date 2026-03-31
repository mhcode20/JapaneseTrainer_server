module.exports = {
  apps: [
    {
      name: "jp_server",
      script: "npm",
      args: "run dev",
      env: {
        NODE_ENV: "development",
      }
    }
  ]
};