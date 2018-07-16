#!/usr/bin/env bash
worker_name=$(echo "reserved_resource_worker_$RANDOM@%h")
exec rq worker -n "$worker_name" -w 'pulpcore.tasking.worker.PulpWorker'
