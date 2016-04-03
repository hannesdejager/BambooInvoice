# BambooInvoice in Docker

I've forked [Derek Allard's](https://github.com/derekallard/BambooInvoice) BambooInvoice that helped me so hugely when I started out freelancing and dockerized it 


## Running the database container

The official mysql container won't work with bambooinvoice out of the box. You have to remove `ONLY_FULL_GROUP_BY` from the SQL mode e.g. 

```
docker run -d --name bamboo-db \
	-e MYSQL_ROOT_PASSWORD=yourpass \
	-e MYSQL_USER=bambooinvoice \
	-e MYSQL_PASSWORD=bambooinvoice \
	-e MYSQL_DATABASE=bambooinvoice \
	mysql:latest \
	--sql-mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
```	

## Running the web container

The Dockerfile packaged with this project contains an `ONBUILD` instruction that requires 3 bamboo configuration files. So start with your own Dockerfile based of the contained one:

```
  1 FROM hdejager/bambooinvoice
  2 MAINTAINER Hannes de Jager <hannes.de.jager@gmail.com>
  3 
  4 COPY php.ini-development /usr/local/etc/php/php.ini
```

and place as siblings in the directory:

- config.php
- database.php
- email.php

Start by copying the ones in `/web/bamboo_system_files/application/config/` and modify for your environment.

Build: `docker build -t mybambooinvoice .`

and run while making sure to set the `BASE_URL`:

```
docker run -d --name ia-bamboo-web -e BASE_URL='http://192.168.99.100/' -p 80:80 --link ia-bamboo-db:db mybambooinvoice
```

## Notes

### Example email.php for gmail

```
$config['protocol'] = 'smtp';
$config['smtp_host'] = 'ssl://smtp.gmail.com';
$config['smtp_user'] = 'you@gmail.com';
$config['smtp_pass'] = 'yourpassword';
$config['smtp_port'] = '465';
$config['newline'] = "\r\n"; // This is what makes it work with GMAIL
```