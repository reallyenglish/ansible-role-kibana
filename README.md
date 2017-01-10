# ansible-role-kibana

The role installs kibana 4.x.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `kibana_service_name` | service name | `{{ __kibana_service_name }}` |
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

# Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: ansible-role-kibana, kibana_server_port: 8080 }

# License

BSD

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>
