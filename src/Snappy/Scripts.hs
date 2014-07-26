{-|Miscelaneous install scripts
   TODO move out of the project into dependent projects
 -}
module Snappy.Scripts where

import Snappy.Platform.FreeBSD
import Snappy.System
import Snappy

{-|Miscelanneous things for personal use -}
misc = [
        Some port {category = "editors", packageName = "vim"},
        Some port {category = "security", packageName = "sudo"},
        Some FileLine {filePath = "/etc/sysctl.conf", lineText = "hw.syscons.bell=0", comment = "# Disable system beep"}
       ]

{-|Compaq Presario V6000 drivers-}
compaqPresarioV6000 = [
                       broadcom
                      ]
broadcom = port {category = "net", packageName = "bwi-firmware-kmod"}
           ~>
           FileLine {filePath = "/boot/loader.conf", lineText = "if_bwi_load=\"YES\"", comment = "# Enable Broadcom driver" }
           ~>
           FileLine {filePath = "/boot/loader.conf", lineText = "wlan_wep_load=\"YES\"", comment = "# WEP wireless module" }
           ~>
           FileLine {filePath = "/boot/loader.conf", lineText = "wlan_ccmp_load=\"YES\"", comment = "# CCMP wireless module" }
           ~>
           FileLine {filePath = "/boot/loader.conf", lineText = "wlan_tkip_load=\"YES\"", comment = "# TKIP wireless module" }
           ~>
           FileLine {filePath = "/etc/rc.conf", lineText = "wlans_bwi0=\"wlan0\"", comment = "# Network interface for Broadcom driver" }
           ~>
           FileLine {filePath = "/etc/rc.conf", lineText = "ifconfig_wlan0=\"WPA DHCP\"", comment = "# Confgure wireless via wpa_supplicant and DHCP" }

{-|FreeBSD minimal desktop (see FreeBSD forums) -}
minimalDesktop = [Some portmaster, Some xStuff]
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
                withOpts = ["MOUSE", "KEYBOARD", "VESA"],
                withoutOpts = ["ACECAD", "APM", "ARK", "ATI", "CHIPS", "CYRIX", "DUMMY", "ELOGRAPHICS", "FBDEV", "GLINT", "HYPERPEN", "I128", "I740", "INTEL", "JOYSTICK", "MACH64", "MAGICTOUCH", "MGA", "MUTOUCH", "NEOMAGIC", "NEWPORT", "NV", "OPENCHROME", "PENMOUNT", "R128", "RENDITION", "S3", "S3VIRGE", "SAVAGE", "SILICONMOTION", "SIS", "SYNAPTICS", "TDFX", "TGA", "TRIDENT", "TSENG", "VMMOUSE", "VMWARE", "VOID", "VOODOO", "WACOM"]
              }

script = [Some misc, Some compaqPresarioV6000, Some minimalDesktop]
