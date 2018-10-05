Boolean isWebDetection = true;
Boolean isLabelDetection  =true;
Boolean isLandMarkDetection  =true;

String label = "";
void creajson(String imagen, Boolean isBase64, String nombreJson) {
  JSONObject image = new JSONObject();
  JSONObject source = new JSONObject();
  JSONObject requestO = new JSONObject();
  json = new JSONObject();
  requestO = new JSONObject();
  JSONArray features = new JSONArray();
  int contA = 0;
  JSONObject labelDetection = new JSONObject();
  if (isWebDetection) {

    JSONObject webDetection = new JSONObject();
    webDetection.setString("type", "WEB_DETECTION");
    webDetection.setInt("maxResults", 10);
    features.setJSONObject(contA, webDetection);
    contA++;
  }
  if (isLabelDetection) {
    labelDetection.setString("type", "LABEL_DETECTION");
    labelDetection.setInt("maxResults", 10);
    features.setJSONObject(contA, labelDetection);
    contA++;
  }
  if (isLandMarkDetection) {

    JSONObject landMark = new JSONObject();
    landMark.setString("type", "LANDMARK_DETECTION");
    features.setJSONObject(2, landMark);
  }


  JSONArray requests = new JSONArray();
  json.setJSONArray("requests", requests);

  if (isBase64) {
    source.setString("content", imagen);
    requestO.setJSONObject("image", source);
  } else
  {
    source.setString("imageUri", imagen);
    image.setJSONObject("source", source);
    requestO.setJSONObject("image", image);
  }

  requestO.setJSONArray("features", features);
  requests.setJSONObject(0, requestO);
  saveJSONObject(json, "data/request/"+nombreJson+".json");
}

void mandajson(String POSTurl, JSONObject json, String nombreArchivo) {
  try {
    PostRequest post = new PostRequest(POSTurl);
    post.addHeader("Content-Type", "application/json");
    post.addJson(json.toString());
    post.send();
    //System.out.println("Reponse Content:" + post.getContent() + "\n");
    //System.out.println("Reponse Content-Length Header: " + post.getHeader("Content-Length"));
    JSONObject response = parseJSONObject(post.getContent());
    // 
    saveJSONObject(response, "data/response/"+nombreArchivo+".json");
    leejson("data/response/"+nombreArchivo+".json");
  } 
  catch(RuntimeException e) {
    e.getCause();
  }
}
void leejson( String jsonString) {
  // println("path;"+jsonString);
  JSONObject jsonlocal ;
  try {
    jsonlocal = loadJSONObject(jsonString);

    JSONArray responsess =  jsonlocal.getJSONArray("responses");
    // println("-------response: "+responsess.size());

    if (isWebDetection ) {
      JSONObject r1 = responsess.getJSONObject(0);
      JSONObject web = r1.getJSONObject("webDetection");
     // println("-------response: "+r1);
      JSONArray urls =  web.getJSONArray("visuallySimilarImages");

      for (int i=0; i<urls.size(); i++) {
        JSONObject url = urls.getJSONObject(i);
        //println( url.getString("url"));
        //imagenes[i] = loadImage( url.getString("url"));
      }
    }
    if (isLabelDetection ) {
      JSONObject r1 = responsess.getJSONObject(0);
      JSONArray web = r1.getJSONArray("labelAnnotations");
      println("-------response: "+web.size());
      // String  urls =  web[0].getString("description");
      label  = "";
      for (int i=0; i<web.size(); i++) {
        //solo coge una
        JSONObject url = web.getJSONObject(i);
        if (i > 0 ) label = label +","+ url.getString("description")+"("+ url.getFloat("score")+")";
        else  label = url.getString("description")+"("+ url.getFloat("score")+")";
      }
    }
  } 
  catch(RuntimeException e) {
    e.getCause();
  }
}