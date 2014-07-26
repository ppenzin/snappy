{-|Miscelaneous install scripts
   TODO move out of the project into dependent projects
 -}
module Snappy.Scripts where

import Data.Char
import Snappy.Platform.FreeBSD
import Snappy.System
import Snappy

{-|Miscelanneous things for personal use -}
misc = [
        Some port {category = "editors", packageName = "vim"},
        Some port {category = "security", packageName = "sudo"},
        Some FileLine {
                        filePath = "/etc/sysctl.conf",
                        lineText = "hw.syscons.bell=0",
                        comment = "# Disable system beep"
                      }
       ]

{-|Compaq Presario V6000 drivers-}
compaqPresarioV6000 = [
                       broadcom
                      ]
broadcom = port {category = "net", packageName = "bwi-firmware-kmod"}
           ~>
           FileLine {
                      filePath = "/boot/loader.conf",
                      lineText = "if_bwi_load=\"YES\"",
                      comment = "# Enable Broadcom driver"
                    }
           ~>
           FileLine {filePath = "/boot/loader.conf", lineText = "wlan_wep_load=\"YES\"", comment = "# WEP wireless module" }
           ~>
           FileLine {filePath = "/boot/loader.conf", lineText = "wlan_ccmp_load=\"YES\"", comment = "# CCMP wireless module" }
           ~>
           FileLine {filePath = "/boot/loader.conf", lineText = "wlan_tkip_load=\"YES\"", comment = "# TKIP wireless module" }
           ~>
           FileLine {filePath = "/etc/rc.conf", lineText = "wlans_bwi0=\"wlan0\"", comment = "# Network interface for Broadcom driver" }
           ~>
           FileLine {
                      filePath = "/etc/rc.conf",
                      lineText = "ifconfig_wlan0=\"WPA DHCP\"",
                      comment ="# Confgure wireless via wpa_supplicant and DHCP"
                    }

{-|FreeBSD minimal desktop (see FreeBSD forums) -}
 -- TODO add no HAL and no LINUX to global opts
minimalDesktop = [Some portmaster, Some xStuff, Some mouse]
mouse = FileLine {
                   filePath = "/etc/rc.conf",
                   lineText = "moused_enable=\"YES\"",
                   comment = "# Mouse support"
                 }

portmaster = port {category = "ports-mgmt", packageName = "portmaster"}
             ~>
             File {
                    path = "/usr/local/etc/portmaster.rc",
                    sourcePath = "portmaster.rc.file"
                  }

xStuff = port {
                category = "x11-servers",
                packageName = "xorg-server",
                withOpts = ["DEVD"],
                withoutOpts = ["HAL"]
              }
         ~>
         port {
                category = "x11-drivers",
                packageName = "xorg-drivers",
                withOpts = ["MOUSE", "KEYBOARD"],
                withoutOpts = ["ACECAD", "APM", "ARK", "ATI", "CHIPS", "CYRIX", "DUMMY", "ELOGRAPHICS", "FBDEV", "GLINT", "HYPERPEN", "I128", "I740", "INTEL", "JOYSTICK", "MACH64", "MAGICTOUCH", "MGA", "MUTOUCH", "NEOMAGIC", "NEWPORT", "NV", "OPENCHROME", "PENMOUNT", "R128", "RENDITION", "S3", "S3VIRGE", "SAVAGE", "SILICONMOTION", "SIS", "SYNAPTICS", "TDFX", "TGA", "TRIDENT", "TSENG", "VESA", "VMMOUSE", "VMWARE", "VOID", "VOODOO", "WACOM"]
              }
         ~>
         port {
                category = "x11",
                packageName = "xinit"
              }
         ~>
         port {
                category = "x11",
                packageName = "xauth"
              }
         ~>
         port {
                category = "x11-fonts",
                packageName = "xorg-fonts"
              }
         ~>
         port {
                category = "x11-fonts",
                packageName = "webfonts"
              }
         ~>
         Conditional {
                       condition = promptNvidia,
                       subject = nvDriver
                     }
         ~>
         GeneratedFile {
                         genFilePath = "/root/xorg.conf.new",
                         genFileCmd = "Xorg",
                         genFileCmdOpts = ["-configure"]
                       }
         {- TODO here I edited xorg.conf by hand, need Augeas support --
         ~>
         File {
                sourcePath = "/root/xorg.conf.new",
                path = "/etc/X11/xorg.conf"
              }
         -}
         ~>
         Conditional {
                       condition = (isPresent nvDriver),
                       subject = nvXConf
                     }
         ~>
         openBox

nvDriver = port {
                  category = "x11",
                  packageName = "nvidia-driver",
                  withoutOpts = ["LINUX"]
                }

nvXConf = port {
                 category = "x11",
                 packageName = "nvidia-xconfig",
                 withoutOpts = ["LINUX"]
               }
          ~>
          command { cmd = "nvidia-xconfig" }
          ~>
          FileLine {
                     filePath = "/boot/loader.conf",
                     lineText = "nvidia_load=\"YES\"",
                     comment ="# Enable NVIDIA "
                   }

openBox = port {
                 category = "x11-wm",
                 packageName = "openbox"
               }

script = [Some misc, Some compaqPresarioV6000, Some minimalDesktop]

{-| Ask if the user wants NVIDIA drivers -}
promptNvidia :: IO Bool
promptNvidia = putStrLn "Do you want to install NVIDIA driver? (y/n)"
            >> getLine
           >>= (\str -> case str of 
                "y" -> return True
                "n" -> return False
                _  -> (putStrLn("Invalid input") >> promptNvidia))
                . (map toLower)

nvidia = port {
                category = "x11",
                packageName = "nvidia-xconfig"
              }
