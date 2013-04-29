package com.longtailvideo.plugins.qualitymonitor {


import flash.display.*;
import flash.events.*;
import flash.geom.Rectangle;
import flash.text.*;
import flash.utils.*;


/**
* Class to display constantly updating sparklines.
**/
public class Sparkline extends Sprite {


    /** Reference to the background clip. **/
    private var line:Sprite;
    /** Range of the sparkline. **/
    private var range:Array;
    /** Bounding box of the chart. **/
    private var area:Sprite;
    /** The number of sparks in the line. **/
    private var sparks:Number = 0;


    /** Constructor. Setup the sparkline. **/
    public function Sparkline(wid:Number=100,hei:Number=20,min:Number=0,max:Number=1,clr:Number=0xCCCCCC):void {
        range = new Array(min,max);
        line = new Sprite();
        line.graphics.lineStyle(2,clr);
        area = new Sprite();
        area.graphics.beginFill(0x000000);
        area.graphics.drawRect(0,0,wid,hei);
        line.mask = area;
        addChild(line);
        addChild(area);
    };


    /** Change the width of the sparkline. **/
    public function resize(wid:Number):void {
        var hei:Number = area.height;
        area.graphics.clear();
        area.graphics.beginFill(0x000000);
        area.graphics.drawRect(0,0,wid,hei);
    };


    /** Add a datapoint. **/
    public function spark(val:Number):void {
        var xps:Number = sparks+1;
        var yps:Number = (range[1]-val) * area.height / (range[1]-range[0]);
        if(yps < 1) {
            yps = 1;
        } else if (yps > area.height - 1) {
            yps = area.height - 1;
        }
        if(sparks) {
            line.graphics.lineTo(xps,yps);
        } else {
            line.graphics.moveTo(0,yps);
        }
        if(line.width > area.width) {
            line.x = area.width - line.width;
        } else {
            line.x = 0;
        }
        sparks++;
    };



}


}