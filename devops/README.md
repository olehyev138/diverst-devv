# Ansible configuration

1. In order to receive dependenceis, you need to run once:

    ansible-galaxy install -r requirements.yml -p dependencies

2. In order to not keep sensitive data in open-form, but still track them,
   they are kept in a encrypted way. To avoid entering a password every time,
   you can put it once in the `.vault-pass` file.

    echo mypass > .vault-pass

3. To run setup on all servers, run:

    ansible-playbook setup.yml

If an instance requires the SUDO pass, you can use:

    ansible-playbook setup.yml --ask-become-pass

If you want to run a specific task on a specific server, use:

    ansible-playbook setup.yml -l staging -t monit --ask-become-pass
