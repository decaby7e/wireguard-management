#!/usr/bin/python3

import yaml
import subprocess

class Client():
    

class Server():

class Network():
    # Public variables go outside init
    
    def __init__(self):
        self.name
        self.subnet
        self.version
        self.dns

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

if __name__=='__main__':
    main()