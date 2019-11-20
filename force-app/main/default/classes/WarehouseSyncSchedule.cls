public with sharing class WarehouseSyncSchedule implements Schedulable {
    // implement scheduled code here
    public void execute(SchedulableContext sc) {
		WarehouseCalloutService.runWarehouseEquipmentSync();
	}
}


// system.schedule('Warehouse Sync Schedule Job', '0 0 1 * * ?', new WarehouseSyncSchedule());
