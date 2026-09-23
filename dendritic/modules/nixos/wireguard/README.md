# AmneziaWG onboarding (server: mini, `awg0`, `10.0.101.0/24`, UDP `51820`)

Server pubkey: `tBla6rS/7dJMah8mF6vv/BQRpIIIahpNkgMWS2cq4F4=`

## 1. Generate a client keypair

```bash
umask 077
wg genkey | tee /tmp/awg-client.key | wg pubkey > /tmp/awg-client.pub
```

Add `{ publicKey = "<contents of /tmp/awg-client.pub>"; ip = "10.0.101.<number>"; }` to `peers` in `awg-server.nix` (next free octet after `.1`), rebuild mini, then continue. `S1-S4`/`H1-H4` in the client must match the server module exactly.

## 2. Client config (`awg-tunnel.conf`)

```ini
[Interface]
PrivateKey = <client_private_key>

Address = 10.0.101.<number>/32

Jc = 6
Jmin = 100
Jmax = 200
S1 = <obfuscation>
S2 = <obfuscation>
S3 = <obfuscation>
S4 = <obfuscation>
H1 = <obfuscation>
H2 = <obfuscation>
H3 = <obfuscation>
H4 = <obfuscation>

[Peer]
PublicKey = <server_public_key>
Endpoint = <server_ip>:51820
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 15
```

Import the `.conf` file in the AmneziaVPN app (QR is flaky across Amnezia apps). Delete `/tmp/awg-client.key` and `awg-tunnel.conf` after import.
