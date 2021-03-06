# docker-webtrees
[webtrees](http://www.webtrees.net) is a free open source web-based genealogy application intended for collaborative use.
It is compatible with standard 5.5.1-GEDCOM files. In this docker image based on phusion webtrees is provided. A database is not embedded in this image.

## Usage

```
docker run -d -p 8088:8079 --name webtrees --link mysql:db -v /webtrees/data:/var/www/html/data -v /webtrees/media:/var/www/html/media  -e GROUP_ID=999 -e PORT=8079 --restart always dtjs48jkt/webtrees
```

After starting the docker container go to:

https://server or https://server:port if you have defined an alternative port

## Update Functionality
This docker image is based on Ubuntu. On each start of the container an update of the used Ubuntu packages could be performed. Due to the running update it might take a little longer until the application webtrees is available. This auto-update functionality has (now) to be activated explicitely (-e UPDATE_ON_START=TRUE).

## Persistent storage of data
Configuration and media files should be stored outside the container. Therefor you should create two directories that are mapped to the container internal directories /var/www/html/data and /var/www/html/media.
In the container apache is running under user www-data [33] (group www-data[33]). Both directories must therfore be read- and writable for this user. If this is not possible you can use the alternative and use the parameter GROUP_ID to inform the container about the group that has read and write access to those folders.

## Database
The image does not contain a MySQL database. Instead you have to use a separate MySQL instance. For example you could use the [MySQL Docker Image](https://store.docker.com/images/mysql). Using the --link parameter a direct connection to the database in an other container could be established.
If you use the --link parameter it is sufficient to set as database hostname db and port 3306. This can be set during the initial setup in the wizard or directly in the file config.ini.php (in data directory /var/www/html/data). The database user must have all access rights to create the necessary database and tables.

## Logging
Log data of the contained web-server is written in the files in the folder /var/log/apache2/. If access to those files is necessary this location could be mapped to an external volume.

## Port of Apache web server / Encryption
This image only supports https based communication. Per default the Apache web server listens on port 443.
If it is necessary to change the default port (e.g. in case of collisions) you can set the optional parameter PORT to a different value.
The https communication is based on a self signed certificate. It is possible to use an alternative certificate. Therfore you have to map the internal folder /crt to an external location. This folder should contain the two files webtrees.key (Key without password protection) und webtrees.crt (certificate). It is not possible to change further encryption settings from outside the container.
If you want a more sofisticated encryption you should use a reverse proxy in front of the webtrees container.

## Usage of additional 3rd party modules
It is possible to use additional 3rd party modules of webtrees with this container. To use such modules it is necessary to mount those folders containing the module into the following location -v /var/www/html/modulesv3/<modulexxx>

## Parameters
* `-v /var/www/html/data` - Where webtrees server stores its config files
* `-v /var/www/html/media` - Where webtrees server stores its media files
* `-v /etc/localtime` - Set to use the correct time of host 
* `-e GROUP_ID` - allow access to mapped volumes
* `-e PORT` - change port web server listens on
* `-e UPDATE_ON_START` - if set to TRUE the auto-update functionality on restart is activated
* `-e ENABLE_REMOTE_USER` - if set to TRUE use REMOTE_USER for authentication

## Versions
+ **2017/10/13:** Initial release. webtrees 1.7.9
+ **2018/06/27:** Webtrees 1.7.9 - Added switch to active/deactive auto update functionality
+ **2018/08/30:** Webtrees 1.7.10 - Now using baseimage Ubuntu 18.04 / Added possibility to use external authentication using REMOTE_USER
+ **2019/01/13:** Webtrees 1.7.12
+ **2019/05/08:** Webtrees 1.7.14
