## swarmstack/errbot-docker

Docker image for [Errbot](http://errbot.io), a chat-bot designed to be easily deployable, extensible and maintainable.

[https://hub.docker.com/r/swarmstack/errbot-docker/](https://hub.docker.com/r/swarmstack/errbot-docker/)

Errbot 6.1.7 using [python:3.9.1-alpine3.12](https://hub.docker.com/_/python) container - Functions as a vanilla Errbot with it's available backends, plus optional Cisco Webex Teams backend (1.6.0) support. Support for other community-provided backends.  Plugins can be installed and configured via the bot. [swarmstack](https://github.com/swarmstack/swarmstack) users should begin at the SWARMSTACK USERS section.

The documentation below focuses on installing Errbot for use as a webhook receiver for Prometheus Alertmanager and adding Prometheus ChatOps to the bot, but the image is generally useful as a working Errbot with support for installing other Errbot plugins and backends.

---

## RUN ERRBOT AS A CONTAINER AND CONNECT TO TERMINAL

To simply deploy Errbot in interactive _Text_ mode:

```
cd /usr/local/src
git clone https://github.com/swarmstack/errbot-docker
cd errbot-docker
docker run -it swarmstack/errbot-docker
```

---

## RUN ERRBOT AS A DETACHED CONTAINER

To expose the Errbot webhook network port and connect Errbot to your configured backend social network, set BACKEND in config.py and also any parameters that backend requires (generally in the form of BOT_CONFIG values) before starting the bot. Refer to the Errbot [User Guide](http://errbot.io/en/latest/user_guide/setup.html#id1) for parameters required for your specific built-in Errbot backend, or the section below for Cisco Webex Teams users.

```
vi config.py
docker run -d --entrypoint errbot -p 3141:3141 -v `pwd`:/err/local_config \
 swarmstack/errbot-docker -c /err/local_config/config.py
```

---

## RUN ERRBOT AS A STACK ON A DOCKER SWARM HOST

On a Docker swarm host (you can even _docker swarm init --advertise-addr 192.168.your.ip_ on a single host to enable it), perform the following commands. If you want Errbot data persisted to a different directory, be sure to change ./local_bind_volume_dir in docker-compose.yml below.

You should configure your social network of choice as BACKEND in config.py and configure it's parameters (generally in the form of BOT_CONFIG_ITEM values) before starting the bot. Refer to [Errbot BACKEND](http://errbot.io/en/latest/user_guide/setup.html#id1) for parameters required for your specific Errbot backend.

```
vi config.py
vi docker-compose.yml
docker stack deploy -c docker-compose.yml errbot
```

---

## ADDING YOUR OWN BACKEND

You can also add any local_plugins or local_backends to those directories before deploying above, although it's recommended to instead install plugins as documented in the CONFIGURATION section where possible; this way they will be persisted within the /err/data Docker volume.

Only if deploying as a container, make the following change(s) to config.py:

    BOT_EXTRA_PLUGIN_DIR = r'/err/local_config/local_plugins'

And if you need to install a custom backend, add and remove necessary local_backends directories and then change config.py to:

    BOT_EXTRA_BACKEND_DIR = r'/err/local_config/local_backends' 

If deploying as a stack, you don't need to make the changes above, but you'll instead need to update docker-compose.yml with your own local_plugins or local_backends files by uncommenting and altering both sets of commented configs examples. Docker configs have a limit of 512kbytes each. Consider only adding local_backends when needed using this method.

--- 
## CONFIGURATION

After starting the bot as a container or stack (above), start a direct conversation with the bot on the social network you configured the bot to use, and configure the bot's web server if you want the bot to able to receive webhooks, such as by the Alertmanager errbot-alerrtmanagerr plugin:

    plugin config Webserver
    plugin config Webserver {'HOST': '0.0.0.0',  'PORT': 3141}

You can install plugins for the bot from their repos, as well as from some built-in repos that Errbot maintainer gbin collects. For example:

    repos install https://github.com/mayflower/errbot-alerrtmanagerr
    # You can skip this repo if following the section for Cisco Webex Teams

    repos install https://github.com/swarmstack/errbot-promql

    plugin config PromQL
    plugin config PromQL {'PROMQL_URL': 'http://prometheus:9090/api/v1'}

---

## SWARMSTACK USERS

If you are a [swarmstack](https://github.com/swarmstack/swarmstack) user, start here instead. The docker-compose stack below can instead be deployed to automatically join the Errbot container to the _swarmstack_net_ network and use the same persistent storage settings.

```
cd /usr/local/src
git clone https://github.com/swarmstack/errbot-docker
cd errbot-docker
vi config.py 
docker stack deploy -c docker-compose-swarmstack.yml errbot
```

If you need to use a backend other than those already provided by [swarmstack/errbot-docker](https://github.com/swarmstack/errbot-docker), see ADDING YOUR OWN BACKENDS (above).

After performing these commands, you'll need to follow the CONFIGURATION section (above) with the bot via direct channel on your social network client. This will configure the Webserver and install the alerrtmanagerr webhook receiver plugin to Errbot, in order to receive Alertmanager webhooks. You'll also install the PromQL plugin to run queries against your Prometheus instance. The commands should all run as-documented for swarmstack users.

---

## CISCO WEBEX TEAMS

For help with the Cisco Webex Teams backend, see [https://github.com/marksull/err-backend-cisco-webex-teams](https://github.com/marksull/err-backend-cisco-webex-teams) for config.py parameters.

To configure the bot you will need a Bot TOKEN. If you don't already have a bot setup on Cisco Webex Teams, details can be found here: [https://developer.webex.com/bots.html](https://developer.webex.com/bots.html)

You'll need to make the following additional changes to config.py:

    BACKEND = 'CiscoWebexTeams'
    BOT_IDENTITY = { 'TOKEN': 'Your_Token', }

And use webhook URLs in your Alertmanager configuration such as:

```
url: http://errbot:3141/alerrt-webex/<example-user>/<domain.ext>/
url: http://errbot:3141/alerrt-webex-room/<room-name>/
```

A custom local_plugin/alerrtmanagerr-webex has been included in this image to handle the alerrt-webex and alerrt-webex-room webhook receivers above for Webex Teams users.

---
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
        url: http://errbot:3141/alerrt/<example-user>/<domain.ext>/
```
See [Alertmanager Configuration](https://prometheus.io/docs/alerting/configuration/) for syntax configuring Alertmanager webhooks.

The above configuration should work for [swarmstack](https://github.com/swarmstack/swarmstack) users  (_alertmanger/conf/alertmanager.yml_) and then re-deploy swarmstack.

If calling Errbot webhooks from your own Alertmanager servers, just change the _url: http://errbot_ above to the host IP where you are running this Errbot container. Change the example-user and domain.ext above to target a user on your social network.

If you want to have the bot instead send alerts into a room (rather than direct conversation with a user as in the above config), see [errbot-alerrtmanagerr](https://github.com/mayflower/errbot-alerrtmanagerr) for webhook URL examples when using the built-in Errbot backends.

