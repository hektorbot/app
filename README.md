# Hektor frontend app

## How to deploy?

We use [shipit](https://github.com/shipitjs/shipit) as our deployment tool.
To start deploying the app, follow these steps:

1. Install [Yarn](https://yarnpkg.com/) if you haven't already

2. Install required Node modules:

```sh
# Should be run in the project's directory
yarn
```

3. Create a `.env` file based on `.env.example` and set the variables properly

```sh
cp .env.example .env
```

> NOTE: Be careful when setting these environment variables, they define where the app will be deployed on the server

4. Deploy to `dev` or `production`:

```sh
yarn deploy:prod # Deploy to production
yarn deploy:dev # Deploy to dev
```