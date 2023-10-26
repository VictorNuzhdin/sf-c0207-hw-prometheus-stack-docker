#!/bin/bash

## DISABLE Zabbix Stack
#
##--1 :: Stop/Disable Zabbix Agent
sudo systemctl stop zabbix-agent
sudo systemctl disable zabbix-agent
#
##      Synchronizing state of zabbix-agent.service with SysV service script with /lib/systemd/systemd-sysv-install.
##      Executing: /lib/systemd/systemd-sysv-install disable zabbix-agent
##      Removed /etc/systemd/system/multi-user.target.wants/zabbix-agent.service.
#
systemctl status zabbix-agent
#
##      ○ zabbix-agent.service - Zabbix Agent
##        Loaded: loaded (/lib/systemd/system/zabbix-agent.service; disabled; vendor preset: enabled)
##        Active: inactive (dead)                                   ^^^^^^^^
##                ^^^^^^^^
#

##--2 :: Stop/Disable Zabbix Service
sudo systemctl stop zabbix-server
sudo systemctl disable zabbix-server
#
##      Synchronizing state of zabbix-server.service with SysV service script with /lib/systemd/systemd-sysv-install.
##      Executing: /lib/systemd/systemd-sysv-install disable zabbix-server
##      Removed /etc/systemd/system/multi-user.target.wants/zabbix-server.service.
#
systemctl status zabbix-server
#
##      ○ zabbix-server.service - Zabbix Server
##        Loaded: loaded (/lib/systemd/system/zabbix-server.service; disabled; vendor preset: enabled)
##        Active: inactive (dead)                                    ^^^^^^^^
##                ^^^^^^^^
#

##--3 :: Stop/Disable MySQL Service
sudo systemctl stop mysql
sudo systemctl disable mysql
#
##      Synchronizing state of mysql.service with SysV service script with /lib/systemd/systemd-sysv-install.
##      Executing: /lib/systemd/systemd-sysv-install disable mysql
##      Removed /etc/systemd/system/multi-user.target.wants/mysql.service.
#
systemctl status mysql
#
##      ○ mysql.service - MySQL Community Server
##        Loaded: loaded (/lib/systemd/system/mysql.service; disabled; vendor preset: enabled)
##        Active: inactive (dead)                            ^^^^^^^^
##                ^^^^^^^^
#

##--4 :: Reboot Host and Checkout
#sudo reboot
curl -s https://srv.dotspace.ru/zabbix/zabbix.php?action=dashboard.view

