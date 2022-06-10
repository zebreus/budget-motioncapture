#!/bin/bash
source activate tfpose
python analyze.py -m cmu -d camera_0/ camera_1/ camera_2/ camera_3/ camera_4/ -o lukastposed.xml
