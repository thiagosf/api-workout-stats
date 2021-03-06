/**
 * Documentation: http://docs.azk.io/Azkfile.js
 */
// Adds the systems that shape your system
systems({
  'train-more-api': {
    // Dependent systems
    depends: [],
    // More images:  http://images.azk.io
    image: {"docker": "azukiapp/ruby"},
    // Steps to execute before running instances
    provision: [
      "bundle install --path /azk/bundler",
    ],
    workdir: "/azk/#{manifest.dir}",
    shell: "/bin/bash",
    command: ["bundle", "exec", "rackup", "config.ru", "--pid", "/tmp/ruby.pid", "--port", "$HTTP_PORT", "--host", "0.0.0.0"],
    wait: 20,
    mounts: {
      '/azk/#{manifest.dir}': sync("."),
      '/azk/#{manifest.dir}/db': path("./db"),
      '/azk/bundler': persistent("./bundler"),
      '/azk/#{manifest.dir}/tmp': persistent("./tmp"),
      '/azk/#{manifest.dir}/log': path("./log"),
      '/azk/#{manifest.dir}/.bundle': path("./.bundle"),
    },
    scalable: {"default": 1},
    http: {
      domains: [ "#{system.name}.#{azk.default_domain}" ]
    },
    ports: {
      // exports global variables
      http: "3000/tcp",
    },
    envs: {
      // Make sure that the PORT value is the same as the one
      // in ports/http below, and that it's also the same
      // if you're setting it in a .env file
      RUBY_ENV: "development",
      BUNDLE_APP_CONFIG: "/azk/bundler",
    },
  },
});
