# Components
For each component there is a directory that contains a few scripts and required config files.

## Installing and configuring a component
A component is installed by running its install script:  
`sudo ./HomeCloud/Component/install.sh`  
It will install all required packages and copy a template config file called *Component.hcconfig* to the */ComponentConfigs* directory.

After the installation is completed you can make changes to the config file.

## Removing a component
A component can be disabled by simply removing the installed config file or changing its file extension.

## Updating a component
All component packages are updated using apt.  
This will happen during weekly maintenance ([Host/Weekly maintenance.md](<./Host/Weekly maintenance.md>)).

## Running a component
To run a single component run its start script:  
`sudo ./HomeCloud/Component/start.sh`

Stopping it can be done with its stop script:  
`sudo ./HomeCloud/Component/stop.sh`

The main start script will start all installed components automatically.