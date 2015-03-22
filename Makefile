.DEFAULT: _server
.PHONY: all server _server

#
# Targets
#

all: _server

server: _server

#
# Functions
#

_server:
	@ruby -run -ehttpd . -p8000
