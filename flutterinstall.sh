#!/bin/bash
echo "Downloading Flutter..."
wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.2.1-stable.tar.xz
echo "Extracting flutter..."
tar xf $(FlutterToolPath)/flutter_linux_v1.2.1-stable.tar.xz
echo "Done"
