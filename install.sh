#!/bin/sh


chmod 0755 RUN.sh
chmod 0755 scripts/*.perl
chmod 0755 eval/*.perl

echo "Permissions of execution, done!"

echo "creating empty folders"
mkdir models/citius-pt
mkdir models/citius-en
mkdir models/citius-es
mkdir models/citius-gl
mkdir out/citius-pt
mkdir out/citius-en
mkdir out/citius-es
mkdir out/citius-gl
mkdir simil/citius-pt
mkdir simil/citius-en
mkdir simil/citius-es
mkdir simil/citius-gl


echo "Dowload models trained from Wikipedia"
cd models
wget -nc http://fegalaz.usc.es/~gamallo/resources/models_DepFunc.tgz
tar xzvf models_DepFunc.tgz
cd ..
