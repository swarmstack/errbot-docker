# errbot-alerrtmanagerr
Get alerts from Prometheus Alertmanager via webhooks

Errbot Webserver plugin has to be configured first.
Configuration of this plugin is done using the webhook itself: `/alerrt/<recipient>/<server>/`

Add URLs like this to your Alertmanager webhook_configs:

    MUC: "http://your.errbot.host:3141/alerrt/roomname/conference.jabberserver.org"
    Direct message: "http://your.errbot.host:3141/alerrt/username/jabberserver.org"
