@istest
private class TestBatchPaymentDueMarker {

    static testmethod void test() {
        
      
       List<Account> aList = new List<Account>();
       
       for (Integer i=0;i<10;i++) {
            account a = new account();
            a.name='test account';
            aList.add(a);
       }
           insert aList;

       Test.startTest();
       BatchPaymentDueMarker bpdm= new BatchPaymentDueMarker();
       Database.executeBatch(bpdm);
       Test.stopTest();

       
       
    }
}