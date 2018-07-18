#!/usr/bin/env bash
worker_name=$(echo "reserved_resource_worker_$RANDOM@%h")
redis_url_string="redis://$PULP_REDIS_HOST:$PULP_REDIS_PORT"
rq worker --url "$redis_url_string" -n "$worker_name" -w 'pulpcore.tasking.worker.PulpWorker'
