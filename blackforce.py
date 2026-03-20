#!/home/dutchman/ansible/automation/bin/python3
import pprint
import yaml


def datacenter(path="datacenter.yml"):
    with open(path) as inventory:
        data = yaml.safe_load(inventory.read())
    return data


def main():
    inventory_data = datacenter()
    pprint.pprint(inventory_data)

if __name__ == "__main__":
    main()
