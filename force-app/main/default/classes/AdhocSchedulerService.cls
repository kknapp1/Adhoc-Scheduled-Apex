/**
 * @author KKnapp
 * @date 5/6/2023
 * @description 
 */
public without sharing class AdhocSchedulerService {
   private static String getJobName(AdhocSchedule__c adhoc) {
      return 'adhoc_' + adhoc.Name + '_' + Datetime.now().millisecond();
   }

   public static List<AdhocSchedule__c> getRecordsById(Set<Id> adhocIds) {
      return [SELECT Name, CronString__c, Apex__c, ScheduledJobId__c FROM AdhocSchedule__c WHERE Id IN :adhocIds];
   }

   @Future
   public static void afterUndeleteAsync(Set<Id> adhocIds) {
      List<AdhocSchedule__c> adhocSchedules = getRecordsById(adhocIds);
      List<AdhocSchedule__c> adhocToUpdate = new List<AdhocSchedule__c>();
      String jobId;
      for (AdhocSchedule__c adhoc : adhocSchedules) {
         unScheduleIt(adhoc);
         jobId = scheduleIt(adhoc);
         adhoc.ScheduledJobId__c = jobId;
         adhocToUpdate.add(adhoc);
      }
      update adhocToUpdate;
   }

   public static void afterUndelete(Map<Id, SObject> sObjectsByIds) {
      // weird b/c we need to schedule then update, but undeleted records are read-only
      afterUndeleteAsync(sObjectsByIds.keySet());
   }

   public static void beforeDelete(Map<Id, SObject> sObjectsByIds) {
      for (SObject sobj : sObjectsByIds.values()) {
         AdhocSchedule__c oldRecord = (AdhocSchedule__c) sobj;
         unScheduleIt(oldRecord);
      }
   }

   public static void beforeInsert(List<AdhocSchedule__c> adhocSchedules) {
      for (AdhocSchedule__c newRecord : adhocSchedules) {
         //AdhocSchedule__c newRecord = (AdhocSchedule__c) sobj;

         // If it's ENabled
         if (newRecord.Enabled__c) {
            String jobId = scheduleIt(newRecord);
            newRecord.ScheduledJobId__c = jobId;
         }
      }
   }

   public static void beforeUpdate(Map<Id, SObject> oldMap, Map<Id, SObject> newMap) {
      for (SObject sobj : oldMap.values()) {
         AdhocSchedule__c oldRecord = (AdhocSchedule__c) sobj;
         AdhocSchedule__c newRecord = (AdhocSchedule__c) newMap.get(sobj.Id);

         // If it was ENabled
         if (!oldRecord.Enabled__c && newRecord.Enabled__c) {
            String jobId = scheduleIt(newRecord);
            newRecord.ScheduledJobId__c = jobId;
         }
         // If it was DISabled
         if (oldRecord.Enabled__c && !newRecord.Enabled__c) {
            unScheduleIt(newRecord);
            newRecord.ScheduledJobId__c = null;
         }

         if (newRecord.Enabled__c) {
            // if the cron string or the apex changed
            if ((oldRecord.CronString__c != newRecord.CronString__c)
               || (oldRecord.Apex__c != newRecord.Apex__c)) {
               String jobId = reScheduleIt(newRecord);
               newRecord.ScheduledJobId__c = jobId;
            }
         }
      }
   }

   public static String reScheduleIt(AdhocSchedule__c adhoc) {
      unScheduleIt(adhoc);
      return scheduleIt(adhoc);
   }

   public static void unScheduleIt(AdhocSchedule__c adhoc) {
      if (String.isBlank(adhoc.ScheduledJobId__c))
         return;
      try {
         System.abortJob(adhoc.ScheduledJobId__c);
      } catch (StringException e) {
         if (e.getMessage() == 'Job does not exist or is already aborted.') {
            //no worries
         } else {
            throw e;
         }
      }
      return;
   }

   public static String scheduleIt(AdhocSchedule__c adhoc) {
      if (String.isBlank(adhoc.CronString__c))
         return null;
      String scheduledJobId = System.schedule(getJobName(adhoc), adhoc.CronString__c, new AdhocScheduler(adhoc.Id));
      return scheduledJobId;
   }

}