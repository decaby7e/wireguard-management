#!/usr/bin/python3

import yaml
import subprocess
import wireguard.py

class Client():
    def __init__(self):
        self.name
        self.ip
        self.pubkey = subprocess.call("")
        self.privkey = subprocess.call(["wg", "genkey"])
        
        proc = subprocess.Popen(['cdrecord', '--help'], stdout=subprocess.PIPE)
        
        self.server_ip
        self.server_port
        self.server_pubkey

        def gen_conf(self):
            subprocess.call(["./gen-wg-client.sh", "-s", server_pubkey,
                            "-a", server_ip, "-p", server_port, "-c", ip,
                            "-f", "{}.conf".format(name), "-n", name])
            return "{}.conf".format(name)

class Server():

class Network():
    # Public variables go outside init
    
    def __init__(self, conf_file):
        self.name
        self.subnet
        self.version
        self.dns
        self.yaml = yaml.load(conf_file)

    def add_server(self):
        # Create server in YAML and return True on success
        # If server already exists in YAML, return False
    
    def del_server(self):

    def add_client(self):
        # Create client in YAML and return True on success
        # If client already exists in YAML, return False
        # Client should be identified by name which has an associated IP
        # There being a conflicting IP in the YAML should prompt the user the
        # option to remove the older client and override it with the new one

    def del_client(self):

def main():
    Network n = Network(open('prototype.yaml'))

if __name__=='__main__':
    main()