#!/bin/bash

create_user() {
    read -p "Enter username: " username
    read -p "Enter full name: " full_name
    read -s -p "Enter password: " password
    echo

    sudo useradd -m -c "$full_name" -s /bin/bash "$username"
    echo "$username:$password" | sudo chpasswd
    sudo passwd -e "$username"

    echo "User '$username' created successfully."
}

edit_user() {
    read -p "Enter username to edit: " username

    if id "$username" >/dev/null 2>&1; then
        read -p "Enter new full name (leave blank to keep current): " new_full_name
        read -s -p "Enter new password (leave blank to keep current): " new_password
        echo

        if [ -n "$new_full_name" ]; then
            sudo chfn -f "$new_full_name" "$username"
        fi

        if [ -n "$new_password" ]; then
            echo "$username:$new_password" | sudo chpasswd
            sudo passwd -e "$username"
        fi

        echo "User '$username' updated successfully."
    else
        echo "User '$username' does not exist."
    fi
}

delete_user() {
    read -p "Enter username to delete: " username

    # Check if the user exists
    if id "$username" >/dev/null 2>&1; then
        # Delete the user
        sudo userdel -r "$username"

        echo "User '$username' deleted successfully."
    else
        echo "User '$username' does not exist."
    fi
}


while true; do
    echo "User Management Script"
    echo "1. Create User"
    echo "2. Edit User"
    echo "3. Delete User"
    echo "4. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            create_user
            ;;
        2)
            edit_user
            ;;
        3)
            delete_user
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac

    echo
done