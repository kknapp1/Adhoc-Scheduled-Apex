/**
 * @author KKnapp
 * @date 5/7/2023
 * @description Covers the trigger and the trigger handler through basic dml
 */
@IsTest
private class AdhocScheduleTest {
   @IsTest
   static void insert_update_covers() {
      Test.startTest();
      AdhocSchedule__c adhoc = new AdhocSchedule__c(Name = 'test');
      insert adhoc;
      adhoc.Name = 'updatedTest';
      update adhoc;
      delete adhoc;
      undelete adhoc;
      Test.stopTest();
   }
}