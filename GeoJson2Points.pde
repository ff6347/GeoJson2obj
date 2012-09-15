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
//HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
//CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
//OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//see also http://www.opensource.org/licenses/mit-license.php

/**
 * This is a class for importing geojson and displaying points on a equirectangular map
 * @author fabiantheblind
 */
public class GeoJson2Points {

  private String path;
  private String GEOJsonStr = "";
  public JSONObject GEOJsonObject;
  public ArrayList <PVector> lonlat;
  public ArrayList <PVector> lonlatPnt;
  public ArrayList <PVector> lonlatLnStr;
  public ArrayList <PVector> lonlatPol;
  public ArrayList <PVector> lonlatMPol;


  private int factor = 1;
  private int pnt = 0;
  private int ln = 0;
  private int pol = 0;
  private int mpol = 0;
  private int gmcoll = 0;
  private Boolean separate;
  public String [] report;


  //    __________  _   _________________  __  __________________  ____ 
  //   / ____/ __ \/ | / / ___/_  __/ __ \/ / / / ____/_  __/ __ \/ __ \
  //  / /   / / / /  |/ /\__ \ / / / /_/ / / / / /     / / / / / / /_/ /
  // / /___/ /_/ / /|  /___/ // / / _, _/ /_/ / /___  / / / /_/ / _, _/ 
  // \____/\____/_/ |_//____//_/ /_/ |_|\____/\____/ /_/  \____/_/ |_|  

  /**
   * The constructor
   * he also loads the file and initalizes the arraylist @see #lonlat 
   * @param path this s the path to the geojson
   * @param factor this is the scale factor of the map to match the display
   */

  public GeoJson2Points(String path, int factor, Boolean sepa) {

    // "AEMap example 10 feat_.json"
    this.path = path;
    String loadedLines[] = loadStrings(this.path);
    this.GEOJsonStr = join(loadedLines, "");
    this.GEOJsonObject =  new JSONObject(this.GEOJsonStr);
    this.factor = factor;
    this.separate = sepa;
//    this.lonlat.add(new PVector(90*this.factor,-180*this.factor,0*this.factor));
    this.lonlat =  new ArrayList<PVector>();   
    if(this.separate){
    this.lonlatPnt =  new ArrayList<PVector>();    
    this.lonlatLnStr =  new ArrayList<PVector>();
    this.lonlatPol =  new ArrayList<PVector>();
    this.lonlatMPol =  new ArrayList<PVector>();
  }
    this.report = new String [11];

  }

  //     ____  _________    ____     _____   __   ________________         _______ ____  _   __
  //    / __ \/ ____/   |  / __ \   /  _/ | / /  / ____/ ____/ __ \       / / ___// __ \/ | / /
  //   / /_/ / __/ / /| | / / / /   / //  |/ /  / / __/ __/ / / / /  __  / /\__ \/ / / /  |/ / 
  //  / _, _/ /___/ ___ |/ /_/ /  _/ // /|  /  / /_/ / /___/ /_/ /  / /_/ /___/ / /_/ / /|  /  
  // /_/ |_/_____/_/  |_/_____/  /___/_/ |_/   \____/_____/\____/   \____//____/\____/_/ |_/   


  public void init() {
    try {

      JSONArray  features = this.GEOJsonObject.getJSONArray("features");

      for (int i = 0; i < features.length(); i++) {
        JSONObject geomtry = features.getJSONObject(i).getJSONObject("geometry");
        
//        try{
//          String gmtype = geomtry.getString("type");
//          JSONObject prop = features.getJSONObject(i).getJSONObject("properties");
//          int num = prop.getInt("storenum");
//      println(gmtype + " " + i + " "+ num);
//    
//  }catch(Exception e){}
        if(geomtry != null){
         if (geomtry.getString("type").equals("GeometryCollection") ) {

           JSONArray  geometries = geomtry.getJSONArray("geometries");
           println(geometries);
           for(int j = 0; j < geometries.length();j++){
           getLocationsByType(geometries.getJSONObject(j));
           }
             gmcoll++;
        }else{
          
        getLocationsByType( geomtry);
        
        }
        }
      }

      // this should stay her at the end
      // so you dont loose it
      

      report[0] = "File:\t" + this.path;      
      report[1] = "GeometryCollection(s):\t"+this.gmcoll;
      report[2] = "----------------------";
      report[3] = "Point(s):\t"+ this.pnt ;
      report[4] = "LineString(s):\t"+ this.ln;
      report[5] = "Polygon(s):\t"+ this.pol;
      report[6] = "MultiPolygon(s):\t"+ this.mpol;
      report[7] = "----------------------";
      report[8] = "Separate:\t"+this.separate;      
      report[9] = "Scale:\t"+ this.factor;
      report[10] = "Comp size:\t"+(360 * this.factor) + " x " + (180 * this.factor);
      println(report);
      
    }/* END OF TRY */
    catch (JSONException e) { 
      println (e.toString());
    }
  }; // END OF INIT()


private void getLocationsByType(JSONObject geomtry){
  
  JSONArray coords = geomtry.getJSONArray("coordinates");
  
        if (geomtry.getString("type").equals("Point")) {
          pnt++;         
          getPointType(coords);
        }; // end POINT

        if (geomtry.getString("type").equals("LineString") ) {
          ln++;
          getLingStringType(coords);
        };// end LINESTRING

        if (geomtry.getString("type").equals("Polygon") ) {
          pol++;
          getPolygonType(coords);
        };//end POLYGON

        if (geomtry.getString("type").equals("MultiPolygon") ) {
          mpol++;
          getMultiPolygonType(coords);
        };// end MULTIPOLYGON
        
   
        
}

public void writeReport(String fn){
saveStrings(fn, this.report);


}

private void getPointType(JSONArray coords){
  try{
  double x = 0;
  double y = 0;

          x = coords.getDouble(0);
          y = coords.getDouble(1);
          PVector pos = new PVector ((float)x, -(float)y, 0);
          this.lonlat.add(pos);
         if(this.separate) this.lonlatPnt.add(pos);
          
    }catch (JSONException e) { 
      println (e.toString());
    }
    
}

private void getLingStringType(JSONArray coords){
  try{
         for (int m = 0; m <coords.length();m++ ) {

            double x = coords.getJSONArray(m).getDouble(0);
            double y = coords.getJSONArray(m).getDouble(1);
            
            PVector pos = new PVector ((float)x, -(float)y, 0);
            this.lonlat.add(pos);
            if(this.separate) this.lonlatLnStr.add(pos);

          };// end M
    }catch (JSONException e) { 
      println (e.toString());
    }
   
}

private void getPolygonType(JSONArray coords){
  try{
 for (int l = 0; l <coords.length();l++ ) {
            for (int k = 0; k < coords.getJSONArray(l).length();k++) {

              double x = coords.getJSONArray(l).getJSONArray(k).getDouble(0);
              double y = coords.getJSONArray(l).getJSONArray(k).getDouble(1);
              PVector pos = new PVector ((float)x, -(float)y, 0);
              this.lonlat.add(pos);
              if(this.separate) this.lonlatPol.add(pos);
            };//end K
          };//end L
          
              }catch (JSONException e) { 
      println (e.toString());
    }
}

private void getMultiPolygonType(JSONArray coords){
  try{          

          for (int j = 0; j < coords.length();j++ ) {
            for (int n = 0; n < coords.getJSONArray(j).length();n++) {
              for (int k = 0; k < coords.getJSONArray(j).getJSONArray(n).length();k++) {
                double x = coords.getJSONArray(j).getJSONArray(n).getJSONArray(k).getDouble(0);
                double y = coords.getJSONArray(j).getJSONArray(n).getJSONArray(k).getDouble(1);
               PVector pos = new PVector ((float)x, -(float)y, 0);
                this.lonlat.add(pos);
                if(this.separate) this.lonlatMPol.add(pos);
              };// end K
            };// end N
          };// end J


    }catch (JSONException e) { 
      println (e.toString());
    }
}

  //     ____  _________ ____  __    _____  __
  //    / __ \/  _/ ___// __ \/ /   /   \ \/ /
  //   / / / // / \__ \/ /_/ / /   / /| |\  / 
  //  / /_/ // / ___/ / ____/ /___/ ___ |/ /  
  // /_____/___//____/_/   /_____/_/  |_/_/   

  /**
   * #display(float xoff,float yoff,float zoff) 
   *  
   * @param xoff duh!
   * @param yoff double duh!!
   * @param zoff you can offset the the points in x,y and z
   */

  public void display(float xoff, float yoff, float zoff) {
    pushMatrix();
    translate((width/2), (height/2), 0);

    for (int i = 0; i < this.lonlat.size();i++) {
      PVector p = this.lonlat.get(i);
      float x = p.x *factor + (xoff*factor);
      float y = p.y *factor + (yoff*factor);
      float z = p.z *factor + (zoff*factor);
      point(x, y, z);

      //      drawPoints(x, y, z);
    }
    popMatrix();
  }

  /**
   * #drawPoints draws points
   *  
   * @param x duh!
   * @param y double duh!!
   * @param z this is the point draing within the geojson the values are already corrected
   */

  /**
   * @deprecated
   */
  @SuppressWarnings("unused")

    private void drawPoints(float  x, float y, float z) {
      //  println(x +" <- x || y -> "+(-y));
      point(x, y, z);
    }
}

