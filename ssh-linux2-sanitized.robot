################################################################################
#
# Run: robot -v host_ip:192.168.1.123 -v base_ip:192.168.1.111 -v username:linuxuser -v password:Letmein123$ -v dir:/home/linuxuser -v file:rsa_key ssh-linux2.robot
# This is a demo of stuff you can do on a Linux server
# This is raw, sanitized, not clean, not DRY and not finished.  Consider it as 
# such and consider yourself warned - you'll need to do some work but the ideas
# and examples are present
################################################################################

*** Settings ***
Documentation  Robot Framework test script
Library  String
Library  SSHLibrary
Library  Process
################################################################################

*** Variables ***
${host_ip}		${EMPTY}
${base_ip}      ${EMPTY}
${username}		${EMPTY}
${password}		${EMPTY}
${dir}			${EMPTY}
${file}			${EMPTY}
${get_file}		${EMPTY}
${put_file}		${EMPTY}
${rm_file}    	${EMPTY}
${ls}			${EMPTY}
${reboot}		${EMPTY}
${fingerprint}  ${EMPTY}
${pwd}			pwd
################################################################################

*** Test Cases ***

Test SSH Connection
	Log to Console  Starting demo of capabilities
    Set Log Level  DEBUG
    Enable Ssh Logging  logfile.txt
    Log  Starting the connection to jump server
    Open Connection   ${host_ip}  port=22
################################################################################

Test SSH Log directory
	${output}  Login  			${username}  ${password}
	#Log to Console				${output}
################################################################################

Test Directory Exists	
	Directory Should Exist 		${dir}
	#Log to Console				${dir}
################################################################################

Test Delete File
	${rm_file}		Execute Command  rm ${dir}/${file}
	#Log to Console				${rm_file}
################################################################################

Test File No Exist
	File Should Not Exist	 		${file}
    #Log to Console				 	${file}
################################################################################

Test Put File
	${get_file}		Put File	C:\\tmp\\testfile.txt  ${dir}  mode=0600
	#Log to Console				${get_file}
################################################################################

Test Get File
	${get_file}		Get File 	${dir}/${file}  c:\\tmp\\${file}
	#Log to Console				${get_file}
################################################################################

Test File Exist
	File Should Exist	 		${file}
    #Log to Console				${file}
################################################################################

Test Text File Search 
	${files} 	List Files In Directory 	/tmp 	*.txt 	absolute=False
	#Log to Console				${files}
################################################################################

Test pwd Command 
	Execute Command			${pwd}  return_stdout=True  return_rc=False
	#Log to Console			${pwd}
################################################################################

Test rc Command
	${rc}=  	Catenate   echo 'Hello Dude!' > /home/linuxuser/hel.txt
	Execute Command			${rc}  return_stdout=True  return_rc=False
	...			return_stdout=True  return_rc=False
	#Log to Console			${rc}
################################################################################
################################################################################

Test SSH Hop Command

	#${base_ip}=  Catenate  192.168.1.169
	${ssh_username}=  Catenate  linuxuser
	${ssh_password}=  Catenate  Letmein123$
	#${ssh_connect}=  Catenate  ssh linuxuser@${base_ip}
	${ssh_next_hop_server_connect}=  Catenate  ssh -i rsa_key root@${base_ip}
	
##################

#Connect and pipe results to variables and console
	#Write  ${ssh_connect}
	Write  ${ssh_next_hop_server_connect}
	#${ssh_response}=  Read Until  ${base_ip}
	${ssh_response}=  Read  delay=0.5s
##################

#Connection fingerprint setup and prompt verification

	${ssh_fingerprint_prompt}=  Catenate  The authenticity of host \'${base_ip}
	#Log to Console  *
	#Log to Console  Fingerprint prompt variable
	#Log to Console  ${ssh_fingerprint_prompt}
##################

	#Should Be True  """${ssh_fingerprint_prompt}""" in """${ssh_response}"""
	${ssh_logon_compare}=  Evaluate  """${ssh_fingerprint_prompt}""" in """${ssh_response}"""
	
	IF  ${ssh_logon_compare} == True
		  Write  yes
			${fingerprint_message}=  Catenate  First time logging onto this
			...  server.
			Log to Console  ${fingerprint_message}
	END
##################

#Connection password setup and prompt verification
	${ssh_password_prompt}=  Catenate  ${ssh_username}@${base_ip}

	#Log to Console  *
	#Log to Console  Password prompt variable
	#Log to Console  ${ssh_password_prompt}
	#Log to Console  SSH Password Prompt string is: ${ssh_password_prompt}
##################

#Logging onto the second server goes here

##################

#Now do stuff on the second server

##################

#Logging onto the other server goes here

##################
##################
#Now do stuff on the other server

	${arch_type}=  Catenate  uname -m
	
	Write  ${arch_type}

	${ssh_response}=  Read  delay=0.5s
	Log to Console  ${ssh_response}

#from this server, now ssh to the isolated container
	${echo_hello}=  Catenate  echo 'Prepping for ssh to container server'  
	Write  ${echo_hello}

	${ssh_response}=  Read  delay=0.5s
	Log to Console  ${ssh_response}


	${container_server_connect}=  Catenate  ssh 192.168.122.123 -i /home/root/.ssh/id_rsa
	Write  ${container_server_connect}

	${ssh_response}=  Read  delay=0.5s
	Log to Console  ${ssh_response}

##################
#Now do stuff on the container_server side

	Write  ${arch_type}

	${ssh_response}=  Read  delay=0.5s
	Log to Console  ${ssh_response}
###

	${container_server_process_service_name_cli_get}=  Catenate  process_cli=$(ps | grep -v grep | grep 'service_name' | awk '{print $1}')
	Write  ${container_server_process_cli_get}

	${ssh_response}=  Read  delay=0.5s
	Log to Console  ${ssh_response}
###
	
	${container_server_process_ps_kill}=  Catenate  kill $process_cli
	Write  ${container_server_process_ps_kill}

	${ssh_response}=  Read  delay=0.5s
	Log to Console  ${ssh_response}

###

	${echo_container_server_con}=  Catenate  echo 'Are we in'
	Write  ${echo_container_server_con}

	${ssh_response}=  Read  delay=0.5s
	Log to Console  ${ssh_response}
###
	
	${pipe_txtfile}=  Catenate  echo -n pipe_txtfile > /tmp/pipe_txtfile
	Write  ${pipe_txtfile}

	${ssh_response}=  Read  delay=0.5s
	Log to Console  Check if pipe_txtfile worked
	Log to Console  ${ssh_response}
###

    ${pipe_txtfile}=  Catenate  service_name docker/prod/createStuff /tmp/pipe_txtfile pipe_txtfile 0
	Write  ${pipe_txtfile}

	${ssh_response}=  Read  delay=1.5s
	Log to Console  ${ssh_response}
###

#Confirm that the pipe_txtfile exists on first server
#	ls /tmp/store

#Reboot
	#Write  reboot

	${ssh_response}=  Read  delay=0.5s
	Log to Console  ${ssh_response}

##################
##################

#Connection password setup and prompt verification
	${ssh_password_prompt}=  Catenate  ${ssh_username}@${base_ip}
	#${ssh_password_prompt}=  Catenate  linuxuser@192.168.1.123
	#Log to Console  *
	#Log to Console  Password prompt variable
	#Log to Console  ${ssh_password_prompt}
	#Log to Console  SSH Password Prompt string is: ${ssh_password_prompt}
##################	

################################################################################
  Close All Connections
