/**
 * @author KKnapp
 * @date 5/7/2023
 * @description Covers the trigger and the trigger handler through basic dml
 */
@IsTest
public class AdhocScheduleTest {

   @IsTest
   public static void insert_update_covers() {
      AdhocToolingAPICalloutMock mockAuthResponse = new AdhocToolingAPICalloutMock(
         200,
         'OK',
         'OK',
         new Map<String, String>()
      );
      Test.setMock(HttpCalloutMock.class, mockAuthResponse);

      Test.startTest();
      AdhocSchedule__c adhoc = new AdhocSchedule__c(Name = 'test');
      adhoc.CronString__c = '00 35 8 * * ? *';
      insert adhoc;

      // we get a lot of coverage by doing an update
      adhoc.Name = 'updatedTest';
      adhoc.CronString__c = '00 36 8 * * ? *';
      adhoc.Apex__c = 'System.debug(\'Hello World!\');';
      adhoc.Enabled__c = true;
      update adhoc;
      delete adhoc;
      undelete adhoc;
      Test.stopTest();
   }
}