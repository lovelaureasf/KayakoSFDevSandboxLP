@isTest
private class TestBatchLeadAssignmentSAL {

    static testmethod void test() {
        // getting the user who is going to create the data - Backend Kayako
        List<user> userList = new List<user>();
        userList = [select id,name from user where name='Backend Kayako'];

       // Creating some test leads
       List<lead> lList = new List<lead>();
       for (Integer i=0;i<10;i++) {
           lead l = new lead();
            l.lastname='test lead';
            l.email='test@test.com';
            //l.phone='+51';
            l.company='abc';
            l.ownerId=userList[0].id; 
            l.leadsource = 'Unknown';
            lList.add(l);
            
       }
       insert lList;
     

       	Test.startTest();
        	List<AsyncApexJob> listJob = [ Select id ,Status, ApexClass.Name from AsyncApexJob where Status='Running'];
        	if(listJob == null || listJob.size() ==0 ) {
                BatchLeadAssignmentSAL bla= new BatchLeadAssignmentSAL();
                Database.executeBatch(bla);
            }
        Test.stopTest();
	}
}