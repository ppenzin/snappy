snappy
======

Intention: batch installation tool. As of now, support only FreeBSD

## Building and installing
```
cabal configure
cabal build
cabal install
```

### TODO
* Implement list shuffle
* Auto configuration for ports -- config is dune, need to disable the screen

### In testing
* Provide infix operator for dependency ordering
* Implement adding a line to a config file
* Implement creating (copying) a config file

## Minimal desktop example
Right now congifures [md][FreeBSD minimal
desktop] on Compaq Presario V6000.

Install the main library first. After that, to compile and run;
```
cd examples/PresarioV6000-MinDesktop && ghc Main.hs -o install
sudo ./install
```
Currently that does not take care of many configuration files. The files need
to be edited:

```
/etc/X11/xorg.conf
~/.xinitrc
~/.xsession
~/.config/openbox/autostart.sh
~/.config/openbox/rc.xml
~/.config/openbox/menu.xml
```
Make changes as described in [md][FreeBSD Minimal Desktop] and run
```
sudo ./install
```
again to set Nvidia XOrg configuration.


[md]:https://forums.freebsd.org/viewtopic.php?t=35308
