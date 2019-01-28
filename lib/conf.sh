#
source ./conf/config.ini


create_user(){
    if [ -n "$username" -a -n "$userpwd" ];then
        useradd -m $username
        echo $userpwd | passwd --stdin $username
        echo "Create $username successfully: $userpwd"
    else
        echo "Dont create new username.Please figure out username and password"
    fi
}

non_secrecy(){
    if [ -d "/home/$username" ];then
        cd /home/$username
        su $username -c "ssh-keygen -t rsa"
        # use expect here
        for server in ${cluster_server[@]}
            do 
                echo "Please input the following password: $userpwd"
		su - $username -c "exit"
        	cd /home/hadoop/
        	ssh-copy-id -i /home/$username/.ssh/id_rsa.pub $username@$server
            done
    else
        echo "Dont set non_secrecy.Please create username[$username]"
    fi
    
        
}


mv_hadoop(){
    if [ -d "/home/$username" ];then
        cp -rf ./package/hadoop-2.9.2 /home/$username
	cp -rf ./package/jdk1.8.0_171 /home/$username
	echo "----Wait for permission..."
	chown -R $username:$username /home/$username/jdk1.8.0_171
        chown -R $username:$username /home/$username/hadoop-2.9.2
	echo "----successfully!"
    else
        echo "Dont move HADOOP to /home/xxx.Please create username[$username]"
    fi
}

hadoop_data(){
    if [ -d "/home/$username" ];then
        mkdir -p /home/$username/hadoop
        mkdir -p /home/$username/hadoop/tmp
        mkdir -p /home/$username/hadoop/var
        mkdir -p /home/$username/hadoop/dfs
        mkdir -p /home/$username/hadoop/dfs/name
        mkdir -p /home/$username/hadoop/dfs/data
	echo "----Wait for permission..."
	chown -R $username:$username /home/$username/hadoop
	echo "----successfully!"
    else
        echo "Dont mkdir hadoop data director.Please create username[$username]"
    fi
}

remove_hadoop_data(){
    if [ -d "/home/$username" ];then
        rm -rf /home/$username/hadoop
	echo "----successfully!"
    else
        echo "Dont remove hadoop data director.Please create username[$username]"
    fi
}

core_site_xml(){
    if [ -d "/home/$username" ];then
	core_site_file=/home/$username/hadoop-2.9.2/etc/hadoop/core-site.xml
        line=$(sed -n "/<configuration>/=" $core_site_file)
        line_2=$[$line+1]
        sed -i $line_2',$d' $core_site_file
	echo "	<property>" >> $core_site_file
          
	echo "        <name>hadoop.tmp.dir</name>" >> $core_site_file
        
	echo "        <value>/home/$username/hadoop/tmp</value>" >> $core_site_file
             
	echo "        <description>Abase for other temporary directories.</description>" >> $core_site_file

	echo "   </property>" >> $core_site_file
    
	echo "   <property>" >> $core_site_file

	echo "        <name>fs.default.name</name>" >> $core_site_file
    
	echo "        <value>hdfs://$current_server:$hdfs_port</value>" >> $core_site_file
    
	echo "   </property>" >> $core_site_file
	echo "</configuration>" >> $core_site_file
        
    else
        echo "Dont config core-site.xml .Please create username[$username]"
    fi
}

hdfs_site_xml(){
    if [ -d "/home/$username" ];then
        hdfs_site_file=/home/$username/hadoop-2.9.2/etc/hadoop/hdfs-site.xml 
	line=$(sed -n "/<configuration>/=" $hdfs_site_file)
        line_2=$[$line+1]
        sed -i $line_2',$d' $hdfs_site_file
	
	echo "  <property>" >> $hdfs_site_file

	echo "   <name>dfs.name.dir</name>" >> $hdfs_site_file

	echo "   <value>/home/$username/hadoop/dfs/name</value>" >> $hdfs_site_file


	echo "	</property>" >> $hdfs_site_file

	echo "	<property>" >> $hdfs_site_file

	echo "	   <name>dfs.data.dir</name>" >> $hdfs_site_file

	echo "	   <value>/home/$username/hadoop/dfs/data</value>" >> $hdfs_site_file

	echo "	   <description>Comma separated list of paths on the localfilesystem of a DataNode where it should store its bls.</description>" >> $hdfs_site_file

	echo "	</property>" >> $hdfs_site_file

	echo "	<property>" >> $hdfs_site_file

	echo "	   <name>dfs.replication</name>" >> $hdfs_site_file

	echo "	   <value>2</value>" >> $hdfs_site_file

	echo "	</property>" >> $hdfs_site_file

	echo "	<property>" >> $hdfs_site_file

	echo "	      <name>dfs.permissions</name>" >> $hdfs_site_file

	echo "	      <value>false</value>" >> $hdfs_site_file

	echo "	      <description>need not permissions</description>" >> $hdfs_site_file
	echo "	</property>" >> $hdfs_site_file

	echo "	<property>" >> $hdfs_site_file
	echo "	    <name>dfs.namenode.http-address</name>" >> $hdfs_site_file
	echo "	    <value>$namenode_server:$namenode_port</value>" >> $hdfs_site_file
	echo "	</property>" >> $hdfs_site_file
	echo "	<property>" >> $hdfs_site_file
	echo "	    <name>dfs.namenode.secondary.http-address</name>" >> $hdfs_site_file
	echo "	    <value>$secondary_server:$secondary_port</value>" >> $hdfs_site_file
	echo "	</property>" >> $hdfs_site_file

	echo "</configuration>" >> $hdfs_site_file
    else
        echo "Dont config hdfs-site.xml .Please create username[$username]"
    fi
}

mapred_site_xml(){
    if [ -d "/home/$username" ];then
        mapred_site_file=/home/$username/hadoop-2.9.2/etc/hadoop/mapred-site.xml
        cp -rf /home/$username/hadoop-2.9.2/etc/hadoop/mapred-site.xml.template $mapred_site_file
        sed -ri "s/<\/configuration>//" $mapred_site_file
        echo "          <property>" >> $mapred_site_file
        echo "              <name>mapred.job.tracker</name>" >> $mapred_site_file
        echo "              <value>$job_server:$job_port</value>" >> $mapred_site_file
        echo "          </property>" >> $mapred_site_file
        echo " " >> $mapred_site_file
        echo "          <property>" >> $mapred_site_file
        echo "              <name>mapred.local.dir</name>" >> $mapred_site_file
        echo "              <value>/home/$username/hadoop/var</value>" >> $mapred_site_file
        echo "          </property>" >> $mapred_site_file
        echo " " >> $mapred_site_file
        echo "          <property>" >> $mapred_site_file
        echo "              <name>mapreduce.framework.name</name>" >> $mapred_site_file
        echo "              <value>yarn</value>" >> $mapred_site_file
        echo "          </property>" >> $mapred_site_file
        echo " " >> $mapred_site_file
        echo "</configuration>" >> $mapred_site_file
    else
        echo "Dont config mapred-site.xml .Please create username[$username]"
    fi
}


slaves_(){
    if [ -d "/home/$username" ];then
        slaves_file=/home/$username/hadoop-2.9.2/etc/hadoop/slaves
        echo "" > $slaves_file
        sed -i "1d" $slaves_file
        for server in ${slaves[@]}
            do
                echo $server >> $slaves_file
            done
    else
        echo "Dont config slaves .Please create username[$username]"
    fi       
}

yarn(){
    if [ -d "/home/$username" ];then
        yarn_site_file=/home/$username/hadoop-2.9.2/etc/hadoop/yarn-site.xml
        yarn_line=$(sed -n "/<configuration>/=" $yarn_site_file)
        yarn_line_3=$[$yarn_line+3]
        sed -i $yarn_line_3',$d' $yarn_site_file
        echo "    <property>" >> $yarn_site_file

        echo "          <name>yarn.resourcemanager.hostname</name>" >> $yarn_site_file

        echo "          <value>$resourcemanager_server</value>" >> $yarn_site_file

        echo "    </property>" >> $yarn_site_file

        echo "    <property>" >> $yarn_site_file

        echo "          <description>The address of the applications manager interface in the RM.</description>" >> $yarn_site_file

        echo "          <name>yarn.resourcemanager.address</name>" >> $yarn_site_file

        echo "          <value>\${yarn.resourcemanager.hostname}:$resourcemanager_port</value>" >> $yarn_site_file

        echo "    </property>" >> $yarn_site_file

        echo "    <property>" >> $yarn_site_file

        echo "          <description>The address of the scheduler interface.</description>" >> $yarn_site_file

        echo "          <name>yarn.resourcemanager.scheduler.address</name>" >> $yarn_site_file

        echo "          <value>\${yarn.resourcemanager.hostname}:$resourcemanager_scheduler_port</value>" >> $yarn_site_file

        echo "    </property>" >> $yarn_site_file

        echo "    <property>" >> $yarn_site_file

        echo "          <description>The http address of the RM web application.</description>" >> $yarn_site_file

        echo "          <name>yarn.resourcemanager.webapp.address</name>" >> $yarn_site_file

        echo "          <value>\${yarn.resourcemanager.hostname}:$resourcemanager_webapp_port</value>" >> $yarn_site_file

        echo "    </property>" >> $yarn_site_file

        echo "    <property>" >> $yarn_site_file

        echo "          <description>The https adddress of the RM web application.</description>" >> $yarn_site_file

        echo "          <name>yarn.resourcemanager.webapp.https.address</name>" >> $yarn_site_file

        echo "          <value>\${yarn.resourcemanager.hostname}:$resourcemanager_webapp_https_port</value>" >> $yarn_site_file

        echo "    </property>" >> $yarn_site_file

        echo "    <property>" >> $yarn_site_file

        echo "          <name>yarn.resourcemanager.resource-tracker.address</name>" >> $yarn_site_file

        echo "          <value>\${yarn.resourcemanager.hostname}:$resourcemanager_tracker_port</value>" >> $yarn_site_file

        echo "    </property>" >> $yarn_site_file

        echo "    <property>" >> $yarn_site_file

        echo "          <description>The address of the RM admin interface.</description>" >> $yarn_site_file

        echo "          <name>yarn.resourcemanager.admin.address</name>" >> $yarn_site_file

        echo "          <value>\${yarn.resourcemanager.hostname}:$resourcemanager_admin</value>" >> $yarn_site_file

        echo "    </property>" >> $yarn_site_file

        echo "    <property>" >> $yarn_site_file

        echo "          <name>yarn.nodemanager.aux-services</name>" >> $yarn_site_file

        echo "          <value>mapreduce_shuffle</value>" >> $yarn_site_file

        echo "    </property>" >> $yarn_site_file

        echo "    <property>" >> $yarn_site_file

        echo "          <name>yarn.scheduler.maximum-allocation-mb</name>" >> $yarn_site_file

        echo "          <value>$yarn_maximum_mb</value>" >> $yarn_site_file

        echo "          <discription>The default:8182MB</discription>" >> $yarn_site_file

        echo "    </property>" >> $yarn_site_file

        echo "    <property>" >> $yarn_site_file

        echo "          <name>yarn.nodemanager.vmem-pmem-ratio</name>" >> $yarn_site_file

        echo "          <value>2.1</value>" >> $yarn_site_file

        echo "    </property>" >> $yarn_site_file

        echo "    <property>" >> $yarn_site_file

        echo "          <name>yarn.nodemanager.resource.memory-mb</name>" >> $yarn_site_file

        echo "          <value>$nodemanager_resource_mb</value>" >> $yarn_site_file

        echo "   </property>" >> $yarn_site_file

        echo "   <property>" >> $yarn_site_file

        echo "         <name>yarn.nodemanager.vmem-check-enabled</name>" >> $yarn_site_file

        echo "         <value>false</value>" >> $yarn_site_file

        echo "   </property>" >> $yarn_site_file
        echo "</configuration>" >> $yarn_site_file
    else
        echo "Dont config yarn .Please create username[$username]"
    fi

}

bashrc(){
    if [ -d "/home/$username" ];then
        echo "export JDK_ROOT=/home/$username/jdk1.8.0_171" >> /home/$username/.bashrc
        echo "export J2SDKDIR=\${JDK_ROOT}" >> /home/$username/.bashrc
        echo "export J2REDIR=\${JDK_ROOT}/jre" >> /home/$username/.bashrc
        echo "export JAVA_HOME=\${JDK_ROOT}" >> /home/$username/.bashrc
        echo "export DERBY_HOME=\${JDK_ROOT}/db" >> /home/$username/.bashrc

        echo "export HADOOP_HOME=/home/$username/hadoop-2.9.2" >> /home/$username/.bashrc
        echo "export PATH=\${JDK_ROOT}/bin:\${JDK_ROOT}/jre/bin:\${JDK_ROOT}/db/bin:\$PATH" >> /home/$username/.bashrc
        echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >> /home/$username/.bashrc

        echo "PATH=\$PATH:\$HOME/.local/bin:\$HOME/bin" >> /home/$username/.bashrc
        su $username -c "source /home/$username/.bashrc"
    else
        echo "Dont add hadoop to environment .Please create username[$username]"
    fi
}

hadoop_env(){
    if [ -d "/home/$username" ];then
	hadoop_env_file=/home/$username/hadoop-2.9.2/etc/hadoop/hadoop-env.sh 
	sed -ri "s/export JAVA_HOME=.+/export JAVA_HOME=\/home\/$username\/jdk1.8.0_171/" $hadoop_env_file
    else
        echo "Dont add java to hadoop .Please create username[$username]"
    fi
}



# hadoop_data
# create_user
# remove_hadoop_data
# mv_hadoop
# core_site_xml
# hdfs_site_xml
# mapred_site_xml
# slaves_
# yarn
# non_secrecy
