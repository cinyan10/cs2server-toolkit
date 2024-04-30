# cs2server-toolkit
> test environment:
ubuntu 22.04
lastest LinuxGSM

## Requirements
jq (JSON processor), Install with:
```
sudo apt install jq
```

## Set Cronjobs
```
crontab -e
```
add
```
* */5 * * * /home/cs2server/cs2kz-updater.sh > /dev/null 2>&1
```
