#!/bin/bash

set -e

BUILD_DIR=$(pwd)

# #
# Setup
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

[ -d dist ] || mkdir dist
[ -d tmp ] || mkdir tmp

# #
# Get the Celery documentation
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -e "Fetching latest Celery installation from Github"

cd tmp
wget -O celery.zip $(curl -s https://api.github.com/repos/celery/celery/tags | jq --raw-output '.[0] | .zipball_url' )

mkdir celery
tar xf celery.zip -C celery --strip-components 1



# #
# Build latest documentation
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
virtualenv dash
source dash/bin/activate
pip install -r celery/requirements/pkgutils.txt

export SPHINX_BUILD="${BUILD_DIR}/tmp/dash/bin/sphinx-build"
cd celery/docs && make html

cd ${BUILD_DIR}
# #
# Generate the docset with doc2dash
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -e "Generating docset with doc2dash..."

doc2dash -f --name celery --icon "${BUILD_DIR}/resources/icon.png" --online-redirect-url "http://docs.celeryproject.org/en/latest/" -j --destination "${BUILD_DIR}/dist" "${BUILD_DIR}/tmp/celery/docs/.build/html"


## #
# Update info.plist
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

cp ./resources/Info.plist ./dist/celery.docset/Contents

# #
# Set icons for the docset
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

cp ./resources/icon.png ./dist/celery.docset
#cp ./resources/icon@2x.png ./dist/celery.docset

# #
# Format the documentation
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -e "Formatting docset..."

CELERY_DOCS_ROOT="${BUILD_DIR}/dist/celery.docset/Contents/Resources/Documents"

# remove the sidebar from all documentation files

find $CELERY_DOCS_ROOT -type f -name "*.html" -print0 | xargs -0 sed -i ".bkp" '/<div.*class="sphinxsidebar"/,/<div class="clearer"><\/div>/d' $CELERY_DOCS_ROOT/*.html
find $CELERY_DOCS_ROOT -type f -name "*.html" -print0 | xargs -0 sed -i ".bkp" 's/\(<div.*class="related"\).*\(<div.*class="footer"\)/\2/' $CELERY_DOCS_ROOT/*.html

cat >> "${CELERY_DOCS_ROOT}/_static/celery.css" << EOF
div.bodywrapper {
  margin: 0;
}
EOF

# format page titles

sed -i ".bkp" "s/—/\&mdash;/" ${CELERY_DOCS_ROOT}/*.html
sed -i ".bkp" "s@<title>\(.*\)&mdash;.*</title>@<title>\1</title>@" ${CELERY_DOCS_ROOT}/*.html

# fluid layout

cat >> "${CELERY_DOCS_ROOT}/_static/celery.css" << EOF
div.document {
  width: 100%;
}

div.footer {
  box-sizing: border-box;
  width: 100%;
  margin: 20px 0 10px;
  padding: 0 10px;
}
EOF

## add the jinja logo to the index page
#
#sed -i ".bkp" 's@\(^.*id="welcome-to-jinja2".*$\)@\1<img class="logo" src="_static/jinja-small.png">@' $JINJA_DOCS_ROOT/index.html
#
#cat >> "$JINJA_DOCS_ROOT/_static/jinja.css" << EOF
#.logo {
#  height: 57px;
#  float: left;
#  margin-right: 20px;
#}
#EOF
#
# remove search.html

rm ${CELERY_DOCS_ROOT}/search.html
sed -i ".bkp" '/search.html/d' $CELERY_DOCS_ROOT/*.html

# #
# Remove junk files and folders
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -e "Cleaning up..."

rm $CELERY_DOCS_ROOT/*.bkp
rm $CELERY_DOCS_ROOT/searchindex.js
rm -rf tmp

# #
# Create compressed archive
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

tar --exclude='.DS_Store' -C ./dist -czf ./dist/celery.tgz celery.docset

# #
# Success!
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -e "Celery docset successfully generated at ./dist/celery.docset"
echo -e "Execute ./install.sh to install the docset..."