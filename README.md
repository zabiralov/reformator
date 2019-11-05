reformator.pl
-------------

Perl script for reformat systemd unit files (or other ini-like) data.

Requirements:
```
* perl >= 5.10
```

See `reformator --help`

Usage:

`reformator < example.service`


Example before reformator:

```
[Unit]
Description=Elasticsearch
Documentation=http://www.elastic.co
Wants=network-online.target
After=network-online.target

[Service]
Type=notify
RuntimeDirectory=elasticsearch
PrivateTmp=true
Environment=ES_HOME=/usr/share/elasticsearch
Environment=ES_PATH_CONF=/etc/elasticsearch
Environment=PID_DIR=/var/run/elasticsearch
Environment=ES_SD_NOTIFY=true
EnvironmentFile=-/etc/sysconfig/elasticsearch

WorkingDirectory=/usr/share/elasticsearch

User=elasticsearch
Group=elasticsearch

ExecStart=/usr/share/elasticsearch/bin/elasticsearch -p ${PID_DIR}/elasticsearch.pid --quiet

# StandardOutput is configured to redirect to journalctl since
# some error messages may be logged in standard output before
# elasticsearch logging system is initialized. Elasticsearch
# stores its logs in /var/log/elasticsearch and does not use
# journalctl by default. If you also want to enable journalctl
# logging, you can simply remove the "quiet" option from ExecStart.
StandardOutput=journal
StandardError=inherit

# Specifies the maximum file descriptor number that can be opened by this process
LimitNOFILE=65535

# Specifies the maximum number of processes
LimitNPROC=4096

# Specifies the maximum size of virtual memory
LimitAS=infinity

# Specifies the maximum file size
LimitFSIZE=infinity

# Disable timeout logic and wait until process is stopped
TimeoutStopSec=0

# SIGTERM signal is used to stop the Java process
KillSignal=SIGTERM

# Send the signal only to the JVM rather than its control group
KillMode=process

# Java process is never killed
SendSIGKILL=no

# When a JVM receives a SIGTERM signal it exits with code 143
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target

# Built for packages-7.4.2 (packages)

```

Example after reformator:

```
#

[Unit]
Description        = Elasticsearch
Documentation      = http://www.elastic.co
Wants              = network-online.target
After              = network-online.target

[Service]
Type               = notify
RuntimeDirectory   = elasticsearch
PrivateTmp         = true
Environment        = ES_HOME=/usr/share/elasticsearch
Environment        = ES_PATH_CONF=/etc/elasticsearch
Environment        = PID_DIR=/var/run/elasticsearch
Environment        = ES_SD_NOTIFY=true
EnvironmentFile    =-/etc/sysconfig/elasticsearch
WorkingDirectory   = /usr/share/elasticsearch
User               = elasticsearch
Group              = elasticsearch
ExecStart          = /usr/share/elasticsearch/bin/elasticsearch -p ${PID_DIR}/elasticsearch.pid --quiet
StandardOutput     = journal
StandardError      = inherit
LimitNOFILE        = 65535
LimitNPROC         = 4096
LimitAS            = infinity
LimitFSIZE         = infinity
TimeoutStopSec     = 0
KillSignal         = SIGTERM
KillMode           = process
SendSIGKILL        = no
SuccessExitStatus  = 143

[Install]
WantedBy           = multi-user.target

```
