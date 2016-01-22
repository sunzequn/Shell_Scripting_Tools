#!/bin/bash

# Default values for database variables.
dbhost="localhost"
dbport=3306
dbname="geonames"
dbusername="root"
dbpassword="root"
download_folder="data"

logo() {
	echo "================================================================================================"
	echo "                             G E O N A M E S    D A T A    L O A D E R                          "
 	echo "                  Thanks for the open source project : GeoNames-MySQL-DataImport                "   
    echo "                                        Modified by Sloriac                                     "   
	echo "================================================================================================"
}

usage() {
	logo
	echo "Usage : " $0 "-a <action> -u <user> -p <password> -h <host> -r <port> -n <dbname>"
	echo " This is to operate with the geographic database"
    echo " Where <action> can be one of this: "
    echo "    auto-import Import data automatically， including the following actions : download-data, create-db, import-dumps."
	echo "    download-data Downloads the last packages of data available in GeoNames to the folder called 'data' under your current directory."
    echo "    create-db Creates the mysql database structure with no data."
    echo "    create-tables Creates the tables in the current database. Useful if we want to import them in an exsiting db."
    echo "    import-dumps Imports geonames data into db. A database is previously needed for this to work."
	echo "    drop-db Removes the db completely."
    echo "    truncate-db Removes geonames data from db."
    echo
    echo " The rest of parameters indicates the following information :"
	echo "    -u <user>     User name to access database server (default: root)."
	echo "    -p <password> User password to access database server (default: root)."
	echo "    -h <host>     Data Base Server address (default: localhost)."
	echo "    -r <port>     Data Base Server Port (default: 3306)."
	echo "    -n <dbname>  Data Base Name for the geonames.org data (default: geonames)."
	echo "================================================================================================"
    exit -1
}

download_geonames_data() {
	echo "Downloading GeoNames.org data..." 
    if [ ! -d "$download_folder" ]; then
			echo "Folder '$download_folder' doesn't exists. Run mkdir..."
			mkdir "$download_folder"
	fi
    dumps="allCountries.zip"
    zip_codes="allCountries.zip"
    for dump in $dumps; do
        wget -c -P "$download_folder" http://download.geonames.org/export/dump/$dump
    done
    for zip in $zip_codes; do
        wget -c -P "$download_folder"/zip http://download.geonames.org/export/zip/$zip
    done
    unzip ./"$download_folder"/zip/"*.zip" -d ./"$download_folder"/zip
    rm ./"$download_folder"/zip/*.zip
    unzip ./"$download_folder"/"*.zip" -d ./"$download_folder"
    rm ./"$download_folder"/*.zip
}

create_db() {
    echo "Creating database $dbname..."
    mysql -h $dbhost -P $dbport -u $dbusername -p$dbpassword -Bse "DROP DATABASE IF EXISTS $dbname;"
    mysql -h $dbhost -P $dbport -u $dbusername -p$dbpassword -Bse "CREATE DATABASE $dbname DEFAULT CHARACTER SET utf8mb4;" 
    mysql -h $dbhost -P $dbport -u $dbusername -p$dbpassword -Bse "USE $dbname;" 
    mysql -h $dbhost -P $dbport -u $dbusername -p$dbpassword $dbname < geonames_db_struct.sql
}

create_tables() {
    echo "Creating tables for database $dbname..."
    mysql -h $dbhost -P $dbport -u $dbusername -p$dbpassword -Bse "USE $dbname;" 
    mysql -h $dbhost -P $dbport -u $dbusername -p$dbpassword $dbname < geonames_db_struct.sql
}

import_dumps() {
    echo "Importing geonames dumps into database $dbname"
    mysql -h $dbhost -P $dbport -u $dbusername -p$dbpassword --local-infile=1 $dbname < geonames_import_data.sql
}

if [ $# -lt 1 ]; then
	usage
	exit 1
fi

logo

# Deals with operation mode 
# Parses command line parameters.
while getopts "a:u:p:h:r:n:" opt; 
do
    case $opt in
        a) action=$OPTARG ;;
        u) dbusername=$OPTARG ;;
        p) dbpassword=$OPTARG ;;
        h) dbhost=$OPTARG ;;
        r) dbport=$OPTARG ;;
        n) dbname=$OPTARG ;;
    esac
done


case $action in
    download-data)
        download_geonames_data
        exit 0
    ;;
esac

echo "Database parameters being used..."
echo "Orden: " $action
echo "UserName: " $dbusername
echo "Password: " $dbpassword
echo "DB Host: " $dbhost
echo "DB Port: " $dbport
echo "DB Name: " $dbname

case "$action" in
    auto-import)
        download_geonames_data
        create_db
        import_dumps
    ;;

    create-db)
        create_db
    ;;
        
    create-tables)
        create_tables
    ;;
    
    import-dumps)
        import_dumps
    ;;    
    
    drop-db)
        echo "Dropping $dbname database"
        mysql -h $dbhost -P $dbport -u $dbusername -p$dbpassword -Bse "DROP DATABASE IF EXISTS $dbname;"
    ;;
        
    truncate-db)
        echo "Truncating \"geonames\" database"
        mysql -h $dbhost -P $dbport -u $dbusername -p$dbpassword $dbname < geonames_truncate_db.sql
    ;;
esac

if [ $? == 0 ]; then 
	echo "[OK]"
else
	echo "[FAILED]"
fi

exit 0
