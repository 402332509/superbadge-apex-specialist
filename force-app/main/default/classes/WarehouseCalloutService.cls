public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        //ToDo: complete this method to make the callout (using @future) to the
        //      REST endpoint and update equipment on hand.
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');

        HttpResponse response = new Http().send(request);

        List<Equipment> equpiments = (List<Equipment>)JSON.deserialize(response.getBody(), List<Equipment>.class);
        List<Product2> pList = new List<Product2>();
        for(Equipment equipment : equpiments){
            if(equipment.replacement){
                Product2 p = new Product2(
                    Replacement_Part__c = true,
                    Cost__c = equipment.cost,
                    Name = equipment.name,
                    Current_Inventory__c = equipment.quantity,
                    Lifespan_Months__c = equipment.lifespan,
                    Maintenance_Cycle__c = equipment.maintenanceperiod,
                    Warehouse_SKU__c = equipment.sku
                );
                pList.add(p);
            }
        }
        if(!pList.isEmpty()){
            upsert pList Warehouse_SKU__c;
        }

    }

    public Class Equipment{
        public Boolean replacement {get;set;}
        public Integer quantity {get;set;}
        public String name {get;set;}
        public Integer maintenanceperiod {get;set;}
        public Integer lifespan {get;set;}
        public Decimal cost {get;set;}
        public String sku {get;set;}
    }
}