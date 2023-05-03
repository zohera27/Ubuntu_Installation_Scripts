#! /bin/bash

sudo apt-add-repository ppa:ansible/ansible -y

sudo apt update -y 

sudo apt install ansible -y

 ansible --version
 ERROR: Ansible requires the locale encoding to be UTF-8; Detected ISO8859-1.
 
The error message you are seeing indicates that the locale encoding on your system is not set to UTF-8, which is required by Ansible. 
To fix this, you can follow these steps:

1. Open the terminal on your Linux machine.
2. Run the following command to open the /etc/default/locale file: sudo nano /etc/default/locale
3. Add the following lines to the file: 
LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
4. Save the file by pressing Ctrl+O, then exit Nano by pressing Ctrl+X.
5. To apply the changes, you need to log out and log back in, or run the following command to reload the environment variables:
source /etc/default/locale
After performing these steps, 
the locale encoding on your system should be set to UTF-8, and you should be able to run Ansible without encountering the "locale encoding" error.


 
 
