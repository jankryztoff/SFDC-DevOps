@isTest
private class Test_ProjectBuilderLoginController {
//Method to test ProjectBuilderLoginController class.
static testMethod void myUnitTest(){   
     //Entering record in the Merril_URL_Detail__c custom setting.             
     Authorization_URL__c  objAuth=new  Authorization_URL__c();             
     objAuth.Name='Auth_Url_'+System.now().getTime();              
     objAuth.CallBack_URL__c='https://mcwebtest-nwd.iscorp.com/nationwide2/services/SiebelSSO';             
     objAuth.Client_Secret__c='http://10.215.53.6/nationwide2/link.do';
     objAuth.Consumer_Key__c='http://10.215.53.6/nationwide2/link.do';             
     Database.insert(objAuth) ;
     
     Profile p = [select id 
                         from profile where name = 'System Administrator'];
        User u1 = new User(alias = 'free01',
                           email = 'user101@testorg.com',
                           lastname = 'Testing',
                           emailencodingkey = 'UTF-8',
                           companyname = 'testorg',
                           languagelocalekey = 'en_US',
                           localesidkey = 'en_US',
                           profileId = p.Id,
                           timezonesidkey = 'America/Los_Angeles',
                           username = 'chatterfreeuser101@testorg.com');
        insert u1;
        
    Test.startTest();    
        System.runas(u1){ 
            //Creating an instance of ProjectBuilderLoginController class.
            ApexPages.Currentpage().getParameters().put('code', '200');   
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200));
             
            ProjectBuilderLoginController proBuild = new ProjectBuilderLoginController();
            proBuild.strDomain='login.salesforce.com';
            proBuild.isErrorFound=false;
            proBuild.getDomainDetail();
            
            proBuild.validateLoginDetail();//it will cover if condition
            proBuild.strUserType='guest';
            proBuild.validateLoginDetail();
            
            proBuild.getURLToRedirect();
            proBuild.getAuthorizationURL();
            proBuild.redirectToPage();   
        }
          
    Test.stopTest();
}
}