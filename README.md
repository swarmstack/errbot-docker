# swarmstack/errbot-docker

Docker image for [Err](http://errbot.io), a chat-bot designed to be easily deployable, extensible and maintainable.

[https://hub.docker.com/r/swarmstack/errbot-docker/](https://hub.docker.com/r/swarmstack/errbot-docker/)

Built from Alpine Linux 3.8 and Python 3.6. Functions as a vanilla Err with it's available backends, plus optional Cisco Webex Teams backend support. Support for other community-provided backends vi local_backends directory.  Plugins can be installed and configured via the bot. [swarmstack](https://github.com/swarmstack/swarmstack) users should begin at the SWARMSTACK USERS section.

## INSTALLATION

To simply deploy Errbot in interactive _Text_ mode:

```
cd /usr/local/src
git clone https://github.com/swarmstack/errbot-docker
cd errbot-docker
docker run -it swarmstack/errbot-docker:latest
```

To instead run the image as detached container with exposed ports and connecting to your configured BACKEND:

```
vi config.py
docker run -d --entrypoint errbot -p 3141:3141 -v `pwd`:/err/local_config swarmstack/errbot-docker:latest -c /err/local_config/config.py
```

## AS A STACK ON A DOCKER SWARM HOST

On a Docker swarm host (you can even _docker swarm init --advertise-addr 192.168.99.121_ a single host), so that just your config.py can be copied into the container:

```
vi config.py
vi docker-compose.yml  # change ./local_bind_volume_dir if you want errbot data persisted elsewhere
docker stack deploy -c docker-compose.yml errbot
```

You can also add any local_plugins and local_backends to those directories before deploying, although it's recommended to instead install plugins as documented in the CONFIGURATION section where possible.

## CONFIGURATION

You should configure your social network of choice as BACKEND in config.py and configure it's parameters (generally in the form of BOT_CONFIG_ITEM values) before starting the bot. Refer to [Alertmanager Configuration](https://prometheus.io/docs/alerting/configuration/) for parameters required for your specific backend.

After altering config.py to your liking and starting the bot as a container or stack (above), from within your social network client: start a direct conversation with the bot and configure the bot's web server if you want the bot to able to receive webhooks, such as by the Alertmanager errbot-alerrtmanagerr plugin:

    botname plugin config Webserver
    botname plugin config Webserver {'HOST': '0.0.0.0',  'PORT': 3141}

You can install plugins for the bot from their repos, as well as from some built-in repos that Errbot maintainer gbin collects. For example:

    botname repos install https://github.com/mayflower/errbot-alerrtmanagerr

    botname repos install https://github.com/swarmstack/errbot-promql

    botname plugin config PromQL
    botname plugin config PromQL {'PROMQL_URL': 'http://tasks.prometheus:9090/api/v1'}

## SWARMSTACK USERS

If you are a [swarmstack](https://github.com/swarmstack/swarmstack) user, start here instead. The docker-compose stack below can instead be deployed to automatically join the Errbot container to the _swarmstack_net_ network and use the same persistent storage settings.

```
cd /usr/local/src
git clone https://github.com/swarmstack/errbot-docker
cd errbot-docker
vi config.py 
docker stack deploy -c docker-compose-swarmstack.yml errbot
```

After performing these commands, you'll need to follow the CONFIGURATION section (above) with the bot via direct channel on your social network client. This will configure the Webserver and install the alerrtmanagerr webhook receiver plugin to Errbot, in order to receive Alertmanager webhooks. You'll also install the PromQL plugin to run queries against your Prometheus instance. The commands should all run as documented above.

## CISCO WEBEX TEAMS

For help with the Cisco Webex Teams backend, see [https://github.com/marksull/err-backend-cisco-webex-teams](https://github.com/marksull/err-backend-cisco-webex-teams) for config.py parameters.

To configure the bot you will need a Bot TOKEN. If you don't already have a bot setup on Cisco Webex Teams, details can be found here: [https://developer.webex.com/bots.html](https://developer.webex.com/bots.html)

```
cd /usr/local/src
git clone https://github.com/swarmstack/errbot-docker
cd errbot-docker
vi config.py  # BACKEND: 'CiscoWebexTeams' and your BOT_IDENTITY{TOKEN}
docker stack deploy -c docker-compose.yml errbot
#  OR
docker stack deploy -c docker-compose-swarmstack.yml errbot
```

## ALERTMANAGER CONFIGURATION FOR PROMETHEUS

Configure a webhook in your Alertmanager.yml to something like:

```
route:
  receiver: 'first-responders'
receivers:
  - name: 'first-responders'
    #email_configs:  # optional multiple targets per receiver
    #  - to: 'user@example.com'
    #    send_resolved: false
    #    from: 'no-reply@example.com'
    #    smarthost: 'outbound.example.com:25'
    webhook_configs:
      - send_resolved: false
        url: http://errbot:3141/alerrt/example-user/domain.com/
```
See [Alertmanager Configuration](https://prometheus.io/docs/alerting/configuration/) for syntax

[swarmstack](https://github.com/swarmstack/swarmstack) users should configure this in alertmanger/conf/alertmanager.yml
