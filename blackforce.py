#!/home/dutchman/ansible/automation/bin/python3
from copy import deepcopy
import pprint
import yaml
import netmiko

SITE_NAME = "RedHat"
COMMAND_LIST = ["ls -l /boot/"]

def datacenter(path="datacenter.yml"):
    with open(path) as inventory:
        data = yaml.safe_load(inventory.read())
    return data

def connect_datacenter(datacenter_inventory, site="all"):
    inventory = deepcopy(datacenter_inventory)
    netcon = {}
    credentials = inventory["all"]["vars"]
    datacenter = inventory["all"]["datacenter"].get(site)
    if datacenter is None:
        raise KeyError(f"[+] Site: {site} is not specified in the datacenter inventory YAML FILE.")
    for host in datacenter["hosts"]:
        connection_handler = {}
        connection_handler.update(credentials)
        connection_handler.update(host)
        yield connection_handler

def execute_command(servers, commands):
    for server in servers:
        hostname = server.pop("hostname")
        connect_server = netmiko.ConnectHandler(**server)
        top = ["{0} {1} {0}".format("=" * 20, hostname.upper())]
        for cmd in commands:
            run_cmd = connect_server.send_command(cmd)
            top.append("{0} {1} {0}".format("=" * 20, cmd))
            top.append(run_cmd)
        
        cmd_output = "\n\n".join(top)
        connect_server.disconnect()
        yield cmd_output

def main():
    inventory_data = datacenter()
    datacenter_connect = connect_datacenter(inventory_data, site=SITE_NAME)
    for server in execute_command(datacenter_connect, COMMAND_LIST):
        print(server)

if __name__ == "__main__":
    main()
