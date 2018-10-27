import logging

# This is a minimal configuration to get you started with the Text mode.
# If you want to connect Errbot to chat services, checkout
# the options in the more complete config-template.py from here:
# https://raw.githubusercontent.com/errbotio/errbot/master/errbot/config-template.py

AUTOINSTALL_DEPS = True
BACKEND = 'Text'
BOT_DATA_DIR = r'/err/data'
BOT_EXTRA_PLUGIN_DIR = r'/err/local_plugins'
BOT_EXTRA_BACKEND_DIR = r'/err/local_backends'
BOT_LOG_FILE = r'/err/errbot.log'
BOT_LOG_LEVEL = logging.INFO
#BOT_ALT_PREFIXES = ('bot ' 'errbo ',)
#BOT_ALT_PREFIX_CASEINSENSITIVE = True
#BOT_ALT_PREFIX_SEPARATORS = (':', ',', ';',)
BOT_PREFIX = 'errbot '
#BOT_PREFIX_OPTIONAL_ON_CHAT = True  # default: False
WAIT=5

BOT_ADMINS='@CHANGE_ME'  # !! Don't leave that to "@CHANGE_ME" if you connect your errbot to a chat system !!
# BOT_IDENTITY = { 'TOKEN': 'YzUwNzZlTEtZVkOC00YTc3LThNTYTEwMzU3MI3Mexamplek3N2MMTcw', }
