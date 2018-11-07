@isTest(SeeAllData = true)
public class TestCheckPrimaryBeforeInsert {
    public static testMethod void positiveScenario(){
        
       zqu__QuoteRatePlanCharge__c qrq = [SELECT Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,SystemModstamp,zqu__Apply_Discount_To_One_Time_Charges__c,zqu__Apply_Discount_To_Recurring_Charges__c,zqu__Apply_Discount_To_Usage_Charges__c,zqu__BillCycleDay__c,zqu__BillCycleType__c,zqu__BillingPeriodAlignment__c,zqu__ChargeType__c,zqu__Currency__c,zqu__Description__c,zqu__Discount_Level__c,zqu__Discount__c,zqu__EffectivePrice__c,zqu__FeeType__c,zqu__IncludedUnits__c,zqu__ListPrice__c,zqu__ListTotal__c,zqu__Model__c,zqu__MRR__c,zqu__Period__c,zqu__PreviewedMRR__c,zqu__PreviewedTCV__c,zqu__ProductRatePlanChargeZuoraId__c,zqu__ProductRatePlanCharge__c,zqu__Quantity__c,zqu__QuoteRatePlanChargeZuoraId__c,zqu__QuoteRatePlan__c,zqu__SpecificBillingPeriod__c,zqu__SubscriptionRatePlanChargeZuoraId__c,zqu__TCV__c,zqu__Total__c,zqu__TriggerDate__c,zqu__TriggerEvent__c,zqu__UOM__c,zqu__Upto_How_Many_Periods__c FROM zqu__QuoteRatePlanCharge__c limit 1]; 
        
       zqu__QuoteRatePlanCharge__c qrpc = new  zqu__QuoteRatePlanCharge__c();
       qrpc.Name = qrq.Name;
       qrpc.zqu__Apply_Discount_To_One_Time_Charges__c = qrq.zqu__Apply_Discount_To_One_Time_Charges__c;
       qrpc.zqu__Apply_Discount_To_Recurring_Charges__c = qrq.zqu__Apply_Discount_To_Recurring_Charges__c;
       qrpc.zqu__Apply_Discount_To_Usage_Charges__c = qrq.zqu__Apply_Discount_To_Usage_Charges__c;
       qrpc.zqu__QuoteRatePlan__c = qrq.zqu__QuoteRatePlan__c; 
       qrpc.zqu__ProductRatePlanCharge__c = qrq.zqu__ProductRatePlanCharge__c;
       qrpc.zqu__ProductRatePlanChargeZuoraId__c = qrq.zqu__ProductRatePlanChargeZuoraId__c;
       qrpc.zqu__QuoteRatePlan__c  =  qrq.zqu__QuoteRatePlan__c; 
       insert qrpc;        
        
        
        
    }    
}