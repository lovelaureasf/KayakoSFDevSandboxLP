@isTest
public class SALLeadRejectionTest{


public static testMethod void positiveScenario(){

    lead l = new lead();
    l.Stage__c='SAL';
    l.Status='Open';
    l.firstName = 'test';
    l.lastName = 'test';
    l.company='test';
    insert l;
    List<lead>lList = new List<lead>();
    lList.add(l);
    ApexPages.StandardSetController sc = new ApexPages.StandardSetController(lList);
    sc.setSelected(lList);

    SALLeadRejection sl = new SALLeadRejection(sc);
    PageReference pageRef = Page.rejectleads;
    
    pageRef.getParameters().put('id', String.valueOf(l.Id));
    
    Test.setCurrentPage(pageRef);
    sl.proceed();
        



}


}