/** //<>//
 * Script para sacar los datos de las imagenes de google y extraer en un csv el ditulo, numero de visitas y la fecha
 
 * para su utilizacion necesitamos la apikey y que se activa en la consola de google cloud plataform
 * https://cloud.google.com/vision/docs/apis
 * https://codelabs.developers.google.com/codelabs/cloud-vision-intro/index.html?index=..%2F..%2Fgcp-next#12
 * https://cloud.google.com/vision/?hl=es
 * y  habilitar la api
 *https://console.cloud.google.com/
 * nos descargamos loa rchivos de Google y ponemos la carpeta Google Fotos en
 data/images
 */
Table table; //tabla para guardar los datos que necesitamos
import java.util.Date;
JSONArray values;
int cont = 0;
JSONObject json;

int limit  = 10; //limite de imagenes que haremos la query
String URL = "https://vision.googleapis.com/v1/images:annotate?key=";
String APIKEY = "PONER AQUI LA API KEY"; //API KEY
void setup() {

  // Using just the path of this sketch to demonstrate,
  // but you can list any directory you like.
  String path = sketchPath()+"/data/images";
  createTable();
  String[] filenames = listFileNames(path);
  ArrayList<File> allFiles = listFilesRecursive(path);

  for (File f : allFiles) {


    // println("Is directory: " + f.isDirectory());
    if (!f.isDirectory()) {
      String[] list = split(f.getName(), '.');

      if (list.length>2) {
        String extension = list[2];
        //lee los archivos json que nos proporciona Google Fotos, para ello podemos 
        //meter la carpeta Google Fotos en la carpeta Images.
       if (extension.equals("json") == true ) {
          json = loadJSONObject(f.getAbsolutePath());
          //println("json:"+json);

          JSONObject childTime = json.getJSONObject("photoTakenTime");
          JSONObject geoData = json.getJSONObject("geoData");
          String urlImage = json.getString("url");
          //escribimos en el csv
          TableRow newRow = table.addRow();
          String nombreArchivo = list[0]+"."+list[1];
          println("-----list[1]"+list[1]);

          if (list[1].equals("mp4") == false  && cont < limit) {
            println("nombreArchivo:"+list[1] +"cont:"+cont);
            newRow.setString("title", nombreArchivo);
            newRow.setString("urlimage", urlImage);
            // newRow.setInt("imageViews", imagesViews);
            newRow.setString("timestamp", childTime.getString("formatted"));
            newRow.setString("timestampU", childTime.getString("timestamp"));

            newRow.setDouble("latitud", geoData.getDouble("latitude"));
            newRow.setDouble("longitud", geoData.getDouble("longitude"));
            newRow.setString("json", nombreArchivo+".json");
            cont++;

            creajson(urlImage, false, nombreArchivo);
            if (cont < limit) {
              mandajson(URL+APIKEY, json, nombreArchivo+".json");
              //si ya tenemos los responses podemos solo llamar a leer
              //  leejson("data/response/"+nombreArchivo+".json.json");


              newRow.setString("label", label);
              println("LABEL:"+label +" count:"+cont);
            }
            //json
            // encoded64(String path) { >> nos da el link directo a la foto sin estar autenticados ni nada !!!
            //escribimos el json request.json con el nombre del archivo

            //
          }
       //---
        }
      }
    }
  }
 // println("----cont:"+cont);  
  saveTable(table, "data/data.csv");
  noLoop();
}

void draw() {
}