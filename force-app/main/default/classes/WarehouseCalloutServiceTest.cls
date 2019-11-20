@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @IsTest
    static void testCallout(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        
    }

    @IsTest
    static void methodName(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        system.schedule('Warehouse Sync Schedule Job', '0 0 1 * * ?', new WarehouseSyncSchedule());
        Test.stopTest();
        
    }
}