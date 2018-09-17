```shell
LOCATION=/data/gfs
GNAME=gfs
GSERVER=server1
MOUNT_POINT=/mnt
```

* single node

```shell
sed -i "s|^127.0.0.1.*|& $GSERVER|m" /etc/hosts
mkdir -p $LOCATION
gluster volume create $GNAME $GSERVER:$LOCATION force
gluster volume start $GNAME
gluster volume info
gluster volume status $GNAME detail
```

* multiple node

```shell
gluster peer probe <new_server>
gluster peer status
...
gluster volume create $GNAME replica <num> $GSERVER1:$LOCATION $GSERVER2:$LOCATION force
```

* mount

```shell
mount -t glusterfs $GSERVER:/$GNAME $MOUNT_POINT
for i in `seq -w 1 100`; do cp -rp /var/log/kern.log $MOUNT_POINT/copy-test-$i; done
```
