# Install for building RMM & OTA handler
TOOLCHAIN_TARGET_TASK += "\
   curl curl-dev \
   mosquitto mosquitto-dev \
   c-ares libbsd \
   libevent libevent-dev \
   jansson jansson-dev \
   "
