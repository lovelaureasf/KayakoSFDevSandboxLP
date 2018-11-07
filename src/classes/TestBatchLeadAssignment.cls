@isTest(SeeAllData = false)
private class TestBatchLeadAssignment {
	static testmethod void test_RunBatchForLeadAssignment() {
        
        User u = [Select Id, Name from user where Name = 'Backend Kayako' limit 1];
		
        System.runAs(u) {
            Lead objLead = new Lead(Company = 'JohnMiller', LastName = 'Mike', Status = 'Open', Stage__c = 'MQL',leadSource = 'Web');
            insert objLead;   
            Test.startTest();
            List<AsyncApexJob> listJob = [ Select id ,Status, ApexClass.Name from AsyncApexJob where Status='Running'];
        	if(listJob == null || listJob.size() ==0 ) {
                BatchLeadAssignment bla= new BatchLeadAssignment();
                Database.executeBatch(bla);
            }
            Test.stopTest();
        }
    }
}