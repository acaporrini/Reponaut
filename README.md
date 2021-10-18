# Reponaut
A web app that uses the GitHub Api and the Octokit gem to search for repos by name

## Installation

### Generate an access token
To make this app work you will need a Github access token with `public_repo` permissions.
Please follow [this guide](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) to generate one.
### Docker

#### Clone the repo
```bash
  git clone git@github.com:acaporrini/Reponaut.git
```

#### Enter the project folder
```bash
  cd Reponaut
```
#### Build Docker image
```bash
  docker build -t [TAG_NAME] .
```
#### Run Docker container
```bash
  docker run -p 3000:3000 -e GITHUB_TOKEN=[your github token]  [TAG_NAME]
```

#### Run Tests

```bash
  docker run [TAG_NAME] bundle exec rspec
```

### Run locally without Docker

#### Clone the repo
```bash
  git clone git@github.com:acaporrini/Reponaut.git
```

#### Enter the project folder
```bash
  cd Reponaut
```
#### Install Dependecies
```bash
  bundle install
```
#### Setup ENV variables
Copy the ***.env.manifest*** file to ***.env*** and replace the GitHub Token with the generated one.

#### Run
```bash
  bundle exec rackup -p 3000
```

#### Run Tests

```bash
  bundle exec rspec
```

#### Navigate the app
The app can be reached at the url:

```
  http://localhost:3000/repos/search
```
#### Open a console
```bash
  chmod +x bin/console
  bin/console
```
