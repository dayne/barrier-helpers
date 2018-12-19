I try to avoid using the GUI to configure/run barrier so I created a simple bash script `barrier-client.sh` to launch my barrier client.  It reads from a `.config/barrier.cfg` file I created to determine the client name and server to connect to.

`cat ~/.config/barrier.cfg`
```
BARRIER_CLIENT_NAME=${HOSTNAME}
BARRIER_SERVER=gilbert.lan:24800
```

This expect the client to already be configured to trust the server.  That trust is managed by the `~/.config/barrier/SSL/Fingerprints/TrustedServers.txt` that has the finger print of the server.

```
$HOME/.config/barrier
└── SSL
    ├── Barrier.pem             # client's certificates
    └── Fingerprints
        ├── Local.txt           # client's certificate fingerprint
        └── TrustedServers.txt  # fingerprint of the server 
 ```

I'm also keen having ability to be seeing messages/attaching directly so I created a tmux launch script `barrierc-tmux.sh` to auto run `barrier-client.sh` in a tmux session on login.  

The barrierc-tmux.sh is autolaunched by my i3 by having the following line in my `.config/i3/config`
```
exec $HOME/.bin/barrierc-tmux.sh &
```