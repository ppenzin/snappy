{-|Miscelaneous install scripts
   TODO move out of the project into dependent projects
 -}
module Snappy.Scripts where

import Snappy.Platform.FreeBSD
import Snappy.System
import Snappy

{-|Miscelanneous things for personal use -}
misc = [
        Some Port {category = "editors", packageName = "vim"},
        Some Port {category = "security", packageName = "sudo"},
        Some FileLine {filePath = "/etc/sysctl.conf", lineText = "hw.syscons.bell=0", comment = "# Disable system beep"}
       ]

{-|Compaq Presario V6000 drivers-}
compaqPresarioV6000 = [
                       broadcom
                      ]
broadcom = Port {category = "net", packageName = "bwi-firmware-kmod"}
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
           FileLine {filePath = "/etc/rc.conf", lineText = "ifconfig_wlan0=\"WPA DHCP\"", comment = "# Confgure wireless wia wpa_supplicant and DHCP" }

{-|FreeBSD minimal desktop (see FreeBSD forums) -}
minimalDesktop = [
                  Port {category = "ports-mgmt", packageName = "portmaster"}
                 ]

script = [Some misc, Some compaqPresarioV6000, Some minimalDesktop]
