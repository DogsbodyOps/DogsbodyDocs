# Fail2ban Setup

## Context
As part of the resolution of the FTP incident, it was brought up again that we should really do something about rate-limiting and allow/deny-listing after the deprecatino of the allowhosts configuration used in CentOS 7  
This conversation settled on implementing fail2ban, this will need some testing, as failure to implement correctly will cause significant issues with customer access.
---
## Initial Testing
Initial testing will consist of setting up an open ftp/sftp server with password authentication, fail2ban will then be installed.

We will setup fail2ban to use the dummy action, as below.

```sudo nano /etc/fail2ban/jail.d/sshd.conf```
```
[DEFAULT]
banaction = dummy

[sshd]
enabled = true

# Customise bantime and the factor by which it multiplies, this should double it each time.
bantime = 3600
bantime.factor = 1

# Customise the dummy log path
banaction = dummy[target=/var/log/fail2ban.dummy.log]

# List of ignored IP's, means they shouldnt get banned, ever.
ignoreip = 10.64.0.0/12 217.155.49.58
```

This should allow us to test for any edge cases and configure rate limiting at an appropriate level before implementing firewalld actions, similr to the below.
```
[sshd]
banaction = firewallcmd-ipset
```
Implementing the ban action in firewalld will allow it to also protect FTP traffic to the server without enabling a second VSFTPD jail, as it is likely that any automated traffic hitting the SFTP server is also trying to hit the FTP side.

If it proves simple enough we may just implment another jail anyway.