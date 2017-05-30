#!/bin/bash -ex

# clean up
trap cleanup EXIT
function cleanup {
  rm -rf $WORKING_DIR/osm-analytics-cruncher
}

# init repo
cd $WORKING_DIR
git clone https://github.com/hotosm/osm-analytics-cruncher
cd osm-analytics-cruncher
npm install --silent

# update hot projects data
./hotprojects.sh || true

# download latest planet from osm-qa-tiles
curl https://s3.amazonaws.com/mapbox/osm-qa-tiles/latest.planet.mbtiles.gz --silent | gzip -d > planet.mbtiles

# generate osm-analytics data
./crunch-all.sh planet.mbtiles

rm planet.mbtiles
