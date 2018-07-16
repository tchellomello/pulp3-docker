#!/usr/bin/env bash

exec rq worker -n 'resource_manager@%h' -w 'pulpcore.tasking.worker.PulpWorker'
