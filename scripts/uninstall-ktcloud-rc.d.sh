# Make a backup
tar -C /etc -czf /etc/rc.d.tar.gzip rc.d

# Remove
rm -f \
	/etc/rc.d/*/K50netconsole \
	/etc/rc.d/*/K02cloud-set-guest-password \
	/etc/rc.d/*/K90network \
	/etc/rc.d/*/K02cloud-set-guest-sshkey.in \
	/etc/rc.d/*/K86xe-linux-distribution \
	/etc/rc.d/init.d/xe-linux-distribution \
	/etc/rc.d/init.d/network \
	/etc/rc.d/init.d/cloud-set-guest-sshkey.in \
	/etc/rc.d/init.d/netconsole \
	/etc/rc.d/init.d/cloud-set-guest-password \
	/etc/rc.d/init.d/userdataExecutor \
	/etc/rc.d/init.d/sethostname2.sh

# These are run from rc.local directly. Mask them to suppress errors.
declare -a list_scripts=(
	"/etc/rc.d/init.d/userdataExecutor"
	"/etc/rc.d/init.d/sethostname2.sh"
)

for p in "${list_scripts[@]}"
do
	cat << EOF > "$p"
#!/bin/sh
# This file is a placeholder for ktcloud-init. For more info, visit
# https://github.com/si-magic/ktcloud-init
EOF
done
