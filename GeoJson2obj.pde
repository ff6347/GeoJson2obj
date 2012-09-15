/**
 * creating obj from GEOJson for AE 2012
 * @author fabiantheblind
 */

// YOU NEED THIS LIBS <a href="http://n-e-r-v-o-u-s.com/tools/obj.php">n-e-r-v-o-u-s obj export</a>
import nervoussystem.obj.*;

// AND THIS ONE  <a href="https://github.com/agoransson/JSON-processing">JSON 4 processing </a>
import org.json.*;

// these are the 2 values u need
int factor = 4;// the scale of the map
Boolean separate = false; // of to separeate the obj by points,lines,polygon and multipolygon

/** 
 * YOUR OPTIONS
 * Hit 'o' or 'O' for .obj export (this will also write a report)
 * Hit 'i' or 'I' for to write an .jpg file of that view
 * Hit 'r' or 'R' for the report
 *
 *
 */
 
// Define your filename in this way:
// it has to be the exact name without extension

//String GEOJsonFilename = "AEMap example 10 feat";
String GEOJsonFilename = "walmart";
//String GEOJsonFilename = "world capitals 225940 features";
//String GEOJsonFilename = "countries.geo";
//String GEOJsonFilename = "world airports geo commons 227677";
//String GEOJsonFilename = "earthquake on twitter 226688";
//String GEOJsonFilename = "fabiantheblind movement OpenPaths 231404";
//String GEOJsonFilename = "USGS  Earthquake Records World 1998-2007 220288";
//String GEOJsonFilename =  "Wal Mart Stores and supercenters 133211";
//String GEOJsonFilename =  "world capitals 225940";




// --------------- EVERYTHING ELSE IS SYSTEM PROCEED AT YOU OWN RISK ;)-----------------

//    ____  ____      __   __________  ____  __  ___   ________________      _______ ____  _   __
//   / __ \/ __ )    / /  / ____/ __ \/ __ \/  |/  /  / ____/ ____/ __ \    / / ___// __ \/ | / /
//  / / / / __  |_  / /  / /_  / /_/ / / / / /|_/ /  / / __/ __/ / / / /_  / /\__ \/ / / /  |/ / 
// / /_/ / /_/ / /_/ /  / __/ / _, _/ /_/ / /  / /  / /_/ / /___/ /_/ / /_/ /___/ / /_/ / /|  /  
// \____/_____/\____/  /_/   /_/ |_|\____/_/  /_/   \____/_____/\____/\____//____/\____/_/ |_/   
//                                                                                               
//Copyright (c)  2012 Fabian "fabiantheblind" Morón Zirfas
//Permission is hereby granted, free of charge, to any person obtaining a copy of this
//software and associated documentation files (the "Software"), to deal in the Software 
//without restriction, including without limitation the rights to use, copy, modify, 
//merge, publish, distribute, sublicense, and/or sell copies of the Software, and to 
//permit persons to whom the Software is furnished to do so, subject to the following 
//conditions:
//The above copyright notice and this permission notice shall be included in all copies 
//or substantial portions of the Software.
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
//INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
//PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
//HOLDERS BE LIA.jsonBLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
//CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
//OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//see also http://www.opensource.org/licenses/mit-license.php

/**
 * HOW TO MAP LAT LON TO A EQUIRECTANGULAR MAP
 *
 *
 */
// latitude is y
// latitude = +90 || y = 0 
// latitude = -90 || y = 180

// longitude is x
// longitude  -180 || x = 0
// longitude  +180 || x = 360

// so the coordiantae space has to be pushed into the center
// and the latitude has to be reversed to fit the AE and the Processing coord space

// so the base size is 360 width x 180 height

boolean record;

PImage img;
GeoJson2Points g2p;
ObjWriter exporter;
ObjWriter exporterLN;


int w = 360;
int h = 180;
//float xoff = 0, yoff = 0, zoff = 0;

String inputExt = "json";
String outputExt = "obj";
String imgExt = "jpg";
String repExt = "txt";
String ExtDelimeter = ".";
// make the strings like this GEOJsonFilename + ExtDelimeter + inputExt

void setup() {





  size(w*factor, h*factor, P3D);
  
  // AEMap example 10 feat_.json
  // world airports geo commons 227677.json
//  g2p = new GeoJson2Points("AEMap example 10 feat_.json", factor);
    g2p = new GeoJson2Points(GEOJsonFilename + ExtDelimeter + inputExt, factor, separate);
    exporter  = new ObjWriter(factor);
    exporterLN  = new ObjWriter(factor);

    g2p.init();


  // or draw them manualy from the list
  // needs translating into the center
  //
  // these values in the ArrayList <PVector>  lonlat within an Object Class GeoJson2Points
  // already are switched in coordinate space
  // have a look at the top how
  // x vs lon and
  // y vs lat behave
  //
  // translate(width/2,height/2,0);
  //  if u want to do some other stuff maybee u need to use pushMatrix
  //  for (int i = 0; i < g2p.lonlat.size();i++) {
  //    float x = g2p.lonlat.get(i).x * factor;  
  //    float y = g2p.lonlat.get(i).y * factor + (yoff * factor);
  //    float z = g2p.lonlat.get(i).z * factor;
  //    point(x, y, z);
  //  }
}

void bg() {
  background(0);
  stroke(#FFAC0F);
  fill(0);
  strokeWeight(2);
  rect(0, 0, width, height);
  tint(128, 128, 128, 100);
  img  = loadImage("world_map.png");
  image(img, 0+ (factor), 0 + (factor), w*factor, h*factor);
}

void draw() {
  
    if (!record){ 
      
      bg();
  smooth();

  stroke(255);
  strokeWeight(1);
  g2p.display(0, 0, 0);
  // nothing happens here right now  
    }else{
    
    if(!separate){
     if (record == true && g2p.lonlat.size() > 0) {
       String fn  = GEOJsonFilename + ExtDelimeter + outputExt;
    beginRecord("nervoussystem.obj.OBJExport",fn); 
    println("Wrote all coordiantes to disk -> " + fn);
    } 
    exporter.write(g2p.lonlat);
    
    endRecord();
    
    
    }else{
    if (record == true && g2p.lonlatPnt.size() > 0) {
    String fnp  = GEOJsonFilename +" Points" + ExtDelimeter + outputExt;
    beginRecord("nervoussystem.obj.OBJExport",fnp); 
    println("Wrote " + fnp +" to disk.");
    } 
    exporter.write( g2p.lonlatPnt);
    endRecord();

//   delay(1000);
   
   if (record == true && g2p.lonlatLnStr.size() > 0) {
    String fnln =  GEOJsonFilename +" LineStrings" + ExtDelimeter + outputExt;
    beginRecord("nervoussystem.obj.OBJExport",fnln); 
    println("Wrote " + fnln +" to disk.");
    } 
    exporter.write( g2p.lonlatLnStr);
    endRecord();

//   delay(1000);

   if (record == true && g2p.lonlatPol.size() > 0) {
    String fnpol =  GEOJsonFilename +" Polygons" + ExtDelimeter + outputExt;
    beginRecord("nervoussystem.obj.OBJExport",fnpol); 
    println("Wrote " + fnpol +" to disk.");
    } 
    exporter.write( g2p.lonlatPol);
    endRecord();

//   delay(1000);
   if (record == true && g2p.lonlatMPol.size() > 0) {
    String fnmpol =  GEOJsonFilename +" MultiPolygons" + ExtDelimeter + outputExt;
    beginRecord("nervoussystem.obj.OBJExport",fnmpol); 
    println("Wrote " + fnmpol +" to disk.");
    } 
    exporter.write( g2p.lonlatMPol);
    endRecord();

    }
    
    
    }

    
  
    if (record) {
    record = false;
  }  
  
}


void keyPressed() {
    if (key == 'i' || key == 'I') {
          String fn =  GEOJsonFilename + ExtDelimeter + imgExt;
      save(fn);
    println("Wrote " + fn +" to disk.");    
  }
  
      if (key == 'r' || key == 'R') {
        
    String fn =  GEOJsonFilename + ExtDelimeter + repExt;
    g2p.writeReport(fn);
    println("Wrote " + fn +" to disk.");    
  }
      if (key == 'o' || key == 'O') {
    String fn =  GEOJsonFilename + ExtDelimeter + repExt;
    g2p.writeReport(fn);
    println("Wrote " + fn +" to disk."); 
     record = true;

  }  
  
}
