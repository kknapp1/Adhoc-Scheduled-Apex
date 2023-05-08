trigger AdhocSchedule on AdhocSchedule__c (before insert, before update, before delete, after undelete) {
   AdhocScheduleHandler.runTriggers();
}