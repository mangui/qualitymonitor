package com.longtailvideo.plugins.qualitymonitor {


import com.longtailvideo.jwplayer.plugins.IPlugin6;
import com.longtailvideo.plugins.qualitymonitor.QualityMonitor;


public class QualityMonitor6 extends QualityMonitor implements IPlugin6 {

      /** This should be the player version the plugin is targeted for. **/
      public function get target():String {
         return "6.0";
      }
   }
}