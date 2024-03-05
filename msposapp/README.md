msposapp
--------
msposapp manages containers that are full linux installs with the RTI POS system installed and configured.
it can manage multiple vpns from each container to a different home location.

03/05/2024  3:45 PM - 2.6
┏━━━━━━━━
┃ @ Mike's Store
┃ )~ Containers
┃━
┃ Shopcode : 12122121
┃ Status   :  Up 8 hours
┃
┃-Containers
┃ 1. Status
┃ 2. Start/Stop
┃ 3. Connect
┃
┃-VPNs
┃ 4. Status
┃ 5. Start/Stop
┃ 6. Create
┃ 7. Delete
┃
┃-System
┃ s. Shopcode
┃ i. Install
┃ p. Purge
┃ r. Readme
┃ x. Exit
┗━
Enter selection: 

Status area (grey)-
- Shopcode
current set shop identifier is displayed in the status area at the top of the menu.

- Status
if the current set shop identifier has a running container, it will display how long it has been up.

Containers -
- Status
displays the detailed status info for all running containers (shops) on the server.

- Start/Stop
if the current shop identifier has a container running, it stops it. if not, it starts one.
if the current shop identifier has a tfrsync.pl cloud backup on this server, it will ask if you want to restore data from it.

- Connect
connects to the current shop identifier's container.

VPNs -
- Status
displays detailed status of all VPNs running on the current shop identifiers container.

- Start/Stop
if the currennt shop identifier's vpn service is not running, it starts it. if it is, it stops it.

- Create
adds a VPN to a remote location. (must stop/start VPNs after.)

- Delete
removes a VPN connection from the current shop identifier's container. (must stop/start VPNs after.)

System -
- Shopcode
Allows you to set the current working shop identifier.

- Install
Installs the required packages and make needed config changes for msposapp if not already done.
Ask for a shop identifier and name, if not already set.
Build/rebuild the rhe8-rti base image every time its ran.
Check for OS updates every time it is ran, after the initial installation.

- Purge
Stops all containers, wipes all container images, all podman cache, and any shop-specific, or image data. (clean slate.)

- Exit
Previous menu.

---
mgreen@teleflora.com
