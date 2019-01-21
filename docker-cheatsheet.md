# Docker cheatsheet

This is my own cheatsheet to using Docker, your mileage will vary.

I got a lot of value from [this Docker course published on Udemy](https://www.udemy.com/docker-for-professionals-the-practical-guide/): it consists of 8 hours of video, across 13 sections, it provides a lot more context than I bothered below.

## Builds

From `/alpython/Dockerfile`:

    # Demonstrate installing Python in Alpine Linux.
    FROM alpine

    # Set environment variables(s) all at once; i.e., within a single layer.
    ENV NAME="Alpython" VERSION="0.1"

    # Add metadata to this image.
    LABEL base.version=$VERSION

    # Run this container as a non-root user (worker).
    RUN addgroup -g 3000 -S worker \
        && adduser -G worker -S worker

    # Install Python.
    RUN apk update \
        && apk add python

    # Execute "python -v" at run time.
    CMD ["-v"]
    ENTRYPOINT ["python"]

Build the `alpython` image; i.e., Alpine + Python:

    $ docker build -q -t alpython:0.1 .
    sha256:80df45761397e7391ddfa50903fab79b09b0ab398feb6fd9f67663bf1e7bdf83
    $ docker run -it --rm alpython
    .
    .
    .
    >>> print "hi"
    hi

## Images

Pull alpine off [Docker Hub](https://hub.docker.com/):

    $ docker pull alpine:latest
    latest: Pulling from library/alpine
    Digest: sha256:46e71df1e5191ab8b8034c5189e325258ec44ea739bba1e5645cff83c9048ff1
    Status: Downloaded newer image for alpine:latest

Search [Quay](https://quay.io) for alpine:

    $ docker search quay.io/alpine

Search for a named image:

    $ docker search mysql
    NAME                                   DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
    alpine                                 A minimal Docker image based on Alpine Linux…   4844                [OK]                

List local images:

    $ docker images
    REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
    alpine                     latest              3f53bb00af94        2 weeks ago         4.41MB

Extract `alpine` into a file:

    $ docker save -o foo.tar alpine
    $ tar -xvf foo.tar
    x 3f53bb00af943dfdf815650be70c0fa7b426e56a66f5e3362b47a129d57d5991.json
    x a21b1050952cdc06771df49f52bd43b9adff41216b0ea39dbef0157cae64904b/
    x a21b1050952cdc06771df49f52bd43b9adff41216b0ea39dbef0157cae64904b/VERSION
    x a21b1050952cdc06771df49f52bd43b9adff41216b0ea39dbef0157cae64904b/json
    x a21b1050952cdc06771df49f52bd43b9adff41216b0ea39dbef0157cae64904b/layer.tar
    x manifest.json
    x repositories

Load from `foo.tar`:

    $ docker load -i foo.tar
    Loaded image: alpine:latest

Remove images:

    $ docker rmi alpine
    Untagged: alpine:latest
    Untagged: alpine@sha256:46e71df1e5191ab8b8034c5189e325258ec44ea739bba1e5645cff83c9048ff1
    Deleted: sha256:3f53bb00af943dfdf815650be70c0fa7b426e56a66f5e3362b47a129d57d5991

Determine changes made to a named container. Envvars will not show up in `docker diff`, though:

    $ docker run -e foo=bar -it --name baz alpine
    # echo $foo; touch qux; exit
    $ docker diff baz
    A /qux
    C /root
    A /root/.ash_history

Save a container as an image, including any envvars:

    $ docker commit -a "@waynekhan" -m "Did whatever" baz quux; docker images; docker run --entrypoint "env" -it qux
    sha256:101930a0d7942c25da0731d4f178fc16dcf50c32c77f4ffab8e5347335dfd56c
    REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
    qux                        latest              15ffe47acde9        1 second ago        4.41MB
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    HOSTNAME=c18d31a4084c
    TERM=xterm
    foo=bar
    HOME=/root

## Containers

Create a non-running container:

    $ docker create alpine echo "foo"
    30e3fc0dc6247bc731fb1eba4960c76556a0465594ad5661c5ae8aed263d7ac8

Start an identified (CID) container:

    $ docker start 30
    30

Stop a named container:

    $ docker stop foo
    foo

Restart a named container; i.e., `stop` then `start`:

    $ docker restart foo
    foo
    foo

_Always_ restart a container:

    $ docker run --restart=always alpine date
    Tue Jan  8 10:05:45 UTC 2019
    $  docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                        PORTS               NAMES
    0ca2a7b41947        alpine              "date"              4 seconds ago       Restarting (0) 1 second ago                       sleepy_dubinsky
    $ docker logs -f 0c
    Tue Jan  8 10:05:45 UTC 2019
    Tue Jan  8 10:05:47 UTC 2019
    Tue Jan  8 10:05:49 UTC 2019
    Tue Jan  8 10:05:51 UTC 2019
    Tue Jan  8 10:05:53 UTC 2019
    Tue Jan  8 10:05:56 UTC 2019

Never restart a container (default):

    $ docker run --restart=no alpine date
    Tue Jan  8 10:05:45 UTC 2019
    $  docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                        PORTS               NAMES
    16d7f6c10ad1        alpine              "date"              4 seconds ago        Exited (0) 2 seconds ago                            elated_goldberg
    $ docker logs -f 16
    Tue Jan  8 10:07:03 UTC 2019

Restart a container up to 3 times upon failure (i.e., exited with a non-zero status):

    $ docker run --restart=on-failure:3 alpine date
    Tue Jan  8 10:08:38 UTC 2019
    $ docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS                          PORTS               NAMES
    94b83aeea891        alpine              "date"              3 seconds ago        Exited (0) 1 second ago                             mystifying_swanson

Restart a container unless it was explicitly `stop`-ped:

    $ docker run --restart=unless-stopped alpine date
    Tue Jan  8 10:10:29 UTC 2019
    $ docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS                          PORTS               NAMES
    5bb996be2367        alpine              "date"              5 seconds ago        Restarting (0) 1 second ago                         sleepy_fermat
    $ docker logs -f 5b
    Tue Jan  8 10:10:29 UTC 2019
    Tue Jan  8 10:10:32 UTC 2019
    Tue Jan  8 10:10:34 UTC 2019
    Tue Jan  8 10:10:36 UTC 2019
    Tue Jan  8 10:10:38 UTC 2019
    Tue Jan  8 10:10:41 UTC 2019
    Tue Jan  8 10:10:45 UTC 2019
    Tue Jan  8 10:10:53 UTC 2019
    Tue Jan  8 10:11:07 UTC 2019
    Tue Jan  8 10:11:34 UTC 2019

Inspect a container:

    $ docker inspect ed
    [
        {
            "Id": "ed0626c009f57ca80e77452ec53473d0d486a4642ee990c18d33547e855ad8c7",
            "Created": "2019-01-08T09:22:46.1999707Z",
            "Path": "echo",
            "Args": [
                "foo"
            ],
            "State": {
                "Status": "exited",
                "Running": false,
                "Paused": false,
                "Restarting": false,
                "OOMKilled": false,
                "Dead": false,
                "Pid": 0,
                "ExitCode": 0,
                "Error": "",
                "StartedAt": "2019-01-08T09:22:58.1220902Z",
                "FinishedAt": "2019-01-08T09:22:58.2006933Z"
            },
        }
        .
        .
        .
    ]

Fetch the logs of a container:

    $ docker logs ed
    foo

Follow log output of a container:

    $ docker logs -f ed
    foo

Run a container in the background, saving its CID to a file:

    $ docker run --cidfile=alpine.cid -d alpine
    b454f417b350d155cabcda2d385b1d64c5e31824e8434764454af9ed019673be
    $ cat .\alpine.cid
    b454f417b350d155cabcda2d385b1d64c5e31824e8434764454af9ed019673be

List all containers:

    $ docker ps -a

List running containers only:

    $ docker ps

List filtered containers only:

    $ docker ps -a -f name=foo

Remove a named container:

    $ docker rm foo
    foo

Removed a name container, plus any associated volumes it uses exclusively:

    $ docker rm -v foo
    foo

Run `echo` in a container:

    $ docker run -d alpine echo "foo"
    70fc6f6680a04e56adf85012e3fe60c4deb23ab719b72f050807e801df289760
    $ docker logs 70
    foo

Override the default entry point with `echo` (as opposed to `sh -c`):

    $ docker run -it --entrypoint="echo" alpine foo
    foo
    $ docker run -it alpine foo
    Error response from daemon: OCI runtime create failed: container_linux.go:348: starting container process caused "exec: \"foo\": executable file not found in $PATH": unknown.

Run a container interactively:

    $ docker run -it alpine
    # echo foo
    foo
    # exit
    $ docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS                          PORTS               NAMES
    a713cd8c210d        alpine              "/bin/sh"           8 seconds ago        Exited (0) 4 seconds ago                            tender_almeida

Remove a container upon its exit:

    $ docker run -it --rm alpine echo "foo"
    foo
    $ docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS                          PORTS               NAMES

Run an explicitly named container:

    $ docker run -d --name foo alpine
    dbf6c490ceb53f89e0971672bf8b7e3924ce75a566e4274332c7dda0f2030f81

Run a container, preventing writes to its filesystem:

    $ docker run --read-only --rm alpine touch /tmp/foo
    touch: /tmp/foo: Read-only file system

Run a container, allowing writes to `/tmp` only:

    $ docker run --read-only -v /tmp alpine touch /tmp/foo
    $ docker volume ls
    DRIVER              VOLUME NAME
    local               e5dd4aa297d7a7aaeac4133133b2fc5fd65293a22a23d4479394c5b623970b49

Pass environment variables to a container:

    $ docker run -e HOSTNAME=foo --rm alpine env
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    HOSTNAME=foo
    HOME=/root

Mount the current directory in a container:

    $ docker run -it -v ${PWD}:/mnt --rm -w /mnt alpine ls
    main.tf

`Kill` PID 1 in a named container doesn't actually stop it:

    $ docker run -d --name foo alpine tail -f /dev/null
    7cefd4a60e145d4ea5c965aa2c6975f5072c5031855b870ca9cc13ed3af56ae7
    $ docker exec foo kill -9 1
    $ docker exec foo ps -aef
    PID   USER     TIME  COMMAND
        1 root      0:00 tail -f /dev/null
        6 root      0:00 ps -aef

## Networks

https://docs.docker.com/network/

Create a closed container; i.e., no access to the outside world:

    $ docker run -it --net none alpine
    # ping google.com

Created a bridged (i.e., networked) container:

    $ docker run -it --net bridge alpine
    # ping google.com
    PING google.com (172.217.24.110): 56 data bytes
    64 bytes from 172.217.24.110: seq=0 ttl=37 time=4.909 ms

Override the default hostname of a container:

    $ docker run -it --hostname foo --rm alpine
    # hostname
    foo

Specify the DNS server(s) for a container to perform a name server lookup:

    $ docker run -it --dns 1.1.1.1 --rm alpine nslookup www.apple.com.
    Name:      www.apple.com
    Address 1: 23.76.232.87 a23-76-232-87.deploy.static.akamaitechnologies.com
    Address 2: 2600:1413:1:4b5::1aca
    g2600-1413-0001-04b5-0000-0000-0000-1aca.deploy.static.akamaitechnologies.com

Negate the need to use FQDNs:

    $ docker run -it --dns 1.1.1.1 --dns-search google.com --rm alpine nslookup www
    Name:      www
    Address 1: 74.125.24.99
    Address 2: 74.125.24.103
    Address 3: 74.125.24.104
    Address 4: 74.125.24.105
    Address 5: 74.125.24.106
    Address 6: 74.125.24.147
    Address 7: 2404:6800:4003:c02::67 sc-in-x67.1e100.net

Override the DNS resolution of a FQDN:

    $ docker run -it --add-host www.apple.com.:127.0.0.1 --dns 1.1.1.1 --rm alpine nslookup www.apple.com.
    Name:      www.apple.com.
    Address 1: 127.0.0.1 localhost

Forward a random port to container port 80:

    $ docker run -d -p 80 --name foo --rm httpd
    b0593ddcfbff392ed8b0deb940ff4ccae3ebfaee987eb4d9251cc44d6a8bbcfe
    $ docker port foo
    80/tcp -> 0.0.0.0:32772

Forward port 8080 to container port 80:

    $ docker run -d -p 8080:80 --name foo --rm httpd
    7916a59df1098c057c279535d17ab467059bdf8fa7357420e286617b9e2f6ee8
    $ docker port foo
    80/tcp -> 0.0.0.0:8080

Forward localhost's port 8080 to container port 80:

    $ docker run -d -p 127.0.0.1:80:8080 --name foo --rm httpd
    4939779cbc4030ce79716e029cf4471af631f68917ebe77cb6046b56da7a033f
    $ docker port foo
    8080/tcp -> 127.0.0.1:80

Join the networks of two containers:

    $ docker run -d --name foo --net none --rm httpd
    04faf319e4e431e977334a22e9be3d3a34e6580c3be0118d20e1fb044c174320
    $ docker run -it --name bar --net container:foo --rm alpine netstat -an
    Active Internet connections (servers and established)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       
    tcp        0      0 :::80                   :::*                    LISTEN      
    Active UNIX domain sockets (servers and established)
    Proto RefCnt Flags       Type       State         I-Node Path

Use host networking:

    $ docker run -d --name foo --net host --rm httpd

Link two named containers:

    $ docker run -d --name maker alpine tail -f /dev/null
    3803ed25dd99a7a4154931616dc5b72b2375076f9b1d5a97dc637f3fa6387dd0
    $ docker run -it --link maker --name checker alpine
    # grep maker /etc/hosts
    172.17.0.2      maker 3803ed25dd99
    # ping maker
    PING maker (172.17.0.2): 56 data bytes
    64 bytes from 172.17.0.2: seq=0 ttl=64 time=0.080 ms
    ^C
    --- maker ping statistics ---
    1 packets transmitted, 1 packets received, 0% packet loss
    round-trip min/avg/max = 0.080/0.080/0.080 ms

Expose a container port to other containers only:

    $ docker run -d --expose 11011 --name foo --rm alpine nc -l 0.0.0.0:11011
    15a9ad17bd01625364c41d332a92243673a3957c3220d97afc5cb1c30021172e
    $ docker run -it --link foo --name bar --rm alpine env
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    HOSTNAME=a8de7d549970
    TERM=xterm
    FOO_PORT=tcp://172.17.0.2:11011
    FOO_PORT_11011_TCP=tcp://172.17.0.2:11011
    FOO_PORT_11011_TCP_ADDR=172.17.0.2
    FOO_PORT_11011_TCP_PORT=11011
    FOO_PORT_11011_TCP_PROTO=tcp
    FOO_NAME=/bar/foo
    HOME=/root    

## Bind mounts

https://docs.docker.com/storage/bind-mounts/

Mount the host's working directory as `/mnt` in a container:

    $  docker run -it --rm -v ${PWD}:/mnt alpine ls /mnt
    Applications   Downloads      Music          sandbox
    Desktop        Library        Pictures
    Documents      Movies         Public

## Volumes

https://docs.docker.com/storage/volumes/

Create a managed volume and mount it as `/mnt`:

    $ docker run -d --name foo -v /mnt -w /mnt alpine touch foo
    6335742cfba0e0864adc34aa56343e25622d388996a1282cd88c3850db177b21

Create a managed volume and mount it as (read-only) `/mnt`:

    $ docker run -d -v /mnt:/mnt:ro -w /mnt alpine touch foo
    94456855c4cff94aaa739fb5d985e4ffde301791a79ef01300c268ef77f8c7c2
    $ docker logs 94
    touch: foo: Read-only file system

Filter for managed volumes for a named container:

    $ docker inspect -f "{{json .Mounts}}" foo
    [{"Type":"volume","Name":"00dfb452cdc3d77af2f9bbd2f3a0f3ac9a70455f1fef7c71b318244720e3f651","Source":"/var/lib/docker/volumes/00dfb452cdc3d77af2f9bbd2f3a0f3ac9a70455f1fef7c71b318244720e3f651/_data","Destination":"/mnt","Driver":"local","Mode":"","RW":true,"Propagation":""}]

Reuse all volumes from a named container, retaining the _same mode and mountpoints_ as its source:

    $ docker run -d --rm --volumes-from foo -w /mnt alpine touch bar
    64fcfc23b3e87e4a79dc3ba48fbcf1242d76d990af47b26cf8ad0357b4631a6d
    $ docker run -d --volumes-from foo -w /mnt alpine ls -l
    304e6990daf2b4cf7238a058fef01cbdd647e576e80d6ea7eb9a34567a08ccd4
    $ docker logs 30
    total 0
    -rw-r--r--    1 root     root             0 Jan 10 05:25 bar
    -rw-r--r--    1 root     root             0 Jan 10 05:25 foo

List volumes:

    $ docker volume ls
    DRIVER              VOLUME NAME
    local               9308fe3116b64e1733d9601c3f06deb41b852d86a203a70927c9477cf00a4d21

Remove a volume:

    $ docker volume rm 9308fe3116b64e1733d9601c3f06deb41b852d86a203a70927c9477cf00a4d21
    9308fe3116b64e1733d9601c3f06deb41b852d86a203a70927c9477cf00a4d21

## Constraints

https://docs.docker.com/config/containers/resource_constraints/

Assign a (soft) memory allowance:

    $ docker run -it -m 512m --rm alpine

Assign a (soft) CPU limit at twice and thrice of default respectively:

    $ docker run -d --cpu-shares 2048 --name foo --rm alpine sleep 86400
    $ docker run -d --cpu-shares 3064 --name bar --rm alpine sleep 86400

Assign the first (zeroth) CPU(s):

    $ docker run -d --cpuset-cpus 0 --name foo --rm alpine sleep 86400

Assign an unavailable CPU(s):

    $ docker run -d --cpuset-cpus 2 --name bar --rm alpine sleep 86400
    Error response from daemon: Requested CPUs are not available - requested 2, available: 0-1.

Assign two available CPU(s):

    $ docker run -d --cpuset-cpus 0-1 --name baz --rm alpine sleep 86400

Identify the OS user for a named container (i.e., `root`):

    $ docker run -d --name qux --rm alpine sleep 86400
    2c1724642ba230ef187dca8a5b20f01b26cc1e6ba5036edf5f4222fa05722e20
    $ docker inspect -f "{{json .Config.User}}" qux
    ""

Identify available OS users to [run a container image](https://medium.com/@oprearocks/how-to-properly-override-the-entrypoint-using-docker-run-2e081e5feb9d):

    $ docker run -it --entrypoint "cat" --rm alpine /etc/passwd
    root:x:0:0:root:/root:/bin/ash
    bin:x:1:1:bin:/bin:/sbin/nologin
    daemon:x:2:2:daemon:/sbin:/sbin/nologin
    adm:x:3:4:adm:/var/adm:/sbin/nologin
    lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
    sync:x:5:0:sync:/sbin:/bin/sync
    shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
    halt:x:7:0:halt:/sbin:/sbin/halt
    mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
    news:x:9:13:news:/usr/lib/news:/sbin/nologin
    uucp:x:10:14:uucp:/var/spool/uucppublic:/sbin/nologin
    operator:x:11:0:operator:/root:/bin/sh
    man:x:13:15:man:/usr/man:/sbin/nologin
    postmaster:x:14:12:postmaster:/var/spool/mail:/sbin/nologin
    cron:x:16:16:cron:/var/spool/cron:/sbin/nologin
    ftp:x:21:21::/var/lib/ftp:/sbin/nologin
    sshd:x:22:22:sshd:/dev/null:/sbin/nologin
    at:x:25:25:at:/var/spool/cron/atjobs:/sbin/nologin
    squid:x:31:31:Squid:/var/cache/squid:/sbin/nologin
    xfs:x:33:33:X Font Server:/etc/X11/fs:/sbin/nologin
    games:x:35:35:games:/usr/games:/sbin/nologin
    postgres:x:70:70::/var/lib/postgresql:/bin/sh
    cyrus:x:85:12::/usr/cyrus:/sbin/nologin
    vpopmail:x:89:89::/var/vpopmail:/sbin/nologin
    ntp:x:123:123:NTP:/var/empty:/sbin/nologin
    smmsp:x:209:209:smmsp:/var/spool/mqueue:/sbin/nologin
    guest:x:405:100:guest:/dev/null:/sbin/nologin
    nobody:x:65534:65534:nobody:/:/sbin/nologin

Running `alpine` as `nobody:nobody`:

    $ docker run -it --entrypoint "id" --user nobody:nobody alpine
    uid=65534(nobody) gid=65534(nobody)
