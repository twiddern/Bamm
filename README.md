# BAMM! - The Bash micro monitoring
## Alpha(!)
* server monitoring
* easy to hack
* lightweight
* xmpp alerts

## Installation

```
sudo apt-get update; sudo apt-get upgrade;
sudo apt-get install -y sendxmpp screen
git clone https://github.com/coacx/bamm.git
```

## Configuration
* './hosts.conf' Host and port configuration
* './xmpp.conf' XMPP credentials

## Usage
```
/usr/bin/screen -dmS Bamm bash monitoring.sh
screen -x Bamm
```

## Todo
* (!) daemonize (start-stop-daemon, no screen required) 
* (!) install script (system wide)
* startup options, e.g. check intervall
* alerting: support multiple recipients
* udp support (hosts.conf: 'udp:www.example.org 179')
* ...

Pull request are welcome :-)

## About
* Inspiriert by [kanla](http://kanla.zekjur.net/)
* [sendxmpp](http://sendxmpp.hostname.sk/)
* [GNU Screen](https://www.gnu.org/software/screen/)

