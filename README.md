VULNS:
- grub config: grub superusers
- have a fake crypto miner
- lightdm stuff- make it so that guest users can have uid below 1000

- group access control stuff (getfacl, all that stuff in terms of who owns and has permissions for stuff)

- ssh- key only 
- make service that does bad things 
- cronjobs galore in /etc/skel and make them create users,

- bad media extensions:
- ip tables 
- nologin shell stuff

- hopefully they have to priv esc to even fix some stuff

- configuring a mail server 

- key logger running in background
FORENSICS:
- use john to crack a blowfish hash

- applying automatic updates thru the GUI update manager

- browser chromium enhanced protection, blocks cookies, always use secure connections 

https://github.com/mattkoco/Kinesis-Scorebot

https://www.techrepublic.com/article/linux-101-a-comprehensive-list-of-available-linux-services/ 

https://linuxsecurity.com/features/complete-guide-to-keylogging-in-linux-part-1

added user johnb + their home directory
added user ward

encrypt user home directory   

sudo setfacl -m g:groupname:rwx /home/jj
https://www.geeksforgeeks.org/chown-command-in-linux-with-examples/

rafe
topper
ward\

#!/bin/bash

# User to check
USERNAME="ward"
# Default password for the user
PASSWORD="you_suck"

# Function to add user
add_user() {
    # Add user with a default password and without prompting
    useradd -m "$USERNAME" -s /bin/bash
    echo "$USERNAME:$PASSWORD" | chpasswd
}

# Check if user exists
if ! id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME does not exist. Adding..."
    add_user
else
    echo "User $USERNAME exists."
fi




