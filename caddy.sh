#!/bin/bash
#
#
# Caddy Web Server Installer
#
#

if [[ -e "/usr/local/bin/caddy" ]]; then
	echo ""
	echo "  Removing old Caddy script"
	rm -f /usr/local/bin/caddy
fi
echo ""
echo "  Setting up Caddy"
cd /tmp
wget -q --cache=off https://cdn.jsdelivr.net/gh/wf09/caddyserver/caddy
chmod +x caddy; mv caddy /usr/local/bin;
echo "  Done. run 'caddy' to use Caddy"
echo ""
exit;
