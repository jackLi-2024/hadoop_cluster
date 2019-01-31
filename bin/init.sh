source ./lib/conf.sh


if [ "$1" == "create-user" ];then
	create_user

elif [ "$1" == "non-secrecy" ];then
	non_secrecy

elif [ "$1" == "copy-hadoop" ];then
	mv_hadoop

elif [ "$1" == "data-dir" ];then
	hadoop_data

elif [ "$1" == "remove-data" ];then
	remove_hadoop_data
elif [ "$1" == "config-hadoop" ];then
	core_site_xml
	hdfs_site_xml
	mapred_site_xml
	slaves_
	yarn
	hadoop_env

elif [ "$1" == "hadoop-to-env" ];then
	bashrc

elif [ "$1" == "synchronization" ] ;then
    synchronization
	
elif [ "$1" == "help" ];then
	echo "Help:"
	help="true"
elif [ -n "$1" ];then
	echo "Please input command follows:"
	help = "true"
else
	echo "Dont support the command [$1]:"
	help="true"
fi

if [ -n "$help" ];then
        echo "    create-user:          Create a new user with root"
        echo "    non-secrecy:          No password between new users"
        echo "    copy-hadoop:          Copy the hadoop package"
        echo "    data-dir:             Create hadoop data directory"
        echo "    remove-data:          Remove the hadoop data catalog"
        echo "    hadoop-to-env:        Add hadoop to the new user environment variables"
	echo "    config-hadoop:        config hadoop params"
        echo "    synchronization:      synchronization hadoop information to other servers"
        echo "    help:                 Get help"
else
        echo ""

fi
