import argparse
import logging
import sys
import time
import os
import re

from tf_pose import common
import cv2
import numpy as np
from tf_pose.estimator import TfPoseEstimator
from tf_pose.networks import get_graph_path, model_wh

from lxml import etree as ET

from argparse import ArgumentParser

parser = ArgumentParser()

parser.add_argument("-m", '--model', type=str, default='cmu', help='cmu / mobilenet_thin')

parser.add_argument("-d", "--dirctories", dest="source", nargs='+',
                    help="target file to save xml", metavar="INDIRS", required=True)
                    
parser.add_argument("-o", "--output", dest="output",
                    help="target file to save xml", metavar="OUTFILE", required=True)

args = parser.parse_args()

root = ET.Element("moca")

e = TfPoseEstimator(get_graph_path(args.model), target_size=(656, 368))

for sourceid in range(len(args.source)):
	camera = ET.SubElement(root, "camera")
	camera.set("id",'{}'.format(sourceid))
	imageid = 1;
	for imagefile in os.listdir(args.source[sourceid]):
		try:
			print('Image {} of {} is '.format(imageid, len(os.listdir(args.source[sourceid])))+ args.source[sourceid]+imagefile + ". Imageset is {} of {}".format(sourceid+1,len(args.source)))
			imageid = imageid+1
		
			image = common.read_imgfile(args.source[sourceid]+imagefile, 656, 368)
			humans = e.inference(image, resize_to_default=(0 > 0 and 0 > 0), upsample_size=4.0)
		
			frame = ET.SubElement(camera, "frame")
			frame.set("number",'{}'.format(int(re.search(r'\d+', imagefile).group())))
		
			i = 0
			while i < len(humans):
				print('	Building human {}'.format(i))
				human = ET.SubElement(frame, "human")
				human.set("id",'{}'.format(i))
				for j in humans[i].body_parts:
					part = ET.SubElement(human,"bodypart")
					part.set("id",'{}'.format(humans[i].body_parts[j].part_idx))
					part.set("name",'{}'.format(humans[i].body_parts[j].get_part_name()))
					part.set("x",'{}'.format(humans[i].body_parts[j].x))
					part.set("y",'{}'.format(humans[i].body_parts[j].y))
					part.set("score",'{}'.format(humans[i].body_parts[j].score))
				i = i+1
		except:
			e = sys.exc_info()[0]
			print(e)
print("Writing xml")
tree = ET.ElementTree(root)
tree.write(args.output, pretty_print=True)
			
