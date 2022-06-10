from PIL import Image
from argparse import ArgumentParser
import os

parser = ArgumentParser()
parser.add_argument("-d", "--dirctories", dest="source", nargs='+',
                    help="target file to save xml", metavar="INDIRS", required=True)
args = parser.parse_args()


for sourceid in range(len(args.source)):
	imageid = 1;
	for imagefile in os.listdir(args.source[sourceid]):
		print('Image {} of {} is '.format(imageid, len(os.listdir(args.source[sourceid])))+ args.source[sourceid]+imagefile + ". Imageset is {} of {}".format(sourceid+1,len(args.source)))
		imageid = imageid+1
		img = Image.open(args.source[sourceid]+imagefile)
		img.save(args.source[sourceid]+imagefile)
		
