/**
 * @author KKnapp
 * @date 5/15/2023
 * @description 
 */
   @isTest
   public class AdhocToolingAPICalloutMock implements HttpCalloutMock {
      protected Integer code;
      protected String status;
      protected String body;
      protected Map<String, String> responseHeaders;
      public AdhocToolingAPICalloutMock(Integer code, String status, String body, Map<String, String> responseHeaders) {
         this.code = code;
         this.status = status;
         this.body = body;
         this.responseHeaders = responseHeaders;
      }
      public HTTPResponse respond(HTTPRequest req) {
         HttpResponse res = new HttpResponse();
         for (String key : this.responseHeaders.keySet()) {
            res.setHeader(key, this.responseHeaders.get(key));
         }
         res.setBody(this.body);
         res.setStatusCode(this.code);
         res.setStatus(this.status);
         return res;
      }

      public String getBody(){
         return body;
      }
      public String getStatus(){
         return status;
      }
      public Integer getStatusCode(){
         return code;
      }
}