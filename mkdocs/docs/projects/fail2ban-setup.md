# Fail2ban Setup

## Context
As part of the resolution of the FTP incident, it was brought up again that we should really do something about rate-limiting and allow/deny-listing after the deprecatino of the allowhosts configuration used in CentOS 7.

This conversation settled on implementing fail2ban, this will need some testing, as failure to implement correctly will cause significant issues with customer access.
---
## Initial Testing
Initial testimg will consist of setting up an open ftp/sftp server with password authentication, fail2ban will then be installed.

We will setup fail2ban to use the dummy action, as below.

```sudo nano /etc/fail2ban/jail.d/sshd.conf```
```
[DEFAULT]
banaction = dummy

[sshd]
enabled = true
# customize the dummy log path
banaction = dummy[target=/var/log/fail2ban.dummy.log]
```

This should allow us to test for any edge cases and configure rate limiting at an appropriate level before implementing firewalld actions, similr to the below.
```
[sshd]
banaction = firewallcmd-ipset
```
Implementing the ban action in firewalld will allow it to also protect FTP traffic to the server without enabling a second VSFTPD jail, as it is likely that any automated traffic hitting the SFTP server is also trying to hit the FTP side.

If it proves simple enough we may just implment another jail anyway.