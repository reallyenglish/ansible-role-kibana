# ansible-role-kibana

The role installs kibana 4.x.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `kibana_package_name` | package name | `{{ __kibana_package_name }}` |
| `kibana_service_name` | service name | `{{ __kibana_service_name }}` |
| `kibana_user` | user name of `kibana` | `{{ __kibana_user }}` |
| `kibana_group` | group name of `kibana` | `{{ __kibana_group }}` |
| `kibana_config_dir` | path to directory where `kibana.yml` resides | `{{ __kibana_config_dir }}` |
| `kibana_config_path` | path to `kibana.yml` | `{{ __kibana_config_dir }}/kibana.yml` |
| `kibana_config_default` | dict of default values of `kibana.yml` | See below |
| `kibana_config` | dict that overrides `kibana_config_default` | `{}` |
| `kibana_default_ubuntu` | dict of settings in `/etc/default/kibana`. see below (Ubuntu only) | `{"KILL_ON_STOP_TIMEOUT"=>"0"}` |
| `kibana_default_redhat` | dict of settings in `/etc/sysconfig/kibana`. see below (Red Hat only) | `{}` |

## `kibana_config_default`

```yaml
kibana_config_default:
  server.port: 5601
  server.host: 0.0.0.0
  kibana.index: .kibana
  logging.dest: /var/log/kibana/kibana.log
  elasticsearch.url: http://localhost:9200
```

### `kibana_default_ubuntu`

A dict of variables and values in `/etc/default/kibana`.

| Key | Value |
|-----|-------|
| variable name | the value |

Given the following YAML,

```yaml
kibana_default_ubuntu:
 FOO: bar
```

The role generates `/etc/default/kibana`

```
FOO="bar"
```

## Debian

| Variable | Default |
|----------|---------|
| `__kibana_package_name` | `kibana` |
| `__kibana_config_dir` | `/etc` |
| `__kibana_service_name` | `kibana` |
| `__kibana_user` | `kibana` |
| `__kibana_group` | `kibana` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__kibana_package_name` | `kibana45` |
| `__kibana_config_dir` | `/usr/local/etc` |
| `__kibana_service_name` | `kibana` |
| `__kibana_user` | `www` |
| `__kibana_group` | `www` |

## OpenBSD

| Variable | Default |
|----------|---------|
| `__kibana_package_name` | `kibana` |
| `__kibana_config_dir` | `/etc` |
| `__kibana_service_name` | `kibana` |
| `__kibana_user` | `_kibana` |
| `__kibana_group` | `_kibana` |

## RedHat

| Variable | Default |
|----------|---------|
| `__kibana_package_name` | `kibana` |
| `__kibana_config_dir` | `/etc` |
| `__kibana_service_name` | `kibana` |
| `__kibana_user` | `kibana` |
| `__kibana_group` | `kibana` |

### `kibana_default_redhat`

A dict of variables and values in `/etc/sysconfig/kibana`.

| Key | Value |
|-----|-------|
| variable name | the value |

Given the following YAML,

```yaml
kibana_default_redhat:
 FOO: bar
```

The role generates `/etc/sysconfig/kibana`

```
FOO="bar"
```

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - role: reallyenglish.apt-repo
      when: ansible_os_family == 'Debian'
    - role: reallyenglish.redhat-repo
      when: ansible_os_family == 'RedHat'
    - ansible-role-kibana
  vars:
    kibana_package_name: "{% if ansible_os_family == 'FreeBSD' %}kibana46{% else %}kibana{% endif %}"
    apt_repo_to_add:
      - deb https://packages.elastic.co/kibana/4.6/debian stable main
    apt_repo_keys_to_add:
      - https://packages.elastic.co/GPG-KEY-elasticsearch
    apt_repo_enable_apt_transport_https: yes
    redhat_repo:
      kibana-4.6:
        baseurl: https://packages.elastic.co/kibana/4.6/centos
        gpgcheck: yes
        gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch
        enabled: yes
```

# License

```
Copyright (c) 2016 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
