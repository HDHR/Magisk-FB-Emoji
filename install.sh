##########################################################################################
#
# Installer Script
#
##########################################################################################

SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=false
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"
REPLACE="
"

print_modname() {
  ui_print "*******************************"
  ui_print "*        FB Emoji 15.0        *"
  ui_print "*******************************"
}

on_install() {
  # Definitions
  FONT_DIR=$MODPATH/system/fonts
  FONT_EMOJI="NotoColorEmoji.ttf"
  ui_print "- Extracting module files"
  ui_print "- Installing Emojis"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

  # Compatibility with different devices and potential Support for Android 13?
  variants='SamsungColorEmoji.ttf LGNotoColorEmoji.ttf HTC_ColorEmoji.ttf AndroidEmoji-htc.ttf ColorUniEmoji.ttf DcmColorEmoji.ttf CombinedColorEmoji.ttf NotoColorEmojiLegacy.ttf'
  for i in $variants ; do
        if [ -f "/system/fonts/$i" ]; then
            cp $FONT_DIR/$FONT_EMOJI $FONT_DIR/$i && ui_print "- Replacing $i"
        fi
  done
  
  # Verifying Android version
  android_ver=$(getprop ro.build.version.sdk)
  # If Android 12 detected
  if [ $android_ver -ge 31 ]; then
        DATA_FONT_DIR="/data/fonts/files"
    if [ -d "$DATA_FONT_DIR" ] && [ "$(ls -A $DATA_FONT_DIR)" ]; then
            ui_print "- Android 12 Detected"
            ui_print "- Checking [$DATA_FONT_DIR]"
        for dir in $DATA_FONT_DIR/*/ ; do
                cd $dir
            for file in * ; do
                if [ "$file" == *ttf ] ; then
                    cp $FONT_DIR/$FONT_EMOJI $file && ui_print "- Replacing $file"
                fi
                done
        done
    fi
  fi
  
  
  [[ -d /sbin/.core/mirror ]] && MIRRORPATH=/sbin/.core/mirror || unset MIRRORPATH
  FONTS=/system/etc/fonts.xml
  FONTFILES=$(sed -ne '/<family lang="und-Zsye".*>/,/<\/family>/ {s/.*<font weight="400" style="normal">\(.*\)<\/font>.*/\1/p;}' $MIRRORPATH$FONTS)
  for font in $FONTFILES
  do
    ln -s /system/fonts/NotoColorEmoji.ttf $MODPATH/system/fonts/$font
  done
}

set_permissions() {
  set_perm_recursive $MODPATH 0 0 0755 0644
}
