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
rclone copy src://identity-enc-models-public/models/66a0a678fb85edd8517b6af5 /models/66a0a678fb85edd8517b6af5 -vv;
if [ ! -d /models/66a0a678fb85edd8517b6af5 ]; then echo 'failed to clone model 66a0a678fb85edd8517b6af5'; exit 1; fi;
echo '66a0a678fb85edd8517b6af5 downloaded';
rclone copy src://identity-enc-models-public/models/66a00cd7fb85edd8517b6af3 /models/66a00cd7fb85edd8517b6af3 -vv;
if [ ! -d /models/66a00cd7fb85edd8517b6af3 ]; then echo 'failed to clone model 66a00cd7fb85edd8517b6af3'; exit 1; fi;
echo '66a00cd7fb85edd8517b6af3 downloaded';