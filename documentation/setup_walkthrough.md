# Cruncher

* install node/npm, curl
* compile and install [tippecanoe](https://github.com/mapbox/tippecanoe) (version 1.8.1 works, not sure about newer releases)
* download [`run.sh`](https://raw.githubusercontent.com/hotosm/osm-analytics-cruncher/master/run.sh) from cruncher repo
* replace osmqatiles-planet url with the extract you want
* adjust paths in `crunch-all.sh` (and mkdir the respective working directories)
* comment out `hotprojects.sh` (would fail because it requires valid AWS credentials to upload stuff into a hardcoded bucket).
* comment out the `forever restart …` lines (requires a tile-serving script to be already running)
* or install `forever` globally (`npm i -g forever`), and run `forever server/serve.js` (before running the cruncher)
* execute `run.sh` -> … -> two `.mbtiles` files in results directory

# Serve Results

There are some options:

* use [mb-util](https://github.com/mapbox/mbutil) (e.g. `mb-util --image_format=pbf buildings.mbtile buildings`) to unpack mbtiles file and serve it via a local web server (or upload the data to S3, or …).
* use mapbox-tile-copy to upload contents directly to S3
* use a server script like the [example](https://github.com/hotosm/osm-analytics-cruncher/blob/master/server/serve.js) in the repo that serves tiles directly from the mbtiles file. (code needs to be adjusted!)

HTTP API schema is:

    http://.../.../<feature-type>/<z>/<x>/<y>.pbf

where `feature-type` is buildings,highways, etc.

The web server needs to return proper `CORS` headers, the `Content-Encoding=gzip` header (!) and the `Content-Type` header needs to be either `application/x-protobuf` or `application/octet-stream`.

# Run frontend

* clone repo `git clone https://github.com/hotosm/osm-analytics`
* run `npm install`
* adjust base-url setting in `./app/settings/settings.js`
* run `npm start` (for a development-server) or `npm run build` to build a production build (results as HTML5 in `./static`)

# Add a new feature type

(not yet tested, sorry)

* on frontend side: add new type in `./app/settings/options.js` (as entry in `filters` array)
* on backend:
  * add new type definition json file (like [`buildings.json`](https://github.com/hotosm/osm-analytics-cruncher/blob/master/buildings.json)) (use `"objects"` as a generic user-experience field)
  * add a new [crunching section in `run.sh`](https://github.com/hotosm/osm-analytics-cruncher/blob/58fdf84582dc6593fa7b2fcae8850ba10db62453/run.sh#L42-L48) for the newly created feature type
  * serve results (see above)
