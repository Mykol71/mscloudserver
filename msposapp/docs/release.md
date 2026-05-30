Release Documentation
---------------------

This document describes how to prepare, validate, package, and publish an msposapp release. Use it for application menu/script releases as well as release candidates for customer deployment.

Release Scope
-------------

Each release should identify:

- Version number.
- Release owner.
- Target date.
- Supported operating system images: `centos7`, `rhel8`, and `rocky9`.
- POS type: `rti`.
- Impacted scripts, docs, kickstart files, Dockerfiles, and packaged assets.
- Any customer or shopcode-specific deployment notes.

Current Version
---------------

The application menu version is set in `MENU`:

```
TFCLOUD_VERSION="2.6"
```

Update this value when cutting a new release. The same version should be used in release notes, tags, and deployment communication.

Pre-Release Checklist
---------------------

Before packaging a release:

1. Review all changed files.

```
git status --short
git diff --stat
```

2. Confirm the version in `MENU` is correct.
3. Review user-facing documentation under `docs/`.
4. Confirm required release files are present:

```
MENU
README.md
bin/install
bin/create-image
bin/stage-image
bin/restore_data
bin/start_vpn
bin/stop_vpn
bin/create_vpn
bin/delete_vpn
bin/pipework
bin/centos7-rti.ks
bin/centos7-rti-dockerfile
bin/rhel7-rti.ks
bin/rhel7-rti-dockerfile
bin/rhel8-rti.ks
bin/rhel8-rti-dockerfile
bin/rocky9-rti.ks
bin/rocky9-rti-dockerfile
bin/istar.rpm
bin/istar.ppd
```

5. Check shell syntax for the release scripts.

```
bash -n MENU
find bin -maxdepth 1 -type f -perm -111 -exec bash -n {} \;
```

6. Confirm the release package does not contain customer runtime files, secrets, or generated state:

```
bin/.shopcode
bin/.*.container
bin/.*.ipsec.conf
bin/.*.ipsec.secrets
/backups/*
/var/tmp/containers/*
/var/tmp/*-rti-docker.tar.xz
```

Build Validation
----------------

Validate the release on a disposable build host before deploying to a customer environment.

1. Install required packages and configuration.

```
cd msposapp/bin
sudo ./install
```

2. Select the target OS version when prompted.
3. Build the base image.

```
sudo ./create-image
```

4. Verify the image exists.

```
podman image ls
```

Expected image names:

```
centos7-rti
rhel8-rti
rocky9-rti
```

5. Stage a test shopcode.

```
sudo ./stage-image
```

6. Confirm the container starts and reports a healthy status.

```
sudo ./container_status
podman exec <container_id> hostname -I
```

Functional Validation
---------------------

Run the following checks before release acceptance:

- Open `MENU` and confirm the version displayed at the top.
- Set or verify the working shopcode.
- Start and stop a test container.
- Connect to the staged container.
- Restore data from a non-production backup, when backup restore changed.
- Create, start, list, stop, and delete a test VPN using non-production credentials, when VPN scripts changed.
- Confirm `strongswan` configuration is copied into the container when VPNs are started.
- Confirm receipt printer driver assets are still packaged when printer support is required.
- Run `prune-docker` only on a disposable test host.

Release Notes Template
----------------------

Use this template for each release.

```
Version:
Release date:
Release owner:

Summary:

Changes:
- 

Compatibility:
- Supported OS images:
- Supported POS type:
- Required host packages:

Install or upgrade notes:
- 

Validation completed:
- Shell syntax:
- Base image build:
- Stage test:
- VPN test:
- Restore test:

Known issues:
- 

Rollback plan:
- 

Approval:
- 
```

Packaging
---------

Package only source-controlled release content and documentation. Do not include generated container images, customer backups, local hidden state, VPN secrets, or shopcode-specific files.

Recommended package contents:

```
MENU
README.md
docs/
bin/
pics/
```

After packaging, record:

- Release version.
- Source commit or tag.
- Package filename.
- Package checksum.
- Release notes location.
- Validation evidence location.

Tagging
-------

Create a tag that matches the menu version.

```
git tag -a v2.6 -m "msposapp 2.6"
git push origin v2.6
```

Use a patch version when the same menu version needs multiple maintenance releases, for example `v2.6.1`.

Deployment Checklist
--------------------

For each deployment:

1. Confirm the customer maintenance window.
2. Confirm the current shopcode and environment name.
3. Confirm a current backup exists before changing the running instance.
4. Install or update msposapp from the approved release package or tag.
5. Run `sudo ./install` if host dependencies or configuration changed.
6. Rebuild the base image only when OS media, kickstart files, Dockerfiles, or package sources changed.
7. Stage or restart the POS container as required by the release.
8. Start VPN connections and verify security associations.
9. Restore data only from the approved backup source.
10. Confirm the POS application, printing, VPN routing, and branch access.

Rollback
--------

Do not prune images, backups, or old release files until the release is accepted.

Rollback options:

- Return to the previous git tag or release package.
- Stop the new container and restart the previous known-good container image, if still available.
- Restore customer data from the last known-good backup.
- Recreate VPN configuration from the previously approved connection records.
- Rebuild the previous base image if the image was removed.

After rollback, capture the cause, customer impact, recovery time, and any follow-up work needed before retrying the release.

Release Evidence
----------------

Keep release evidence with the release notes:

- Approved release notes.
- `git status --short` or source commit/tag.
- Package checksum.
- `bash -n` output.
- `podman image ls` output.
- Container status output.
- VPN status output.
- Backup restore log, if used.
- Customer or internal approval.

Post-Release
------------

After release acceptance:

- Update release notes with final deployment status.
- Record any manual steps performed during deployment.
- Add follow-up fixes or documentation updates as new work items.
- Confirm generated state and secrets are not committed or packaged.
- Archive validation evidence according to operational and compliance requirements.

-----------------------
Mike Green - mgreen@teleflora.org
