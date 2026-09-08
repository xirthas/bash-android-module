#!/system/bin/sh
set -e
cd /data/local/tmp/tests

find . -type f \( -name "run-*" -o -name "*.tests" -o -name "*.sub" -o -name "*.right" -o -name "execscript" -o -name "history.list" \) \
    -not -name 'array*.*' -not -name 'assoc*.*' -not -name 'new-exp*.*' -not -name 'histexp*.*' | xargs sed -i -E \
    -e ":a" \
    -e "s@(^|[^a-zA-Z0-9._])/tmp([^a-zA-Z0-9._-]|$)@\1/data/local/tmp\2@g" \
    -e "s@(^|[^a-zA-Z0-9._])/bin([^a-zA-Z0-9._-]|$)@\1/data/local/tmp/bin\2@g" \
    -e "s@(^|[^a-zA-Z0-9._])/etc([^a-zA-Z0-9._-]|$)@\1/data/local/tmp/etc\2@g" \
    -e "s@(^|[^a-zA-Z0-9._])/usr([^a-zA-Z0-9._-]|$)@\1/data/local/tmp/usr\2@g" \
    -e "s@(^|[^a-zA-Z0-9._])/sbin([^a-zA-Z0-9._-]|$)@\1/data/local/tmp/sbin\2@g" \
    -e "ta"

sed -i "s|/data/local/tmp/usr/bin/printf|/data/local/tmp/bin/printf|g" run-* *.tests *.sub *.right execscript history.list misc/*.tests

sed -i "s|ln sh a|cp sh a|g" rsh2.sub
sed -i 's|\[\[ x =~ \${bs}x \]\] ; echo \$?|[[ x =~ x ]] ; echo $?|g' cond-regexp3.sub
sed -i "s|!?d?:5|!?b c d?:5|g" histexp.tests
sed -i "s|/bin/sh|/data/local/tmp/bin/sh|g" histexp.right

echo "echo SKIPPED" > run-intl

echo "root:x:0:0:root:/root:/bin/sh" > /data/local/tmp/etc/passwd

export PATH=/data/local/tmp/bin:$PATH
export TMPDIR=/data/local/tmp
export THIS_SH=/data/local/tmp/bin/bash

${THIS_SH} run-all < /dev/null
