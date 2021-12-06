vpccidrip          = "10.0.0.0/16"
albsubnetcidrip1a  = "10.0.1.0/24"
albsubnetcidrip1b  = "10.0.2.0/24"
websubnetcidrip1a  = "10.0.3.0/24"
websubnetcidrip1b  = "10.0.4.0/24"
appsubnetcidrip1a  = "10.0.5.0/24"
appsubnetcidrip1b  = "10.0.6.0/24"
dbsubnetcidrip1a   = "10.0.7.0/24"
dbsubnetcidrip1b   = "10.0.8.0/24"
bastionserverports = [22]
albsgports         = [80, 443]
webservergports    = [80, 443]
appervergports     = [8080]
dbservergports     = [3306]
egressports        = [0]

