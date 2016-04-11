ansible-role-kibana
===================

The role installs kibana 4.x.

Requirements
------------

None

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

| Name | Description | Default|
|------|-------------|--------|
| kibana\_service\_name      | service name | \_\_kibana\_service\_name |
| kibana\_config             | path to kibana.yml | \_\_kibana\_config\_dir |
| kibana\_server\_port       | server.port | 5601 |
| kibana\_server\_host       | server.host | 0.0.0.0 |
| kibana\_bathPath           | kibana.basePath | "" |
| kibana\_elasticsearch\_url | elasticsearch.url | http://localhost:9200 |
| kibana\_index              | kibana.index | .kibana |
| kibana\_logging\_dest      | kibana.logging\_dest | stdout |

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: ansible-role-kibana, kibana_server_port: 8080 }

License
-------

BSD

Author Information
------------------

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
