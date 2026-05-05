#!sh
set -e;
#
# VA
#
rclone copy src://identity-enc-models-public/models/6687ad3b04248f708c1e0c95 /models/6687ad3b04248f708c1e0c95 -vv;
if [ ! -d /models/6687ad3b04248f708c1e0c95 ]; then echo 'failed to clone model 6687ad3b04248f708c1e0c95'; exit 1; fi;
echo '6687ad3b04248f708c1e0c95 downloaded';