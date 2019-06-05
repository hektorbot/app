require("dotenv").config();
const consola = require("consola");
const program = require("commander");
const path = require("path");

const errors = [];
const { DEPLOY_PATH, DEPLOY_HOST } = process.env;
if (!DEPLOY_HOST) {
  errors.push(new Error("DEPLOY_HOST must be defined"));
}
if (!DEPLOY_PATH) {
  errors.push(new Error("DEPLOY_PATH must be defined"));
}
if (errors.length) {
  errors.forEach(consola.error);
  process.exit();
}

program
  .option("-r, --revision <rev>", "Branch, commit or tag", "master")
  .parse(process.argv);

module.exports = shipit => {
  require("shipit-deploy")(shipit);

  shipit.initConfig({
    default: {
      branch: program.revision,
      repositoryUrl: "https://github.com/hektorbot/app.git",
      servers: DEPLOY_HOST
    },
    prod: {
      deployTo: path.join(DEPLOY_PATH, "production")
    },
    dev: {
      deployTo: path.join(DEPLOY_PATH, "dev")
    }
  });

  shipit.on("updated", () => {
    shipit.remote(`
      cd ${shipit.releasePath};
      ${[".env", "unicorn.rb", "config.ru"]
        .map(file => `ln -s ${path.join(shipit.config.deployTo, file)}`)
        .join(";")}
      bundler install;
      sudo systemctl restart frontend-${shipit.environment}.service;
      `);
  });
};
