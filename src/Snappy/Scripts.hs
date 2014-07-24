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
           FileLine {filePath = "/etc/loader.conf", lineText = "if_bwi_load=\"YES\"", comment = "# Enable Broadcom driver" }

{-|FreeBSD minimal desktop (see FreeBSD forums) -}
minimalDesktop = [
                  Port {category = "ports-mgmt", packageName = "portmaster"}
                 ]

script = [Some misc, Some compaqPresarioV6000, Some minimalDesktop]
