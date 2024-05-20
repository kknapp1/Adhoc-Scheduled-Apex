/**
 * @author KKnapp
 * @date 5/31/2023
 * @description This is only here to follow naming conventions so that the CICD job will pick it up and run
 */
@IsTest
private class AdhocSchedulerTest {
   @IsTest
   static void checkCoverage() {
       AdhocScheduleTest.insert_update_covers();
   }
}