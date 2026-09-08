#!/bin/sh
set -e
cd /tests

ls -la /

sed -i 's|\[\[ x =~ \${bs}x \]\] ; echo \$?|[[ x =~ x ]] ; echo $?|g' cond-regexp3.sub

export PATH=/bin:$PATH
export TMPDIR=/tmp
export THIS_SH=/bin/bash
export USER=shell
export HOME=/tmp

/usr/bin/su -p shell /bin/bash -c "export PATH=/bin:\$PATH; export TMPDIR=/tmp; export THIS_SH=/bin/bash; /bin/bash run-all < /dev/null"
