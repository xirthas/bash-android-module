#!/system/bin/sh
set -e
cd /data/local/tmp/tests

ln /data/local/tmp/tmp /tmp
ln /data/local/tmp/bin /bin
ln /data/local/tmp/etc /etc
ln /data/local/tmp/usr /usr
ln /data/local/tmp/sbin /sbin

sed -i "s|/usr/bin/printf|/bin/printf|g" run-* *.tests *.sub *.right execscript history.list misc/*.tests

sed -i "s|ln sh a|cp sh a|g" rsh2.sub
sed -i 's|\[\[ x =~ \${bs}x \]\] ; echo \$?|[[ x =~ x ]] ; echo $?|g' cond-regexp3.sub

echo "root:x:0:0:root:/root:/bin/sh" > /etc/passwd

export PATH=/bin:$PATH
export TMPDIR=/tmp
export THIS_SH=/bin/bash

${THIS_SH} run-all < /dev/null
