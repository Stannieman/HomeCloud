# Components
For each component there is a directory that contains the *Dockerfile* and all scripts\
and other files required to build and run the component.

## Building the components
Each component has a *build<area>.sh* script that should be used to build the *Docker* image:\
`sudo ./build.sh`\
For simplicity the images are not published to a registry and there is no versioning.

To get an image on the host OS just checkout this *Git* repository there and build the required components from scratch.\
Updating a component is done in the same way.

## Running the components
Create a directory for the component in */docker*\
and place the *docker-compose.yml* file in it.\
Change any environment variables like passwords if needed.

Next stop all running containers:\
`sudo docker stop $(sudo docker ps -q)`

Finally start all components again usign the *start<area>.sh* script:\
`sudo ~/start.sh`\
This will recursively find all *docker-compose.yml* files in */docker* and start them.\
Enter the storage password when asked.