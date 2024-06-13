This is a bash script to checkout the repo, build, and deploy the app.

Inputs to the script:
 - GitHub Account Name.
 - Repo Name.
 - sudo password --> being read from an environment variable.

Steps:
 - Verify that the supplied account and repo names are valid.
 - Fetch or checkout the repo, into a tmp directory, to get the app (index.html).
 - Some details of the repo are displayed while fetching:
    - Latest version
    - Commits
 - Build the Docker image --> from an nginx image.
 - Some details were added/edited, to index.html, while building the image (version, build number, ... etc.).
 - Deploying a container, from the image, to run a local Docker host.

More Details:\
The script has used the following tools or packages:
 - GitHub API (gh)
 - jq
