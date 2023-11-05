# Basic setup information
keyboard us
rootpw --iscrypted $1$b2bDwXkz$ZpKi4Jx7tox779nrUdt8h1
timezone --isUtc --nontp UTC
selinux --permissive
firewall --disabled
#network --bootproto=dhcp --device=link --activate --onboot=on
network  --bootproto=dhcp --device=link --ipv6=no --activate --onboot=on
network  --bootproto=dhcp --device=eth1 --ipv6=no --activate --onboot=on
network  --hostname=rhel8-rti.teleflora.com
bootloader --disable
lang en_US
shutdown
eula --agreed
skipx

#users
rootpw --iscrypted $6$G/P1TGIsGMWZ9aak$Sm/HZ1fcdfdmTdy4k2BTMv9Sw.mQOhrgtvMD5e8oo7t3uCtX2T005e/afw46a6TkODKkP8b9SrUgSAnjKxxfi1
user --groups=wheel,rti --name=tfsupport --password=$6$G/P1TGIsGMWZ9aak$Sm/HZ1fcdfdmTdy4k2BTMv9Sw.mQOhrgtvMD5e8oo7t3uCtX2T005e/afw46a6TkODKkP8b9SrUgSAnjKxxfi1 --iscrypted --gecos="tfsupport"
user --groups=rti --name=odbc --password=$6$G/P1TGIsGMWZ9aak$Sm/HZ1fcdfdmTdy4k2BTMv9Sw.mQOhrgtvMD5e8oo7t3uCtX2T005e/afw46a6TkODKkP8b9SrUgSAnjKxxfi1 --iscrypted --gecos="odbc"
user --groups=rti --name=rti --password=$6$G/P1TGIsGMWZ9aak$Sm/HZ1fcdfdmTdy4k2BTMv9Sw.mQOhrgtvMD5e8oo7t3uCtX2T005e/afw46a6TkODKkP8b9SrUgSAnjKxxfi1 --iscrypted --gecos="rti"
user --groups=rti --name=delivery --password=$6$G/P1TGIsGMWZ9aak$Sm/HZ1fcdfdmTdy4k2BTMv9Sw.mQOhrgtvMD5e8oo7t3uCtX2T005e/afw46a6TkODKkP8b9SrUgSAnjKxxfi1 --iscrypted --gecos="delivery"

# Disk setup
zerombr
clearpart --all --initlabel
part / --asprimary --fstype="ext4" --size=80000

# Repos
url --url=http://rhel8repo.centralus.cloudapp.azure.com/rhel-8-for-x86_64-baseos/BaseOS
repo --name="AppStream" --install --baseurl=http://rhel8repo.centralus.cloudapp.azure.com/rhel-8-for-x86_64-appstream-rpms
repo --name="BaseOS" --install --baseurl=http://rhel8repo.centralus.cloudapp.azure.com/rhel-8-for-x86_64-baseos-rpms

# Package setup
%packages
@^minimal-environment
@system-tools
bash
aide
audispd-plugins
#libreswan
openscap
openscap-scanner
pcsc-lite
scap-security-guide
net-tools
java
perl
wget
mailx
procmail
bind-utils
ksh
expect
-firewalld
iptables
iptables-services
samba
cups
chrony
ntpstat
telnet
fetchmail
rsyslog
python2
rear
java
sed
lrzsz
ncurses-term
rsync
sendmail
kernel-modules
-python3-dasbus
%end

%addon org_fedora_oscap      
    content-type = scap-security-guide
    datastream-id = scap_org.open-scap_datastream_from_xccdf_ssg-rhel8-xccdf-1.2.xml
    xccdf-id = scap_org.open-scap_cref_ssg-rhel8-xccdf-1.2.xml
    profile = xccdf_org.ssgproject.content_profile_pci-dss
%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

%post
# update systemwide crypto policy
update-crypto-policies --set LEGACY
sed -i "s/enabled=1/enabled=0/g" /etc/yum/pluginconf.d/subscription-manager.conf

# container customizations inside the chroot
#rpm -e kernel

echo 'container' > /etc/dnf/vars/infra

#Generate installtime file record
/bin/date +%Y%m%d_%H%M > /etc/BUILDTIME

# Limit languages to help reduce size.
LANG="en_US:UTF-8"
echo "%_install_langs $LANG" > /etc/rpm/macros.image-language-conf

# systemd fixes
:> /etc/machine-id
umount /run
systemd-tmpfiles --create --boot
# mask mounts and login bits
#systemctl mask systemd-logind.service getty.target console-getty.service sys-fs-fuse-connections.mount systemd-remount-fs.service dev-hugepages.mount

# Remove things we don't need
rm -f /etc/udev/hwdb.bin
rm -rf /usr/lib/udev/hwdb.d/
rm -rf /boot
rm -rf /var/lib/dnf/history.*

rm /var/run/nologin

ln -s /usr/bin/sh /bin/sh

cd /bin
curl -O http://rhel8repo.centralus.cloudapp.azure.com/ostools-1.17/updateos updateos
chmod +x /bin/updateos
systemctl start sendmail
systemctl start smb
systemctl start cups
systemctl start iptables
systemctl start sshd
systemctl start rhsm
systemctl enable sendmail
systemctl enable rhsm
systemctl enable sshd
systemctl enable smb
systemctl enable cups
systemctl enable iptables
%end
