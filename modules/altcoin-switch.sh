#!/bin/bash

TMP_STAGE=/tmp/alt-coin-stage.tmp

if [ "$(cat $TMP_STAGE)" -eq 1 ]; then
	printf 0 > $TMP_STAGE
else
	printf 1 > $TMP_STAGE
fi
