#!/bin/bash
  curl http://${APPNAME}-service.${DEVNS}.svc:${PORT}
return $?
