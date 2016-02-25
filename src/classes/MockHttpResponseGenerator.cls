/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
 public Integer statusCode;
 
 public MockHttpResponseGenerator(Integer statusCode){
    this.statusCode=statusCode;
 }
   global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        
       /* res.setHeader('Content-Type', 'text/xml');
        res.setBody('<SiebelLinkResult><StatusCode>0</StatusCode><StatusMessage/><SsoKey>SSO-A0DB6E78663559679B2A8D188C816E63</SsoKey></SiebelLinkResult>');*/
        res.setStatusCode(statusCode);
        return res;
        
        
          
          
    }
}