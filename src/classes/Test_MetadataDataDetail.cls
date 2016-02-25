@isTest
private class Test_MetadataDataDetail {  
    static testMethod void testMetadataDataDetail(){
            ApexPages.Currentpage().getParameters().put('node', 'root');   
            Test.setMock(WebServiceMock.class, new WebServiceMockHandler.WebServiceMockDescribeDataImpl ());
             MetadataDataDetail Metadtl = new MetadataDataDetail();
             Metadtl.constructResponse();
             //Metadtl.createProjectXMLFile();     
    }
      static testMethod void testMetadataDataDetail2(){
          ApexPages.Currentpage().getParameters().put('node', 'Account');
            Test.setMock(WebServiceMock.class, new WebServiceMockHandler.WebServiceMockListMetaDataImpl ());
             MetadataDataDetail Metadtl = new MetadataDataDetail();
             Metadtl.constructResponse();
      
      }
    
}