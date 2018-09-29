/**
 * Script para sacar los datos de las imagenes de google y extraer en un csv el ditulo, numero de visitas y la fecha
 */
Table table; //tabla para guardar los datos que necesitamos
import java.util.Date;
JSONArray values;
int cont = 0;
JSONObject json;
void setup() {

  // Using just the path of this sketch to demonstrate,
  // but you can list any directory you like.
  String path = sketchPath();
  table = new Table();

  table.addColumn("title");
 // table.addColumn("imageViews");
  table.addColumn("timestamp"); //photoTakenTime
  table.addColumn("timestampU"); //photoTakenTime Unix
  table.addColumn("latitud"); //photoTakenTime Unix
  table.addColumn("longitud"); //photoTakenTime Unix




  String[] filenames = listFileNames(path);
  ArrayList<File> allFiles = listFilesRecursive(path);

  for (File f : allFiles) {


    // println("Is directory: " + f.isDirectory());
    if (!f.isDirectory()) {
      String[] list = split(f.getName(), '.');

      if (list.length>2) {
        String extension = list[2];

        if (extension.equals("json") == true) {
          /*  println("Extension: " + extension);
           println("Name: " + f.getName());
           
           println("Full path: " + f.getAbsolutePath());
           println("--------JSON-----");*/
          // Entramos en el archivo para recoger los datos que necesitamos

          json = loadJSONObject(f.getAbsolutePath());

          int imagesViews = json.getInt("imageViews");
          // String species = json.getString("species");
          //String name = json.getString("name");
          JSONObject childTime = json.getJSONObject("photoTakenTime");
          JSONObject geoData = json.getJSONObject("geoData");




          //escribimos en el csv
          TableRow newRow = table.addRow();
          newRow.setString("title", list[0]+"."+list[1]);
         // newRow.setInt("imageViews", imagesViews);
          newRow.setString("timestamp", childTime.getString("formatted"));
          newRow.setString("timestampU", childTime.getString("timestamp"));
          newRow.setDouble("latitud", geoData.getDouble("latitude"));
          newRow.setDouble("longitud", geoData.getDouble("longitude"));
          cont++;
        }
      }
    }
  }
  println("----cont:"+cont);  
  saveTable(table, "data/data.csv");
  noLoop();
}

void draw() {
}

// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

// Function to get a list of all files in a directory and all subdirectories
ArrayList<File> listFilesRecursive(String dir) {
  ArrayList<File> fileList = new ArrayList<File>(); 
  recurseDir(fileList, dir);
  return fileList;
}

// Recursive function to traverse subdirectories
void recurseDir(ArrayList<File> a, String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    // If you want to include directories in the list
    a.add(file);  
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      // Call this function on all files in this directory
      recurseDir(a, subfiles[i].getAbsolutePath());
    }
  } else {
    a.add(file);
  }
}
