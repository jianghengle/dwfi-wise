#!/usr/bin/python
import os, sys
import requests
import subprocess
from requests.exceptions import Timeout

def main(url, service):
    try:
        response = requests.get(url, timeout=5, verify=False)
    except:
        print('SERVER STOPPED! RESTART SERVICE ...')
        if service is not '':
            os.system('sudo systemctl restart ' + service)
    else:
        print('Server is working.')


if __name__ == "__main__":
    url = ''
    service = ''
    if len(sys.argv) > 1:
        url = sys.argv[1]
    if len(sys.argv) > 2:
        service = sys.argv[2]
    main(url, service)
