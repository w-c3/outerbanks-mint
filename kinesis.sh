#!/bin/bash
echo " "
echo "Kinesis Scorebot v1"
echo "NOTE: Please allow up to 5 minutes for scorebot updates & injects."
echo "Injects: NO" # Modify this if you run an inject

# Function to check if text exists in a file
check_text_exists() {
    local file="$1"
    local text="$2"
    local vuln_name="$3"
    
    if grep -q "$text" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

# Function to check if text does not exist in a file
check_text_not_exists() {
    local file="$1"
    local text="$2"
    local vuln_name="$3"
    
    if ! grep -q "$text" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

# Function to check if a file exists
check_file_exists() {
    local file="$1"
    local vuln_name="$2"
    
    if [ -e "$file" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

# Function to check if a file has been deleted
check_file_deleted() {
    local file="$1"
    local vuln_name="$2"
    
    if [ ! -e "$file" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

check_file_permissions() {
    local file="$1"
    local expected_permissions="$2"
    local vuln_name="$3"
    
    # Get the actual permissions of the file in numeric form (e.g., 644)
    actual_permissions=$(stat -c "%a" "$file")
    
    if [ "$actual_permissions" == "$expected_permissions" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

check_file_ownership() {
    local file="$1"
    local expected_owner="$2"
    local vuln_name="$3"
     if getfacl "$file" | grep -q "owner: $expected_owner"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}
check_service_up() {
    local service="$1"
    local vuln_name="$2"
    if systemctl is-active --quiet "$service"; then
         echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}
check_file_hash() {
    local file="$1"
    local hash="$2"
    local vuln_name="$3"
    local calculated_hash=$(sha512crypt "$file")
    if [ "$calculated_hash" == "$hash" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi  
}

check_package_installed() {
    local package="$1"
    local vuln_name="$2"
    if [ ! -e dpkg -l "$package" ]; then #probably doesnt work need to fix
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}
check_apache_module_installed() {
    local module="$1"
    local vuln_name="$2"
     if apache2ctl -M | grep -q "$module"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

echo " "
echo ">> Outer Banks Mint 21 Image <<"
echo " "

echo "FORENSICS"
check_text_exists "/home/johnb/Desktop/Forensics1.txt" "hot" "Forensics 1 Correct" 

echo "USER STUFF (and some other stuff)"
check_text_not_exists "/etc/sudoers.tmp" "ward    ALL=(ALL:ALL) ALL" "ward no longer has sudo priviledges"
check_text_not_exists "/etc/passwd" "rafe" "Unauthorized user rafe removed"
check_text_not_exists "/etc/passwd" "ward" "Unauthorized user ward removed"
check_file_deleted "/usr/share/sounds/sound.sh" "Malicious script removed that re-adds user ward"
check_file_deleted "/etc/systemd/system/sound.service" "Malicious service removed that re-adds user ward"
check_file_ownership "/etc" "root" "Wheezie no longer owns /etc"
check_text_exists "/etc/passwd" "sys:x:3:3:sys:/dev:/usr/sbin/nologin" "Can no longer log into user sys"
check_text_exists "/etc/group" "girls" "girls group created"
check_text_exists "/etc/group" "sarahc,kiara,wheezie,cleo" "girls group has all users"
check_text_exists "/etc/passwd" "heyward" "User heyward added"
check_text_not_exists "/etc/passwd" "wheezie:x:21:21:,,,:/home/wheezie:/bin/bash" "Wheezie does not have uid of 21"
check_text_not_exists "/etc/pam.d/common-auth" "nullok" "Users cannot have empty passwords"
check_text_exists "/etc/pam.d/common-auth" "auth    required                        pam_exec.so /usr/local/bin/gnome" "Wheezie backdoor removed"

check_file_deleted "/usr/local/bin/gnome" "Malicious backdoor script removed"



check_text_exists "/usr/lib/firefox/update-settings.ini" "ACCEPTED_MAR_CHANNEL_IDS=firefox-mozilla-release" "Firefox has correct update channel"



check_text_not_exists "/var/spool/cron/crontabs/root" "apache.sh" "casey gone"
check_text_not_exists "/etc/crontab" "3 * * * * /home/wheezie/apache2.sh" "casey actually gone"
check_file_deleted "/etc/cron.hourly/.apache2.sh" "casey actually gone but actually?"

echo "APACHE2 VULNS"
check_text_not_exists "/etc/apache2/ports.conf" "#Include ports.conf" "ports.conf included"
check_text_not_exists "/etc/apache2/ports.conf" "Listen 80" "apache2 operates on 443"
check_text_exists "/etc/apache2/conf-enabled/security.conf" "ServerTokens Prod" "hides apache version"
check_text_exists "/etc/apache2/conf-enabled/security.conf" "ServerSignature Off" "hides operating system on apache"
check_file_deleted "/var/www/html/secret.html" "Hidden password file on website deleted"
check_texts_exists "/etc/apache2/apache2.conf" "        Options -Indexes -FollowSymLinks" "disables directory listing and follow symlinks"
check_file_exists "/usr/share/doc/libapache2-mod-security2" "general apache vuln secured"
check_file_exists "/usr/share/doc/libapache2-mod-evasive" "general apache vuln secured"
check_text_exists "/etc/apache2/sites-available/default-ssl.conf" "Header always set Strict-Transport-Security \"max-age=31536000; includeSubDomains\"" "strict transport security enabled for apache"
check_service_up "apache2" "apache2 up and running"


echo "SSH vulns"
check_text_exists "/etc/ssh/sshd_config" "PermitRootLogin prohibit-password" "root login disabled"
check_text_exists "/etc/ssh/sshd_config" "Port 22" "ssh runs on port 22 goofball"
check_text_exists "/etc/ssh/sshd_config" "Protocol 2" "ssh uses protocol 2"
check_text_exists "/etc/ssh/sshd_config" "StrictMode yes" "strict mode enabled"
check_text_exists "/etc/ssh/sshd_config" "X11Forwarding no" "x11forwarding disabled"
check_text_exists "/etc/ssh/sshd_config" "UsePAM yes" "pam enabled for ssh"
check_text_exists "/etc/ssh/sshd_config" "IgnoreRhosts yes" "ignore rhosts enabled"
check_text_exists "/etc/ssh/sshd_config" "Compression no" "no more compression you bozo"
check_text_exists "/etc/ssh/sshd_config" "UsePrivilegeSeperation yes" "ssh uses priv seperation"

#grub things
check_text_exists"/etc/grub.d/40_custom" "set check_signatures=enforce" "grub signatures enforced"
check_text_exists"/etc/grub.d/40_custom" "export check_signatures" "grub signatures exported"
check_text_exists"/etc/grub.d/40_custom" "set superusers=\"wheezie\"" "wheezie is not a grub superuser"
