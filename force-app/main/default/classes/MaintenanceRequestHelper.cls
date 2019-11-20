public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> newCases, Map<Id,Case> oldCaseMap) {
        // TODO: Complete the method to update workorders
        List<Case> needGenerateCases = new List<Case>();
        for(Case newCase : newCases){
            Case oldCase = oldCaseMap.get(newCase.Id);
            if(newCase.Type == 'Repair' || newCase.Type == 'Routine Maintenance'){
                if(newCase.Status =='Closed' && oldCase.Status != 'Closed'){
                    needGenerateCases.add(newCase);
                }
            }
        }
        if(!needGenerateCases.isEmpty()){
            generateRoutineCheckupsByCase(needGenerateCases);
        }
        
    }

    public static void generateRoutineCheckupsByCase(List<Case> needGenerateCases){
        List<Case> futureRoutineCheckups = new List<Case>();
        List<Case> cases = [select Id, Subject, Origin, Vehicle__c, Equipment__c, Type, Date_Reported__c,  (select Id, Equipment__r.Maintenance_Cycle__c from Work_Parts__r
         order by Equipment__r.Maintenance_Cycle__c asc limit 1) from Case where id in :needGenerateCases];
        for(Case request : cases){
            Case futureRoutineCheckup = new Case();
            futureRoutineCheckup.Vehicle__c = request.Vehicle__c;
            futureRoutineCheckup.Type = 'Routine Maintenance';
            futureRoutineCheckup.Date_Reported__c = Date.today();
            futureRoutineCheckup.Subject = String.isBlank(request.Subject) ? 'Routine Checkup' : request.Subject;
            futureRoutineCheckup.Origin = request.Origin;
            futureRoutineCheckup.Equipment__c = request.Equipment__c;

            if(!request.Work_Parts__r.isEmpty()){
                Integer dueDays = Integer.valueOf(request.Work_Parts__r.get(0).Equipment__r.Maintenance_Cycle__c);
                if(dueDays != null){
                    futureRoutineCheckup.Date_Due__c = Date.today().addDays(dueDays);
                }
            }
            futureRoutineCheckups.add(futureRoutineCheckup);
        }
        if(!futureRoutineCheckups.isEmpty()){
            insert futureRoutineCheckups;
        }
    }
    
}