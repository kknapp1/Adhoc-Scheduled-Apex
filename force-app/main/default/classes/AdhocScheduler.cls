/**
 * @author KKnapp
 * @date 4/28/2023
 * @description 
 */
public without sharing class AdhocScheduler implements Schedulable {

   String sToExecute;

   @InvocableMethod
   public static void executeAdhoc(List<Id> adhocSchedulerIds){
      for (Id id : adhocSchedulerIds) {
         (new AdhocScheduler(id).runNow());
      }
   }

   public AdhocScheduler(String toExecute) {
      sToExecute = toExecute;
   }

   public AdhocScheduler(Id adhocId) {
      List<AdhocSchedule__c> records = AdhocSchedulerService.getRecordsById(new Set<Id>{adhocId});
      if (!records.isEmpty() && String.isNotBlank(records[0].Apex__c))
         sToExecute = records[0].Apex__c;
   }

   public void runNow() {
      AdhocToolingApiService.sendAnonApexAsync(sToExecute);
   }

   public void execute(SchedulableContext SC) {
      runNow();
   }

}