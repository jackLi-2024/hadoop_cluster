*** It is better to build a hadoop cluster with more than 2 machines

cd hadoop_cluster

Please download hadoop-2.9.2 and jdk1.8.0_171 on baidu disk first
address: https://pan.baidu.com/s/1G3VWiG1FiZjB42tOrMX_GQ 
Extract the code: al45 

Unzip the package: tar -xvzf package.tgz


step 1. pre-configured
	
	ip		hostname
	172.19.0.1	hserver1
	172.18.2.32	hserver2
	192.43.2.31	hserver3


	a).You can change your hostname.But it is not necessary, the purpose is to facilitate the identification of the machine
		hostnamectl set-hostname hserver1(172.19.0.1)
		hostnamectl set-hostname hserver2(172.18.2.32)
		hostnamectl set-hostname hserver3(192.43.2.31)

	b).Modify the hosts
		vim /etc/hosts [172.19.0.1, 172.18.2.32, 192.43.2.31]   --> :wq(save)
	    add params these files:
		==============
		172.19.0.1      hserver1
        	172.18.2.32     hserver2
        	192.43.2.31     hserver3
	

step 2. Configure the hadoop cluster to set up the necessary parameters
	vim conf/config.ini
	
	================================================================================================
	# cluster work user

	username=hadoop         	 // cluster work user name. e.g work
	userpwd=123456			// cluster work user password

	# cluster name
	cluster_server=(hserver1 hserver2 hserver3)	// cluster server machines

	# hadoop config
	hdfs_port=8888			// the port of hdfs  
	current_server=hserver1		// The machine currently served. 
					// if you are in hserver2,you need to modify the param:
						current_server=hserver2

	# namenode
	namenode_server=hserver1 	// namenode server
	namenode_port=8118     		// namenode port

	# secondary
	secondary_server=hserver3	// secondarynamenode server
	secondary_port=8119		// secondarynamenode port

	# mapred.job.tracker
	job_server=hserver1		// mapred.job.tracker server
	job_port=49001			// mapred.job.tracker port


	# slaves
	slaves=(hserver1 hserver2 hserver3)  // datanode cluster server


	# yarn config
	resourcemanager_server=hserver1    	// resourcemanager hserver
	resourcemanager_port=8032		// resourcemanager port
	resourcemanager_scheduler_port=8030	// resourcemanager scheduler port
	resourcemanager_webapp_port=8088	// resourcemanager webapp port
	resourcemanager_webapp_https_port=8090  // resourcemanager webapp_https port
	resourcemanager_tracker_port=8031	// resourcemanager tracker port
	resourcemanager_admin=8033		// resourcemanager admin port

	# memory
	yarn_maximum_mb=1024			// The maximum amount of physical memory a single task can claim
	nodemanager_resource_mb=1024		// Node maximum available memory
	===========================================================================================================




step 3. hadoop init(****)
	**** Each machine performs the same operation [hserver1, hserver2, hserver3] 
	a). create user
		sh bin/init.sh create-user
		validate:
			su {your username}  // su hadoop
	b). non-secrecy
		sh bin/init.sh non-secrecy
		validate:
			ssh {your username}@hsercer{other machina}  // ssh hadoop@hserver2
	c). copy-hadoop
		sh bin/init.sh copy-hadoop
		validate:
			ll /home/{username}  // ll /home/hadoop/
	d). add hadoop to enviroment
                sh bin/init.sh hadoop-to-env
                validate:
                        su {your username}  // su hadoop
                        jps
	e). remove-data(clear hadoop data)
		sh bin/init.sh remove-data
	f). create hadoop data direcitor
		sh bin/init.sh data-dir
	g). config-hadoop(config hadoop params)
		sh bin/init.sh config-hadoop

step 4. Switch the user
	su {your username}   // su hadoop

step 5. namenode format
	**** Run on the namenode machine  // e.g  hadoop user
	hadoop namenode -format

step 6. start hadoop
	**** If you only run hadoop on the hserver1 machine, hserver2 and hserver2 will run automatically
	**** Make sure the user is {your username}    // e.g  hadoop user

	a). start all node 
		****include NodeManager SecondaryNameNode DataNode NameNode ResourceManager JobTracker TaskTrack
		start-all.sh
	

	b). Go in and check all the machines
		[hserver1, hserver2, hserver3]
		input the command:
			jps
step 7. validate webapp
	Enter the following address in your browser:
		http://{your webapp host}:{your webapp host}
		// http://106.12.217.41:8088

step 8. other command
	a). Program startup exception and kills all hadoop related processes
		stop-all.sh
	b). If only a node cannot be started, and the reason cannot be determined, the node can be started separately
		hadoop-daemon.sh start namenode      	// run namenode
		hadoop-daemon.sh start datanode 	// run datanode
		hadoop-daemon.sh start secondarynamenode // run secondarynamenode
		yarn-daemon.sh start resourcemanager	// run resourcemanager
		...

	c). Stop a process individually
		hadoop-daemon.sh stop namenode
		...


		
