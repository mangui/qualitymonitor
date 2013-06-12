# This is a simple script that compiles the plugin using MXMLC (free & cross-platform).
# Learn more at http://developer.longtailvideo.com/trac/wiki/PluginsCompiling
# To use, make sure you have downloaded and installed the Flex SDK in the following directory:

FLEXPATH=../../flex_sdk_4.6

echo "Compiling with MXMLC..."

$FLEXPATH/bin/mxmlc ../src/com/longtailvideo/plugins/qualitymonitor/QualityMonitor.as -sp ../src -o ../qualitymonitor.swf -library-path+=../lib -load-externs=../lib/jwplayer-5-classes.xml -use-network=false -optimize=true -incremental=false -static-link-runtime-shared-libraries=true
$FLEXPATH/bin/mxmlc ../src/com/longtailvideo/plugins/qualitymonitor/QualityMonitor6.as -sp ../src -o ../qualitymonitor6.swf -library-path+=../lib -load-externs=../lib/jwplayer-6-classes.xml -use-network=false -optimize=true -incremental=false -static-link-runtime-shared-libraries=true

