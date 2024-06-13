#!sh
set -e;
rclone copy src://identity-enc-models-public/models/6478fcb410dcce6d3b037199 /models/6478fcb410dcce6d3b037199 -vv;
echo '6478fcb410dcce6d3b037199 downloaded';
rclone copy src://identity-enc-models-public/models/6647158183f1d72d549f88e4 /models/6647158183f1d72d549f88e4 -vv;
echo '6647158183f1d72d549f88e4 downloaded';
rclone copy src://identity-enc-models-public/models/664f60da83f1d72d549f88f3 /models/664f60da83f1d72d549f88f3 -vv;
echo '664f60da83f1d72d549f88f3 downloaded';
rclone copy src://identity-enc-models-public/models/664f60f083f1d72d549f88f4 /models/664f60f083f1d72d549f88f4 -vv;
echo '664f60f083f1d72d549f88f4 downloaded';
