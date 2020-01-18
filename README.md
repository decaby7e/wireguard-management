# Wireguard Management Scripts
## Issues
 - Client configuration generation is broken
     - echo with entire config string is busted
     - PrivateKey does not get populated in client config
 - PostUp and PostDown in server do not take into account different interface names
 - ipv4_forwarding is not enabled on server by scripts (feature or issue?)