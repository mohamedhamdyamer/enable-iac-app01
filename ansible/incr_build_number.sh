#!/bin/bash

build_number=`cat ./build_number`
build_number=$[build_number+1]
echo $build_number > ./build_number
