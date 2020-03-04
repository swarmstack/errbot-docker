from errbot import BotPlugin, webhook


class AlerrtmanagerrWebex(BotPlugin):
    """
    Get alerts from Prometheus Alertmanager via webhooks
    """

    @webhook('/alerrt-webex/<recipient>/<server>/')
    def alerrt(self, data, recipient, server):
        identifier = self.build_identifier(recipient + "@" + server)
        for alert in data['alerts']:
            if 'description' in alert['annotations']:
                title = alert['annotations']['description']
            else:
                title = alert['annotations']['message']
            self.send_card(
                to=identifier,
                summary='[{}] {}'.format(
                    data['status'].upper(),
                    alert['labels']['alertname']
                ),
                title=title,
            )

    @webhook('/alerrt-webex-room/<room>/')
    def alerrtt(self, data, room):
        identifier = self.query_room(room)
        for alert in data['alerts']:
            if 'description' in alert['annotations']:
                title = alert['annotations']['description']
            else:
                title = alert['annotations']['message']
            self.send_card(
                to=identifier,
                summary='[{}] {}'.format(
                    data['status'].upper(),
                    alert['labels']['alertname']
                ),
                title=title,
            )

# Alertmanager sends this JSON per https://prometheus.io/docs/alerting/configuration/#webhook_config
#{
#  "version": "4",
#  "groupKey": <string>,    // key identifying the group of alerts (e.g. to deduplicate)
#  "status": "<resolved|firing>",
#  "receiver": <string>,
#  "groupLabels": <object>,
#  "commonLabels": <object>,
#  "commonAnnotations": <object>,
#  "externalURL": <string>,  // backlink to the Alertmanager.
#  "alerts": [
#    {
#      "status": "<resolved|firing>",
#      "labels": <object>,
#      "annotations": <object>,
#      "startsAt": "<rfc3339>",
#      "endsAt": "<rfc3339>",
#      "generatorURL": <string> // identifies the entity that caused the alert
#    },
#    ...
#  ]
#}

