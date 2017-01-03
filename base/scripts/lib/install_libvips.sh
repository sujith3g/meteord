#!/bin/sh
set -e

vips_version_minimum=8.4.2
vips_version_latest_major_minor=8.4
vips_version_latest_patch=2

openslide_version_minimum=3.4.0
openslide_version_latest_major_minor=3.4
openslide_version_latest_patch=1

install_libvips_from_source() {
  echo "Compiling libvips $vips_version_latest_major_minor.$vips_version_latest_patch from source"
  curl -O http://www.vips.ecs.soton.ac.uk/supported/$vips_version_latest_major_minor/vips-$vips_version_latest_major_minor.$vips_version_latest_patch.tar.gz
  tar zvxf vips-$vips_version_latest_major_minor.$vips_version_latest_patch.tar.gz
  cd vips-$vips_version_latest_major_minor.$vips_version_latest_patch
  CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" ./configure --disable-debug --disable-docs --disable-static --disable-introspection --disable-dependency-tracking --enable-cxx=yes --without-python --without-orc --without-fftw $1
  make
  make install
  cd ..
  rm -rf vips-$vips_version_latest_major_minor.$vips_version_latest_patch
  rm vips-$vips_version_latest_major_minor.$vips_version_latest_patch.tar.gz
  ldconfig
  echo "Installed libvips $(PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig pkg-config --modversion vips)"
}

install_libopenslide_from_source() {
  echo "Compiling openslide $openslide_version_latest_major_minor.$openslide_version_latest_patch from source"
  curl -O -L https://github.com/openslide/openslide/releases/download/v$openslide_version_latest_major_minor.$openslide_version_latest_patch/openslide-$openslide_version_latest_major_minor.$openslide_version_latest_patch.tar.gz
  tar xzvf openslide-$openslide_version_latest_major_minor.$openslide_version_latest_patch.tar.gz
  cd openslide-$openslide_version_latest_major_minor.$openslide_version_latest_patch
  PKG_CONFIG_PATH=$pkg_config_path ./configure $1
  make
  make install
  cd ..
  rm -rf openslide-$openslide_version_latest_major_minor.$openslide_version_latest_patch
  rm openslide-$openslide_version_latest_major_minor.$openslide_version_latest_patch.tar.gz
  ldconfig
  echo "Installed libopenslide $openslide_version_latest_major_minor.$openslide_version_latest_patch"
}

apt-get install -y automake build-essential gobject-introspection gtk-doc-tools libglib2.0-dev libjpeg-dev libpng12-dev libwebp-dev libtiff5-dev libexif-dev libgsf-1-dev liblcms2-dev libxml2-dev swig libmagickcore-dev curl
install_libvips_from_source

apt-get install -y automake zlib1g-dev libopenjpeg-dev libgdk-pixbuf2.0-dev libxml2-dev libsqlite3-dev libcairo2-dev sqlite3 
install_libopenslide_from_source

enable_openslide=1

pkg_config_path="$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig"
