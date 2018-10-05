// This function returns all the files in a directory as an array of Strings  
import org.apache.commons.codec.binary.Base64;
import java.io.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

PImage decoded;
String encoded = "";
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


void encoded64(String path) {
  String fileLocation = path;
  // println("path"+fileLocation);

  try {
    encoded = encodeToBase64(fileLocation);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }

  try {
    decoded = DecodePImageFromBase64(encoded);
  } 
  catch (IOException e) {
    println(e);
  }

  String [] arrayForSave = {encoded};
  saveStrings("encoded.txt", arrayForSave);
}



private String encodeToBase64(String fileLoc) throws IOException, FileNotFoundException {

  File originalFile = new File(fileLoc);
  String encodedBase64 = null;

  FileInputStream fileInputStreamReader = new FileInputStream(originalFile);
  byte[] bytes = new byte[(int)originalFile.length()];
  fileInputStreamReader.read(bytes);
  encodedBase64 = new String(Base64.encodeBase64(bytes));
  fileInputStreamReader.close();

  return encodedBase64;
}

public PImage DecodePImageFromBase64(String i_Image64) throws IOException
{
  PImage result = null;
  byte[] decodedBytes = Base64.decodeBase64(i_Image64);

  ByteArrayInputStream in = new ByteArrayInputStream(decodedBytes);
  BufferedImage bImageFromConvert = ImageIO.read(in);
  BufferedImage convertedImg = new BufferedImage(bImageFromConvert.getWidth(), bImageFromConvert.getHeight(), BufferedImage.TYPE_INT_ARGB);
  convertedImg.getGraphics().drawImage(bImageFromConvert, 0, 0, null);
  result = new PImage(convertedImg);

  return result;
}