# Appwrite Lite
Lite is a single container version of Appwrite with minimum must-have features.

The name is not final and will be chosen via voting at the [Appwrite](https://github.com/appwrite) organization.

# Contents

This container incorporates the services Appwrite requires to run:
- Redis
- Swoole
- MariaDB
- InfluxDB

It also removes other services:
- ClamAV
- Traefik

Those are not *requried* to make Appwrite run, but may be useful in a more resource-rich installation.