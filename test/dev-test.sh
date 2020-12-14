#!/bin/bash
  sleep 10 # Wait until the pod is initialized
  curl http://${APPNAME}-service.${DEVNS}.svc:${PORT}
exit $?
