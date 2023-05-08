/**
 * @author KKnapp
 * @date 4/25/2023
 * @description
 */
public without sharing class AdhocToolingApiService {

   @TestVisible static String currentVer {
      get {
         return 'v57.0'; //TODO: It would be nice to make this dynamic
      }
      private set;
   }

   @Future(Callout = true)
   public static void sendAnonApexAsync(String anonApex){
      sendAnonApex(anonApex);
   }

   public static void sendAnonApex(String anonApex) {
      String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
      String encodedAnon = EncodingUtil.urlEncode(anonApex, 'UTF-8');
      String request = baseURL + '/services/data/'+currentVer+'/tooling/executeAnonymous?' +
         'anonymousBody=' + encodedAnon;

      String body = restGet(request,
         'GET', UserInfo.getSessionId());

      System.debug(LoggingLevel.ERROR, body);
      String metadata = body.substringBetween('"Metadata":{"', '}}]}');
      System.debug(LoggingLevel.ERROR, metadata);
   }

   static String restGet(String endPoint, String method, String sid) {
      Http h = new Http();
      HttpRequest hr = new HttpRequest();
      hr.setHeader('Authorization', 'Bearer ' + sid);
      hr.setTimeout(60000);
      hr.setEndpoint(endPoint);
      hr.setMethod(method);
      HttpResponse r = h.send(hr);
      return r.getBody();
   }

}