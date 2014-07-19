{-|Miscelaneous install scripts
   TODO move out of the project into dependent projects
 -}
module Snappy.Scripts where

import Snappy.Platform.FreeBSD

{-|Miscelanneous things for personal use -}
misc = [
        Port {category = "editors", packageName = "vim"},
        Port {category = "security", packageName = "sudo"}
       ]

{-|Compaq Presario V6000 drivers-}
compaqPresarioV6000 = []

{-|FreeBSD minimal desktop (see FreeBSD forums) -}
minimalDesktop = [
                  Port {category = "ports-mgmt", packageName = "portmaster"}
                 ]

script = [misc, compaqPresarioV6000, minimalDesktop]
