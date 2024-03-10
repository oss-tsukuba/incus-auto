#!/bin/sh
set -xeu
status=1
PROG=$(basename $0)
trap '[ $status = 0 ] && echo Done || echo NG: $PROG; \
	gfrm -f $TFILE; exit $status' 0 1 2 15

GFSD1=gfsd01.example.org
GFSD2=gfsd02.example.org

TFILE=/tmp/corrupted-file
#ENV="GFARM_TEST_MDS2=c6:601 GFARM_TEST_MDS3=c7:601 \
#	GFARM_TEST_MDS4=c8:601 GFARM_TEST_CKSUM_MISMATCH=$TFILE"
ENV="GFARM_TEST_CKSUM_MISMATCH=$TFILE"
export $ENV

DISTDIR=$PWD

#grid-proxy-init -q || :

gfmkdir -p /tmp
gfchmod 1777 /tmp || :

TOP=~/gfarm
#BUILD=$TOP/build
BUILD=$TOP
MAKE=$TOP/makes/make.sh
cd $BUILD/regress
$MAKE all > /dev/null

create_mismatch_file()
{
	FILE1=server/gfmd/.libs/gfmd
	gfreg -h $GFSD1 ../$FILE1 $TFILE
	gfrep -qD $GFSD2 $TFILE
	for h in  $GFSD1 $GFSD2; do
		echo -n XXX | ssh $h sudo dd conv=notrunc \
			of=/var/gfarm-spool/$(gfspoolpath $TFILE)
	done
}

create_gfmd_restart_all()
{
	mkdir -p bin
	cat <<EOF > bin/gfmd_restart_all
#!/bin/sh
gfmdhost | gfarm-prun -a -p -h - sudo systemctl restart gfmd
EOF
	chmod +x bin/gfmd_restart_all
}

update_gfarm2rc()
{
	[ -f ~/.gfarm2rc ] || touch ~/.gfarm2rc
	cp -p ~/.gfarm2rc ~/.gfarm2rc.bak
	awk '/^client_digest_check/ { next } \
	     { print } \
	     END { print "client_digest_check enable" }' ~/.gfarm2rc.bak \
	     > ~/.gfarm2rc
}

create_gfmd_restart_all

update_gfarm2rc
scp -p ~/.gfarm2rc $GFSD1:

AUTH=$(gfhost -lv | head -1 | awk '{ print $2 }')
DIST=$(grep ^ID= /etc/os-release | sed 's/ID="*\([a-z]*\)"*/\1/')
DATE=$(date +%F.%H_%M_%S)
LOG1=log.rm-root.$AUTH.$DIST.$DATE
LOG2=log.lc-user.$AUTH.$DIST.$DATE

create_mismatch_file
gfsudo $MAKE REGRESS_ARGS="-l $LOG1" check

create_mismatch_file
ssh $GFSD1 "(grid-proxy-init -q; cd gfarm/regress &&
	$ENV $MAKE REGRESS_ARGS='-l $LOG2' check)"

scp -p $GFSD1:gfarm/regress/$LOG2 .
$TOP/regress/addup.sh $LOG1 $LOG2 | egrep '(UNSUPPORTED|FAIL)'

realpath $LOG1
realpath $LOG2

status=0
