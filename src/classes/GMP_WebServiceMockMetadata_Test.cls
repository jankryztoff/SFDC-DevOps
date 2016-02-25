/*
*                                                                                                 *
*                            Version 1.00                                                         *
*                                                                                                 *
* Creation Date: 1.Aug.2014                    Karan Khanna                                      *
* Last Modified: 1.Aug.2014                    Karan Khanna                                      *
*                                                                                                 *
*                             © 2008 - Accenture - All Rights Reserved  *


*/

@isTest
public class GMP_WebServiceMockMetadata_Test implements WebServiceMock {

// ============================================================================
// = T.E.S.T M.E.T.H.O.D
// ============================================================================
    
    public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
       
        MetadataService.describeMetadataResponse_element respElement = new MetadataService.describeMetadataResponse_element();
        
        response.put('response_x', respElement); 
   }
}