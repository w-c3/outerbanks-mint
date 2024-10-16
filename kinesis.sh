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

echo " "
echo ">> Outer Banks Mint 21 Image <<"
echo " "


check_text_not_exists "/etc/sudoers.tmp" "ward    ALL=(ALL:ALL) ALL" "ward no longer has sudo priviledges"
check_text_not_exists "/etc/passwd" "rafe" "Unauthorized user rafe removed"
check_text_not_exists "/etc/passwd" "ward" "Unauthorized user ward removed"
check_file_deleted "/usr/share/sounds/sound.sh" "Malicious script removed that re-adds user ward"
check_file_deleted "/etc/systemd/system/sound.service" "Malicious service removed that re-adds user ward"
check_file_ownership "/etc" "root" "Wheezie no longer owns /etc"
check_text_exists "/etc/passwd" "sys:x:3:3:sys:/dev:/usr/sbin/nologin" "Can no longer log into user sys"
check_text_exists "/etc/pam.d/common-auth" "nullok" "Users cannot have empty passwords"
check_text_exists "/etc/pam.d/common-auth" "auth    required                        pam_exec.so /usr/local/bin/gnome" "Wheezie backdoor removed"
check_file_deleted "/usr/local/bin/gnome" "Malicious backdoor script removed"
check_file_ownership "/home/jj" "girls" "girls group owns jj home directory"

