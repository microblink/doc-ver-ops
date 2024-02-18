#!sh
set -e;
rclone copy src://identity-enc-models-prod/models/6478fcb410dcce6d3b037199 /models/6478fcb410dcce6d3b037199 -vv;
echo '6478fcb410dcce6d3b037199 downloaded';