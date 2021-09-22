MSCloudServer
-------------

General Improvements from last version -

- Support incrementals.
- Storage of backup data in much cheaper cold storage disk space.
- Support for Azure backend.
- Much faster rsync completion times. This helps prevent corrupt files by running a backup while the system is being used.
- Ability to bring up a backup set in the form of a running POS system.
- Switch VPN support to a "road warrior" type, allowing for the remote public IP to be anything.
- Can have this app run for each user on a linux system. Creating support for multiple customers on 1 server.
- 


TODO -

- during install, check for guac running before asking if install guac.
- change guac url ip reference (auto detect).
- auto versioning; mscloudserver
              rti
              daisy
              ostools
              OS
- 
