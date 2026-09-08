#!/bin/sh
set -e
cd /data/local/tmp/tests

ls -la /

sed -i 's|\[\[ x =~ \${bs}x \]\] ; echo \$?|[[ x =~ x ]] ; echo $?|g' cond-regexp3.sub

export PATH=/bin:$PATH
export TMPDIR=/tmp
export THIS_SH=/bin/bash

${THIS_SH} run-all < /dev/null
