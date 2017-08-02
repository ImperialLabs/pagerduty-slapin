# SLAPIN - Pagerduty

This is the Pagerduty Plugin or "SLAPIN" for SLAPI Bot managed by the SLAPI Team.

## Installation & Configuration

Download a copy of this [yaml](pager.yml) or copy and paste the below to pager.yml into the config/plugins directory of your SLAPI bot.

```yaml
plugin:
  type: container
  config:
    name: pager # Name of instance
    Image: 'slapi/slapin-pagerduty' # Enter user/repo (or :tag is an option as well) (standard docker pull procedures), you can also pull from a private repo via domain.com/repo
    Env: # List of environment variables
      - PAGER_TOKEN='API_KEY' # Your API token
      - PAGER_SERVICE='SERVICE_ID' # Service(s) you wish to filter buy (Coming Soon)
```

or if you want to avoid using container Environment variables

```yaml
plugin:
  type: container
  mount_config: '/pager/config/pager.yml' # Path to config inside container, Will check if not nil and will mount if this exists into container
  config:
    Image: 'slapi/slapin-pagerduty' # Enter user/repo (or :tag is an option as well) (standard docker pull procedures), you can also pull from a private repo via domain.com/repo
# Pager Token and Service lookups
pager:
  token: adfiaujioj3489 # Your API token
  service: a9u30rj # Service to trigger via bot
```

## Usage

## Local Development

1.  Export the following `export PAGER_TOKEN=$TOKEN` or create a `./config/pager.yml` (like the examples in [Install](#installation--configuration) section, only need the `pager:` portion)
2.  Either run `bundle install` or run `bin/setup` to install dependencies
3.  Run `./bin/pager` to utilize program

### Optional Run Items
-  Run `rake spec` to run the tests
-  You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/imperiallabs/slapin-pagerduty>.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
