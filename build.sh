#!/bin/sh
set -e
echo "Enter the name of your new database software:"
read db
dblower=$(echo "${db}" | tr '[:upper:]' '[:lower:]')

wget https://binaries.cockroachdb.com/cockroach-latest.src.tgz

tar xfz cockroach-latest.src.tgz

echo "Building ${db} (${dblower})"

(cd cockroach-latest/src/github.com/cockroachdb/cockroach &&
  find . -not -path './vendor*' -a \( -type f -name '*.go' -o -name '*.ts*' -o -name '*.html' \) \
    -exec sed -i '' -e "s/CockroachDB/${db}/" '{}' ';' \
    -exec sed -i '' -e "s/Cockroach DB/${db}/" '{}' ';' \
    -exec sed -i '' -e "s/\"cockroach /\"${dblower} /" '{}' ';' \
    -exec sed -i '' -e "s/Cockroach server/${db} server/" '{}' ';' \
    -exec sed -i '' -e "s/cockroach-data/${dblower}-data/" '{}' ';' \
)

(cd cockroach-latest && make buildoss)
mv cockroach-latest/src/github.com/cockroachdb/cockroach/cockroach "${dblower}"
