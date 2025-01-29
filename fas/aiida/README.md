# How to install AiiDA via Anaconda/Mambaforge

The easiest way is to use a MAMBA (a faster version of conda) environment.

### A tentative script

If you want, you can also copy paste this in a shell script, e.g. `install.sh` (remember to `chmod 744 install.sh`):

```console
#!/bin/bash

DB_PATH=$HOME/.aiida_db

mkdir $DB_PATH

echo 'export LANG=C' >> ~/.bashrc
echo 'export LC_ALL=C' >> ~/.bashrc
source ~/.bashrc

mamba create --name aiida python=3.9 pip aiida-core aiida-core.services
mamba activate aiida

echo "consumer_timeout = 360000000000" >> $CONDA_PREFIX/etc/rabbitmq/rabbitmq.conf
# The following might be needed if other RabbitMQ servers are running.
# This also requires to change the aiida config (usually `~/.aiida/config.json`) RabbitMQ port to the same configured in the following.
# echo "NODE_PORT=5673" >> $CONDA_PREFIX/etc/rabbitmq/rabbitmq-env.conf 


initdb -D $DB_PATH
# You can append the following `-o "-p 5434"` to change to db port from the
# default 5432 to 5434 (can be different, just here an example). 
# Note, this requires (as RabbitMQ) to adapt the port in the aiida config (usually `~/.aiida/config.json`).
pg_ctl start -D $DB_PATH -l logfile
# rabbitmqctl stop # to stop the RabbitMQ server
rabbitmq-server start -detached

verdi quicksetup
verdi daemon start
verdi config set warnings.rabbitmq_version False
```

## Known issues

At restart, you will need to restart the _services_ (i.e., RabbitMQ and PostreSQL). Use the following lines:

```bash
#!/bin/bash

# To use when the workstation have been restarted/shutdowned

# AiiDA restart
DB_PATH=$HOME/.aiida_db
eval "$(conda shell.bash hook)"
conda activate aiida
pg_ctl start -D $DB_PATH -l logfile
rabbitmq-server start -detached
verdi daemon start
```

Note that you can place these lines in a conda activation script, so that you don't have to do it manually.