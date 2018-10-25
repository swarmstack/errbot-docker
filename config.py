import logging

# This is a minimal configuration to get you started with the Text mode.
# If you want to connect Errbot to chat services, checkout
# the options in the more complete config-template.py from here:
# https://raw.githubusercontent.com/errbotio/errbot/master/errbot/config-template.py

AUTOINSTALL_DEPS = True

BACKEND = 'CiscoWebexTeams'  # Errbot will start in text mode (console only mode) and will answer commands from there.

BOT_DATA_DIR = r'/src/data'
BOT_EXTRA_PLUGIN_DIR = r'/src/plugins'
BOT_EXTRA_BACKEND_DIR = r'/src/backends'
BOT_LOG_FILE = r'/err/errbot.log'
BOT_LOG_LEVEL = logging.INFO

BOT_PREFIX = 'c3po-test '
BOT_PREFIX_OPTIONAL_ON_CHAT = True
#BOT_ALT_PREFIXES = ('c3po','3po','bot','err','errbot','errbo',)
BOT_ALT_PREFIX_SEPARATORS = (':', ',', ';',)
BOT_ALT_PREFIX_CASEINSENSITIVE = True

BOT_PROMQL_URL = 'http://tasks.prometheus:9090/api/v1'

WAIT=10

BOT_ADMINS = ('mikhollo@cisco.com', )
#BOT_ADMINS = ('mikhollo@cisco.com', 'miwhitle@cisco.com', 'aaramamu@cisco.com', 'cbearman@cisco.com', 'rmcfarla@cisco.com', 'randajon@cisco.com', )

BOT_IDENTITY = {
    'TOKEN': 'YzUwNzZlOTEtZTVkOC00YTc3LThkNTYtYTEwMzU3MWI3M2YxYTZhNTk3N2MtMTcw',
}
