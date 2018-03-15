!#/usr/bin/env bash

# this script should get run in the directory above the 'runs' directory
tensorboard --logdir=runs --host=0.0.0.0 --port=6006
