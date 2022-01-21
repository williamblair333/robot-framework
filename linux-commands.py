################################################################################
#
#Run example: Not intended for direct usage
#File:      linux-commands.py
#Date:      2021DEC17
#Author:    William Blair
#Contact:	williamblair333@gmail.com
#Tested on: Windows 10
#To test:   Debian 10+ | Ubuntu 14+
#
################################################################################
import os
import paramiko
from robot.api.deco import keyword

@keyword("Setup Key File")
def setup_key_file(filename='secret_rsa'):
    key_str="""-----BEGIN RSA PRIVATE KEY-----\n\
Proc-Type: 4,ENCRYPTED\n\
DEK-Info: AES-128-CBC,XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\
-----END RSA PRIVATE KEY-----"""

    if not os.path.exists(filename) :
        f = open(filename, "w")
        f.write(key_str)
        f.close()
    else:
        print('Key file exists')

    return filename

@keyword('SSH Connect To Server')
def connect_to_server(host, filename):
    username = 'username_here'
    password = 'password_here'
    ssh_key = paramiko.RSAKey.from_private_key_file(filename, password=password)
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(hostname=host, username=username, pkey=ssh_key)
    print(f"SSH connected {host}@{username}")

    return client

@keyword('SSH Kill Process')
def process_kill_cli(ssh_connect):
    command = 'bash -c "kill \$(ps |grep process_name | grep -v grep | sed \'s/ root.*//\')"'
    stdin, stdout, stderr = ssh_connect.exec_command(command)
    stdout.channel.set_combine_stderr(True)
    read = stdout.read()
    print(str(read))

@keyword('SSH Generate File')
def ssh_generate_file(ssh_connect):
    command = 'bash -c "echo -n pipe_txtfile > /tmp/pipe_txtfile"'
    stdin, stdout, stderr = ssh_connect.exec_command(command)
    stdout.channel.set_combine_stderr(True)
    read = stdout.read()
    print(str(read))

@keyword('SSH Close Connection')
def close_ssh_client(ssh_connect):
    ssh_connect.close()
