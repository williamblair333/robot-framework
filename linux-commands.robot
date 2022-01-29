################################################################################
#
#Run example: robot -v ip_host:192.168.1.123 -i invoke_tests linux-commands.robot
#File:      linux-commands.robot
#Date:      2021DEC17
#Author:    William Blair
#Contact:	williamblair333@gmail.com
#Tested on: Windows 10
#To test:   Debian 10+ | Ubuntu 14+
#
#This script is intended to do the following:
#
#- demo of using python functions in robot to ssh connect to server and perform
#- various commands and then disconnect
#
################################################################################

*** Settings ***
Documentation  		Linux commands

Library   		linux-commands.py

Test Setup  		Begin Test
Test Teardown   	End Test

*** Variables ***
${IP_HOST}		${EMPTY}

*** Test Cases ***
Invoke Tests
    [Tags]  invoke_tests
    [Documentation]  To demo using python functions in robot

    ${filename}=  Setup Key File
    ${client}=  SSH Connect To Server   ${IP_HOST}  ${filename}
    SSH Kill Process	${client}
    SSH Generate File	${client}
    SSH Close Connection	${client}
