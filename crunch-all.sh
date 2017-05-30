#!/bin/bash -ex

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# this is an example script for how to invoke  osm-analytics-cruncher to
# regenerate vector tiles for osm-analytics from osm-qa-tiles
#
# config parameters:
# * WORKING_DIR - working directory where intermediate data is stored
#                 (requires at least around ~160 GB for planet wide calc.)
# * RESULTS_DIR - directory where resulting .mbtiles files are stored
# * SERVER_SCRIPT - node script that serves the .mbtiles (assumed to be already
#                   started with `forever`)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# config
WORKING_DIR=/mnt/data
RESULTS_DIR=~/results
SERVER_SCRIPT=/home/ubuntu/server/serve.js

PLANET=$1

# clean up
trap cleanup EXIT
function cleanup {
  rm -rf $WORKING_DIR/osm-analytics-cruncher
}

# generate user experience data
./experiences.sh planet.mbtiles

# buildings
./crunch.sh $PLANET buildings 64
cp buildings.mbtiles $RESULTS_DIR/buildings.mbtiles.tmp
mv -f $RESULTS_DIR/buildings.mbtiles.tmp $RESULTS_DIR/buildings.mbtiles
forever restart $SERVER_SCRIPT
rm buildings.mbtiles

# highways
./crunch.sh $PLANET highways 32
cp highways.mbtiles $RESULTS_DIR/highways.mbtiles.tmp
mv -f $RESULTS_DIR/highways.mbtiles.tmp $RESULTS_DIR/highways.mbtiles
forever restart $SERVER_SCRIPT
rm highways.mbtiles

# waterways
./crunch.sh $PLANET waterways 32
cp waterways.mbtiles $RESULTS_DIR/waterways.mbtiles.tmp
mv -f $RESULTS_DIR/waterways.mbtiles.tmp $RESULTS_DIR/waterways.mbtiles
forever restart $SERVER_SCRIPT
rm waterways.mbtiles
