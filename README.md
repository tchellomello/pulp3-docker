# pulp3-docker
This is an still **development** project to run Pulp v3 on a docker compose/swarm environment using a loadbalancer. 

To run the project, make sure you have working Docker and that you installed the `docker-compose` software. 

** Checkout the repository:

```bash
$ git clone https://github.com/tchellomello/pulp3-docker.git
```

** Start the docker-compose
```bash
$ cd pulp3-docker
$ docker-compose -p pulpv3 up
```
** To test, open a console to one running worker
```bash
$ docker exec -it pulpv3_worker_1 /bin/bash
bash-4.4# psql -h pgsql -U pulp
Password for user pulp: 
psql (10.4)
Type "help" for help.

pulp=# select * from pulp_app_worker ;
                  id                  |            created            |         last_updated          |                    name                     |        last_heartbeat         | gracefully_stopped | cleaned_up 
--------------------------------------+-------------------------------+-------------------------------+---------------------------------------------+-------------------------------+--------------------+------------
 6deeb82e-ce4b-4c24-b1ef-88aa68fda053 | 2018-07-18 20:34:28.81905+00  | 2018-07-18 20:34:28.819073+00 | reserved_resource_worker_17515@67ad6fc825e4 | 2018-07-18 20:34:58.971157+00 | f                  | f
 8c18a5ba-a14d-4756-bae7-8ef797ea6c0f | 2018-07-18 20:34:27.005369+00 | 2018-07-18 20:34:27.005395+00 | reserved_resource_worker_14228@2b61a699f734 | 2018-07-18 20:35:12.212595+00 | f                  | f
(2 rows)
```


** Note that the port 80 on the host is being loadbalanced but for troubleshooting, the port 8000 is also published bypassing the loadbalancer. To test it:

```bash
# via loadbalancer
$ curl -H Host:worker.example.com http://127.0.0.1

# bypassing 
$ curl http://127.0.0.1:8000
```