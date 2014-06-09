#!/bin/bash

set -e

# #
# Setup
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

[ -d dist ] || mkdir dist

# #
# Get the Jinja documentation
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -e "Fetching the Jinja2 documentation from http://jinja.pocoo.org/docs..."

curl -Os http://jinja.pocoo.org/docs/jinja-docs.zip
tar xf jinja-docs.zip

# #
# Generate the docset with doc2dash
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -e "Generating docset with doc2dash..."

doc2dash -f -n jinja2 --destination ./dist ./jinja-docs

# #
# Update info.plist
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

cp ./resources/info.plist ./dist/jinja2.docset/Contents

# #
# Set icons for the docset
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

cp ./resources/icon.png ./dist/jinja2.docset
cp ./resources/icon@2x.png ./dist/jinja2.docset

# #
# Format the documentation
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -e "Formatting docset..."

JINJA_DOCS_ROOT="dist/jinja2.docset/Contents/Resources/Documents"

# remove the sidebar from all documentation files

sed -i ".bkp" '/<div class="sphinxsidebar">/,/<div class="clearer"><\/div>/d' $JINJA_DOCS_ROOT/*.html

cat >> "$JINJA_DOCS_ROOT/_static/jinja.css" << EOF
div.bodywrapper {
  margin: 0;
}
EOF

# format page titles

sed -i ".bkp" "s/—/\&mdash;/" $JINJA_DOCS_ROOT/*.html
sed -i ".bkp" "s@<title>\(.*\)&mdash;.*</title>@<title>\1</title>@" $JINJA_DOCS_ROOT/*.html

# fluid layout

cat >> "$JINJA_DOCS_ROOT/_static/jinja.css" << EOF
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

# add the jinja logo to the index page

#sed -i ".bkp" '/<div class="section" id="welcome-to-jinja2">/a <img class="logo" src="_static\/jinja-small.png" alt="Logo">' $JINJA_DOCS_ROOT/index.html
sed -i ".bkp" 's/<div class="section" id="welcome-to-jinja2">/<div class="section" id="welcome-to-jinja2"><img class="logo" src="_static\/jinja-small.png" alt="Logo">/' $JINJA_DOCS_ROOT/index.html

cat >> "$JINJA_DOCS_ROOT/_static/jinja.css" << EOF
.logo {
  height: 57px;
  float: left;
  margin-right: 20px;
}
EOF

# remove search.html

rm $JINJA_DOCS_ROOT/search.html
sed -i ".bkp" '/search.html/d' $JINJA_DOCS_ROOT/*.html

# #
# Remove junk files and folders
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -e "Cleaning up..."

rm $JINJA_DOCS_ROOT/*.bkp
rm $JINJA_DOCS_ROOT/searchindex.js
rm -rf jinja-docs.zip jinja-docs

# #
# Create compressed archive
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

tar --exclude='.DS_Store' -czf ./dist/jinja2.tgz ./dist/jinja2.docset

# #
# Success!
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -e "Jinja2 docset successfully generated at ./dist/jinja2.docset"
echo -e "Execute ./install.sh to install the docset..."
