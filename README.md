Learning docker and docker compose during 42 school

We had to create a website using home made docker images.
We had to create 3 containers that will be connected together with docker compose :
  - One nginx container, which was the only container allowed to communicate with the host
  - One Wordpress container, it was connecter to nginx and to the backend container
  - One mariadb container, connected only to Wordpress container

The Wordpress and mariadb files are stored locally to be sure the changes on the website stays.
