#!sh
set -e;
#
# VA
#
rclone copy src://identity-enc-models-public/models/6478fcb410dcce6d3b037199 /models/6478fcb410dcce6d3b037199 -vv;
if [ ! -d /models/6478fcb410dcce6d3b037199 ]; then echo 'failed to clone model 6478fcb410dcce6d3b037199'; exit 1; fi;
echo '6478fcb410dcce6d3b037199 downloaded';

#
# Standard
#
rclone copy src://identity-enc-models-public/models/667a8f0b76c3ea3a32fcd565 /models/667a8f0b76c3ea3a32fcd565 -vv;
if [ ! -d /models/667a8f0b76c3ea3a32fcd565 ]; then echo 'failed to clone model 667a8f0b76c3ea3a32fcd565'; exit 1; fi;
echo '667a8f0b76c3ea3a32fcd565 downloaded';
rclone copy src://identity-enc-models-public/models/6684168e04248f708c1e0c93 /models/6684168e04248f708c1e0c93 -vv;
if [ ! -d /models/6684168e04248f708c1e0c93 ]; then echo 'failed to clone model 6684168e04248f708c1e0c93'; exit 1; fi;
echo '6684168e04248f708c1e0c93 downloaded';