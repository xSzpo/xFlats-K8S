#/bin/bash
bq load \
--source_format=NEWLINE_DELIMITED_JSON \
--max_bad_records=50 \
--ignore_unknown_values \
xflats.flats \
gs://coastal-stone-flats/flats_all* \
./bq_xflats_schema.json