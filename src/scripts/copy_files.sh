aws s3 sync $SYNC_OPTIONS --exclude logos/* --exclude sitemap.xml --cache-control max-age=31536000 --content-encoding gzip ./public s3://$BUCKET_NAME/
aws s3 cp ./public/service-worker.js s3://$BUCKET_NAME/service-worker.js --metadata-directive REPLACE --cache-control max-age=0,no-cache,no-store,must-revalidate --content-encoding gzip --content-type application/javascript
aws s3 cp ./public/index.html s3://$BUCKET_NAME/index.html --metadata-directive REPLACE --cache-control max-age=0,no-cache,no-store,must-revalidate --content-encoding gzip --content-type text/html
aws s3 cp ./public/robots.txt s3://$BUCKET_NAME/robots.txt --metadata-directive REPLACE --cache-control max-age=0,no-cache,no-store,must-revalidate --content-type text/plain
aws s3 cp ./public s3://$BUCKET_NAME/ --metadata-directive REPLACE --cache-control max-age=31536000 --content-type application/json --recursive  --exclude '*' --include 'manifest.*'
aws s3 cp ./public/icons/ s3://$BUCKET_NAME/icons/ --recursive --metadata-directive REPLACE --cache-control max-age=31536000 --content-type image/png
 