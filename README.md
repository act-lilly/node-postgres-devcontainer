# node-postgres-devcontainer
A template for creating a devcontainer that includes your app, postgres db and pgadmin. This devcontainer is meant for development environment only. It enables you to replicate your deployment in a development environment with minimal effort.

This template can be used 'as is' are revised to your needs.

# About the devcontainer
The default app is node.js and uses the image `node:latest`, as you will see if you review `Dockerfile.dev`, which defines the primary application's environment.

The `devcontainer.json` file also includes details specific to a node.js app, but this can be adjusted as needed using the  `updateContentCommand`, `postCreateCommand` and `postAttachCommand` attributes of the file.

In the `docker-compose.yml` file, you may want to adjust which postgres and pgadmin images are used.

* PostgreSQL image: 
    * `postgres:17.2:latest`
* pgAdmin image:
    * `dpage/pgadmin4:latest`

The `sql` directory has sample files for working with your database. Adjust to your needs and update `docker-compose.yml` accordingly.

sql directory files:
1. `schema.sql`
2. `seed.sql`
3. `functions.sql`

These files will get executed in this order when the devcontainer is built.

The `dev.env` and `servers.json` files can be used with no adjustment. These are simply for setting up basic values for a development environment. If you adjust the values in one, you'll want to ensure the value is adjusted in the other file, if it exists in both places.

# About Codespace Secrets and Variables
If you need to pass secrets or variables to your Codespace, follow these steps.

1. Go to your GitHub account settings by clicking on your profile picture in the top-right corner and selecting "Settings"
2. In the left sidebar, scroll down and click on "Codespaces"
3. Under the "Codespaces secrets" section, click on "New secret"
4. In the form that appears:
   * Enter a name for your secret (e.g., MY_API_KEY)
   * Enter the value of your secret
   * Under "Repository access", you can:
      * Select "All repositories" to make the secret available in all repositories
      * Select "Selected repositories" and choose specific repositories where this secret should be available
5. Click "Add secret" to save

# References

## GitHub documentation
1. [Codespaces - Setting up your project - Introduction to dev containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers)