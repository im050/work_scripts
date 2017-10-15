#!/bin/bash
cat url.log | while read line
do
  curl -O $line
done