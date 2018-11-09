@isTest
global class ecEuropaTaxudViesServicesCheckVaTest implements WebServiceMock {
   global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType) {
           ecEuropaEuTaxudViesServicesCheckva.checkVatResponse_element cv = new ecEuropaEuTaxudViesServicesCheckva.checkVatResponse_element();
           cv.countryCode = 'IR';
           cv.vatnumber = '123456';
           cv.requestDate = date.today();
           cv.valid = true;
           cv.name = 'test';
           cv.address = 'NRSW';
       	   response.put('response_x', cv); 
   }
}