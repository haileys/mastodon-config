#!/bin/bash
set -exuo pipefail

cd "$HOME"

# ensure run dir exists before bind mounting
mkdir -p $XDG_RUNTIME_DIR/redis

# we can't --unshare-net here because mastodon does not support redis over unix socket - submit PR
exec /usr/local/bin/bwrap \
	--unshare-user \
	--unshare-uts \
	--hostname mastodon-redis \
	--clearenv \
	--setenv PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
	--ro-bind oci-redis-7.0.5/rootfs / \
	--ro-bind redis/etc/redis /etc/redis \
	--bind $XDG_RUNTIME_DIR/redis /run/redis \
	--bind redis/data /var/lib/redis \
	--proc /proc \
	--dev /dev \
	-- \
	/usr/local/bin/redis-server /etc/redis/redis.conf
