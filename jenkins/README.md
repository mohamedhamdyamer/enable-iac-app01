This is a Jenkins pipeline to checkout the repo, build, and deploy the app.

Inputs:
 - Jenkinsfile.
 - Credentials --> managed and stored on the Jenkins server.

Steps:
 - Checkout the repo --> automatically done by Jenkins.
 - Editing "index.html" and replacing some details (version, build number, ... etc.).
 - Build the Docker image --> from nginx:stable.
 - Deploying a container, from the image, to run a local Docker host.

More Details:
 - Jenkins Plugins used:
    - sh
    - echo
    - contentReplace
    - sshPut
    - sshCommand
 - The Jenkins setup has included:
    - Jenkins server
    - Three agents
 - The pipeline has used all three agents to run! It has three stages. Each stage runs on a different agent.
 - The Jenkins server and the three agents have been deployed as Docker containers.
 - A shared volume, on the Docker host, has also been provided to the agents. This way, each agent can read the files changed by the other ones.
