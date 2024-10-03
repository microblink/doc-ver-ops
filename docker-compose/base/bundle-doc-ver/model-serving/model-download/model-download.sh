#!sh
set -e;
#
# VA
#
rclone copy src://identity-enc-models-public/models/6687ad3b04248f708c1e0c95 /models/6687ad3b04248f708c1e0c95 -vv;
if [ ! -d /models/6687ad3b04248f708c1e0c95 ]; then echo 'failed to clone model 6687ad3b04248f708c1e0c95'; exit 1; fi;
echo '6687ad3b04248f708c1e0c95 downloaded';

#
# Standard
#
rclone copy src://identity-enc-models-public/models/66e2b36788703787163f0ecf /models/66e2b36788703787163f0ecf -vv;
if [ ! -d /models/66e2b36788703787163f0ecf ]; then echo 'failed to clone model 66e2b36788703787163f0ecf'; exit 1; fi;
echo '66e2b36788703787163f0ecf downloaded';
rclone copy src://identity-enc-models-public/models/66b61951fb85edd8517b6af6 /models/66b61951fb85edd8517b6af6 -vv;
if [ ! -d /models/66b61951fb85edd8517b6af6 ]; then echo 'failed to clone model 66b61951fb85edd8517b6af6'; exit 1; fi;
echo '66b61951fb85edd8517b6af6 downloaded';