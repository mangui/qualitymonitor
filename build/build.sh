# This is a simple script that compiles the plugin using MXMLC (free & cross-platform).
# Learn more at http://developer.longtailvideo.com/trac/wiki/PluginsCompiling
# To use, make sure you have downloaded and installed the Flex SDK in the following directory:

FLEXPATH=../../flex_sdk_4.6

echo "Compiling with MXMLC..."

$FLEXPATH/bin/mxmlc ../src/com/longtailvideo/plugins/qualitymonitor/QualityMonitor.as -sp ../src -o ../qualitymonitor.swf -library-path+=../lib -load-externs=../lib/jwplayer-5-classes.xml -use-network=false -optimize=true -incremental=false

$FLEXPATH/frameworks/libs -compiler.library-path ../lib -include-classes com.longtailvideo.plugins.qualitymonitor.QualityMonitor -link-report='../qualitymonitor-classes.xml'