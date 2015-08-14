#!/bin/bash

# Simple MySQL db & user creation
#usage sh create_mysql_user.sh -u username -p password -h localhost -d database

# Get the options first
while getopts 'U:P:u:p:d:h:' flag; do
    case "${flag}" in
        u) user="${OPTARG}" ;;
        p) password="${OPTARG}" ;;
        d) db="${OPTARG}" ;;
        U) rootUser="${OPTARG}" ;;
        P) rootPassword="${OPTARG}" ;;
        h) host="${OPTARG}" ;;
    esac
done

if [ "$rootUser" == "" ] || [ "$rootPassword" == "" ]; then
    echo "Root Username and Password required"
    exit
fi

if [ "$host" == "" ] ; then
    echo "Host is not provided, Default host is 'Localhost'"
    host="localhost"
fi

if [ "$user" == "" ] ; then
    echo "User is not provided, User will be database name"
    user="$db"
fi

if [ "$db" == "" ] ; then
    echo "Database is not provided, Database will be username"
    db="$user"
fi

if [ "$password" == "" ] ; then
    password=`date +%s | sha256sum | base64 | head -c 8 ;`
    echo "Password is not provided, Password is $password"
fi

if [ "$user" != "" ] && [ "$password" != "" ] && [ "$db" != "" ] && [ $host != "" ] ; then
    mysql -u "$rootUser" "-p$rootPassword" -e "create database $db"
    mysql -u "$rootUser" "-p$rootPassword" -e "CREATE USER '$user'@'$host' IDENTIFIED BY '$password';"
    mysql -u "$rootUser" "-p$rootPassword" -e "GRANT ALL PRIVILEGES ON $db.* TO $user@$host;"

    echo "\nDB & User Created..."
else
    echo "Sorry couldn't create DB & User, one of the option is blank"
fi
