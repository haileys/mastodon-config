#!/bin/bash
set -exuo pipefail

cd "$HOME"

# ensure run dir exists before bind mounting
mkdir -p $XDG_RUNTIME_DIR/postgresql

exec /usr/local/bin/bwrap \
	--unshare-user \
	--unshare-uts \
	--clearenv \
	--setenv PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
	--ro-bind oci-postgres-15.0/rootfs / \
	--proc /proc \
	--dev /dev \
	--bind $XDG_RUNTIME_DIR/postgresql /run/postgresql \
	--bind $HOME/postgresql/data /var/lib/postgresql/data \
	-- \
	postgres -D /var/lib/postgresql/data
