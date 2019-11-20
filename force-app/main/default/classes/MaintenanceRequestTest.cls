@isTest
public with sharing class MaintenanceRequestTest {
    @isTest
    static void testCloseCase(){
        Vehicle__c vehicle = new Vehicle__c(
            Name= 'Harry Test Vehicle'
        );
        insert vehicle;

        Product2 equipment = new Product2(
            Replacement_Part__c = true,
            Maintenance_Cycle__c = 180,
            Cost__c = 5000,
            Name = 'Harry Test Equipment',
            IsActive = true
        );
        insert equipment;

        Case newCase = new Case(
            Subject = 'repaire',
            Type='Routine Maintenance',
            Date_Reported__c = Date.today(),
            Origin = 'Phone'
        );
        insert newCase;

        Work_Part__c wp = new Work_Part__c(
            Maintenance_Request__c = newCase.Id,
            Equipment__c = equipment.Id
        );
        insert wp;

        Test.startTest();
        
        newCase.Status = 'Working';
        update newCase;
        System.assertEquals(0, [select Id from Case where Status='New' and Type='Routine Maintenance' and Date_Reported__c = TODAY].size());
        
        newCase.Status = 'Closed';
        update newCase;
        System.assertEquals(1, [select Id from Case where Status='New' and Type='Routine Maintenance' and Date_Reported__c = TODAY].size());
        Test.stopTest();
        
    }
}
