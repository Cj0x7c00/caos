#!/bin/bash

read -p "The script will install all required dependencies.. Do you want to continue? [Y/n]: " user_input

function install_depends()
{
    echo "Installing Base Dependencies"
    sudo apt install build-essential
    sudo apt install bison
    sudo apt install flex
    sudo apt install libgmp3-dev
    sudo apt install libmpc-dev
    sudo apt install libmpfr-dev
    sudo apt install texinfo
    sudo apt install libisl-dev

    curl https://ftp.gnu.org/gnu/binutils/binutils-2.25.1.tar.gz -o binutils-2.25.1.tar.gz
    sudo tar -xvzf binutils-2.25.1.tar.gz
}

case "$user_input" in
    [Yy]* ) 
        echo "Continuing..."; 
        install_depends
        # Place the code you want to execute here
        ;;
    [Nn]* )
        echo "Operation cancelled.";
        exit 1
        ;;
    * )
        echo "Invalid input. Please enter Y or n.";
        exit 1
        ;;
esac
