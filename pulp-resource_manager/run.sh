#!/usr/bin/env bash
redis_url_string="redis://$PULP_REDIS_HOST:$PULP_REDIS_PORT"
rq worker --url "$redis_url_string" -n 'resource_manager@%h' -w 'pulpcore.tasking.worker.PulpWorker'
