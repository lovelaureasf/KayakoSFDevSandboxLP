@isTest
private class EuWebServiceCalloutTest {
         @istest static void testEchoString() { 
			Test.setMock(WebServiceMock.class, new ecEuropaTaxudViesServicesCheckVaTest());             
        	// This causes a fake response to be generated
        	ecEuropaEuTaxudViesServicesCheckva.checkVatPort check = new ecEuropaEuTaxudViesServicesCheckva.checkVatPort();
        	String echo = String.valueOf(check.checkVat('IR', '123456'));
			 //echo = String.valueOf(check.checkVATApprox('1','2','3','4','5','6','7','8','9'));
        
        
    }
}