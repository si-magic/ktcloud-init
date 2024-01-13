# KTCLOUD-INIT
This project is a set of scripts and Systemd units that crawl meta data from the
hypervisor to set up a VM instance on KT Cloud. The package intended to be used
to build a new custom Linux image from a generic cloud base image of a distro.

(c) 2024 David Timber &lt;dxdt 𝕒𝕥 dev.snart.me&gt;

The functions of the scripts are implemented in
[cloud-init](https://cloud-init.io/). KT Cloud is probably powered by Apache
OpenStack overseeing VMWare hypervisors because the scripts found in the images
provided by KT Cloud are from Apache CloudStack[^1].

The scripts in this package are modified to be run on the cloud images of modern
distros. Changes include...

- Use curl, removing wget dependency
- Use NetworkManager
- Remove unused
  - netconsole (not used by service provider, serial port is mostly used)
  - Remove xe-linux-distribution (modern distro kernels not built with XenFS)

In most cases, you're better off using cloud-init that comes with the image. See
the next section to decide if you really need this package on your image.

[^1]: https://docs.cloudstack.apache.org/en/latest/adminguide/virtual_machines.html#user-data-and-meta-data

## Considerations
| Script | cloud-init | But ... |
| - | - | - |
| cloud-set-guest-sshkey.in | YES | It's not safe([see here](doc/ssh_rsa-keylen.md)) |
| cloud-set-guest-password | YES | cloud-init depends on wget[^2] |
| sethostname2.sh | NO | Setting the hostname to the instance name is KT Cloud's own feature. This feature is controlled by the hypervisor's ability to include the client hostname in the DHCP offer. |
| userdataExecutor | NO | Downloading and executing user data as a shell script is KT Cloud's own feature. |

To summarise, if you don't need the last two, cloud-init and wget are all that
are required to use your image on KT Cloud. To configure cloud-init for Apache
CloudStack, refer to the link blow.

https://github.com/canonical/cloud-init/blob/1baa9ff060b549391fd6e29028ac78311b5df58b/doc/rtd/reference/datasources/cloudstack.rst#L19

If you need to get the last two features right, proceed to install.

[^2]: https://github.com/canonical/cloud-init/blob/1baa9ff060b549391fd6e29028ac78311b5df58b/cloudinit/sources/DataSourceCloudStack.py#L49

## INSTALL
If the cloud base image uses has cloud-init or any of the likes, disable it.

```sh
sudo touch /etc/cloud/cloud-init.disabled
```

Download the latest package and install it using your package manager.

```sh
curl -O https://github.com/si-magic/ktcloud-init/releases/download/latest/ktcloud-init-latest.rpm
sudo dnf install ktcloud-init-latest.rpm
```

Enable the service so that it will run from the next boot.

```sh
sudo systemctl enable ktcloud-init
```

That's it.

If you're applying it to an existing VM, follow the instructions in the next
section.

### Migrate
The package provided in the releases conflicts preexisting KT Cloud rc.d
scripts. If you're installing the package on the preexisting image by KT Cloud,
use the uninstall script `/usr/libexec/ktcloud-init/uninstall-ktcloud-rc.d.sh`
to remove the scripts manually after installing the package.
