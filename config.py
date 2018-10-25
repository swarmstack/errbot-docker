import logging

# This is a minimal configuration to get you started with the Text mode.
# If you want to connect Errbot to chat services, checkout
# the options in the more complete config-template.py from here:
# https://raw.githubusercontent.com/errbotio/errbot/master/errbot/config-template.py

AUTOINSTALL_DEPS = True
#BACKEND = 'XMPP'
BOT_DATA_DIR = r'/src/data'
BOT_EXTRA_PLUGIN_DIR = r'/src/plugins'
BOT_LOG_FILE = r'/src/errbot.log'
BOT_LOG_LEVEL = logging.INFO
WAIT=10

BOT_ADMINS='you@example.com'  # !! Don't leave that to "@CHANGE_ME" if you connect your errbot to a chat system !!
BOT_IDENTITY = { 'TOKEN': 'YzUwNzZlTEtZVkOC00YTc3LThNTYTEwMzU3MI3Mexamplek3N2MMTcw', }
CHATROOM_PRESENCE=('YGzvL3L1JPT0Y2VhMDmZTAtYjJiMyxMWU3LWmY2MtexampleOGE2OGMwYjZj',)

