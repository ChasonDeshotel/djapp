#!/bin/env/bash
find ./sql/ -name '[!.]*.sql' -print0 | sort -z | xargs -0 -i sudo -u postgres psql -d djapp -a -f {}
