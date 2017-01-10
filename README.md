# ansible-role-kibana

The role installs kibana 4.x.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `kibana_service_name` | service name | `{{ __kibana_service_name }}` |
| `kibana_config_dir` | path to directory where `kibana.yml` resides | `{{ __kibana_config_dir }}` |
| `kibana_config_path` | path to `kibana.yml` | `{{ __kibana_config_dir }}/kibana.yml` |
| `kibana_config_default` | dict of default values of `kibana.yml` | See below |
| `kibana_config` | dict that overrides `kibana_config_default` | `{}` |

## `kibana_config_default`

```yaml
kibana_config_default:
  server.port: 5601
  server.host: 0.0.0.0
  kibana.index: .kibana
  logging.dest: /var/log/kibana/kibana.log
  elasticsearch.url: http://localhost:9200
```

## Debian

| Variable | Default |
|----------|---------|
| `__kibana_config_dir` | `/etc` |
| `__kibana_service_name` | `kibana` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__kibana_config_dir` | `/usr/local/etc` |
| `__kibana_service_name` | `kibana` |

## OpenBSD

| Variable | Default |
|----------|---------|
| `__kibana_config_dir` | `/etc` |
| `__kibana_service_name` | `kibana` |

## RedHat

| Variable | Default |
|----------|---------|
| `__kibana_config_dir` | `/etc` |
| `__kibana_service_name` | `kibana` |

# Dependencies

* reallyenglish.redhat-repo (RedHat only)
* reallyenglish.apt-repo (Debian only)

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - { role: reallyenglish.apt-repo, when: ansible_os_family == 'Debian' }
    - { role: reallyenglish.redhat-repo, when: ansible_os_family == 'RedHat' }
    - ansible-role-kibana
  vars:
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
