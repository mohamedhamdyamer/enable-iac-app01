This is an Ansible playbook to checkout the repo, build, and deploy the app.

Inputs to the playbook:
 - Vault password file

Steps:
 - Verify that the supplied repo URL is valid.
 - Fetch the repo and downloading "index.html" into a tmp location.
 - Build the Docker image --> from nginx:stable.
 - Some details were added, to "index.html", while building the image (version, build number, ... etc.).
 - Deploying a container, from the image, to run a local Docker host.

More Details:
 - Ansible Modues used:
    - ansible.builtin.uri
    - ansible.builtin.get_url
    - ansible.builtin.replace
    - community.docker.docker_image
    - community.docker.docker_container
 - Ansible inventory has been used with "host_vars" directory.
 - Ansible Vault has been used to encrypt the sudo password.
