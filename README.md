snappy
======

Batch install tool. As of now it is aiming at installing
FreeBSD minimal desktop on Copmaq Presario V6000

To compile and run;
```
cd src && ghc Main.hs -o install
sudo ./install
```

### TODO
* Implement list shuffle
* Auto configuration for ports -- config is dune, need to disable the screen

### In testing
* Provide infix operator for dependency ordering
* Implement adding a line to a config file
* Implement creating (copying) a config file
