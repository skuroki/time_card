for file in app/models/**/*.rb
do
  mkdir -p sig/$(dirname $file)
  rbs prototype rb $file > sig/${file}s
done
