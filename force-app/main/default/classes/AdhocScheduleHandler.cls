public with sharing class AdhocScheduleHandler {
   public static void runTriggers() {
      switch on Trigger.operationType {
         when BEFORE_INSERT {
            AdhocSchedulerService.beforeInsert(Trigger.new);
         }
         when BEFORE_UPDATE {
            AdhocSchedulerService.beforeUpdate(Trigger.oldMap, Trigger.newMap);
         }
         when BEFORE_DELETE {
            AdhocSchedulerService.beforeDelete(Trigger.oldMap);
         }
         when AFTER_UNDELETE {
            AdhocSchedulerService.afterUndelete(Trigger.newMap);
         }
      }
   }
}