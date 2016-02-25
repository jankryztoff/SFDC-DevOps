@isTest
public class WebServiceMockHandler {

public class WebServiceMockListMetaDataImpl implements WebServiceMock {
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
         
           MetadataService_V1.listMetadataResponse_element response_x = new  MetadataService_V1.listMetadataResponse_element();
           
           List<MetadataService_V1.FileProperties> reult=new List<MetadataService_V1.FileProperties>();
           MetadataService_V1.FileProperties obj=new MetadataService_V1.FileProperties();
           obj.fileName='Test';
           obj.fullName='fullName';
           reult.add(obj);
           
          response_x.result=reult;
          response.put('response_x', response_x); 
       
       }
   }
   
   
   
   public class WebServiceMockDescribeDataImpl implements WebServiceMock {
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
         
           MetadataService_V1.describeMetadataResponse_element response_x=new  MetadataService_V1.describeMetadataResponse_element();
           
           MetadataService_V1.DescribeMetadataResult result=new MetadataService_V1.DescribeMetadataResult();
           
           List<MetadataService_V1.DescribeMetadataObject> metadataObjects=new List<MetadataService_V1.DescribeMetadataObject>();
           
           MetadataService_V1.DescribeMetadataObject obj=new  MetadataService_V1.DescribeMetadataObject();
           obj.xmlName='Account';
           obj.inFolder=true;
           metadataObjects.add(obj);
          
            MetadataService_V1.DescribeMetadataObject obj2=new  MetadataService_V1.DescribeMetadataObject();
           obj2.xmlName='EmailTemplate';
           obj2.inFolder=true;
           metadataObjects.add(obj2); 
           
           result.metadataObjects=metadataObjects;
           response_x.result=result;
          
          response.put('response_x', response_x); 
       
       }
   }
   
   
   
   


}