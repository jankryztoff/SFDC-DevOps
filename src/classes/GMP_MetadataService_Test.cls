/*
*                                                                                                *
*                            Version 1.00                                                        *
*                                                                                                *
* Creation Date: 1.Aug.2014                    Karan Khanna                                      *
* Last Modified: 1.Aug.2014                    Karan Khanna                                      *
*                                                                                                *
*                             © 2008 - Accenture - All Rights Reserved  *


*/

@isTest
public class GMP_MetadataService_Test {

// ============================================================================
// = T.E.S.T M.E.T.H.O.D
// ============================================================================
    
    static testmethod void MetadataService_Test() { 
        
        Test.setMock(WebServiceMock.class, new GMP_WebServiceMockMetadata_Test ());
        
        MetadataService.MetadataPort obj = new MetadataService.MetadataPort();
        
        MetadataService.DescribeMetadataResult dmr = obj.describeMetadata(30);
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
        MetadataService.FileProperties fp = new MetadataService.FileProperties();
        MetadataService.SessionHeader_element sh = new MetadataService.SessionHeader_element();
        MetadataService.DescribeMetadataResult dmrs = new MetadataService.DescribeMetadataResult();
        MetadataService.DescribeMetadataObject dmo = new MetadataService.DescribeMetadataObject();
        MetadataService.ListMetadataQuery lmq = new MetadataService.ListMetadataQuery();
        MetadataService.listMetadata_element lme = new MetadataService.listMetadata_element();
        MetadataService.listMetadataResponse_element lmre = new MetadataService.listMetadataResponse_element();                
        
    }
}