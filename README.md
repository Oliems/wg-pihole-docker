# wg-pihole-docker
 Tutorial to setup a VPN and a DNS sinkhole on a Debian server, using Wireguard, Pi-hole and Docker.

 These instructions are meant for a Debian server and assume that you are using Linux or macOS.

## Server configuration

### User setup

- SSH into the server using `ssh root@serverip` and run `apt-get update && apt-get upgrade`.
- Create a new user with `useradd -m username` and set a password for this user with `passwd username`.
- Add the newly created user to the `sudo` group with `adduser username sudo`.
- Use `su username` to connect as the user you have just created.
- By default Debian does not use `bash`, which means you won't have tab completion or syntax colouring. To remedy that use `chsh -s /bin/bash` then log out and log back in with `exit` and then `su username`.
- If you get this error message :

```
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
    LANGUAGE = (unset),
    LC_ALL = (unset),
    LANG = "en_US.UTF-8"
are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
```

You can add the following lines to your `.bashrc` :

```
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
```

- In you home directory create a `.ssh` folder as well as a file named `authorized_keys` in it with `mkdir ~/.ssh && touch ~/.ssh/authorized_keys`.

### SSH

https://linux-audit.com/audit-and-harden-your-ssh-configuration/

- On your computer, go into you `.ssh` folder with `cd ~/.ssh`. If the folder does not exist create it using `mkdir ~/.ssh`.
- Use `ssh-keygen -t rsa -b 4096` to generate a key pair. It is recommended that you name the key so that you can keep track of them.
- You need to copy the public key you have just created to your server. To do that use `scp yourkey.pub username@serverip:`.
- In order to be able to connect to the server using your SSH key, you need to add it to the `authorized_keys` file using `cat yourkey.pub >> .ssh/authorized_keys`. You can then delete the public key from the server using `rm yourkey.pub`.
- Make a copy of the `sshd_config` with `sudo cp /etc/ssh/sshd_config /root/`.
- Then need to edit the content of the SSH daemon configuration using `sudo nano /etc/ssh/sshd_config`.
- A configuration example with sane defaults can be found in wg-pihole-docker/example-sshd_config.
- Once you have made changes in the `sshd_config` file restart the daemon using `sudo systemctl restart sshd`. If you have changed the SSH port, make sure to change the firewall rules accordingly before you log off.
- From now on, in order to log back into your server you will have to use the following command `ssh -2 -i ~/.ssh/yourkey username@serverip -p portnumber`.

### Firewall configuration

https://docs.pi-hole.net/guides/vpn/openvpn/firewall/
https://upcloud.com/community/tutorials/configure-iptables-debian/

- Install git with `sudo apt-get install git`
- Clone this repository with `git clone https://github.com/Oliems/wg-pihole-docker.git`
- Read, make changes if needed and then run the firewall script. Note that this script will erase all `iptables` rules and chains and replace them. If you run this script after the installation of Docker, you will need to run `service docker restart` in order to re-install the rules and chains Docker needs to run properly.
- Make changes persistent

## Docker and Docker-compose installation

curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $(whoami)
exit

https://docs.docker.com/compose/install/

## Wireguard configuration

https://github.com/WeeJeWel/wg-easy/

## Pi-hole configuration

https://github.com/pi-hole/docker-pi-hole
