/* 
* Performs the web service POST to Tenstreet to update prospects
* with updated values from Tenstreet/Pardot
* @author Mark Troupe
* @since 08.08.2016 (MM.dd.yyyy)
*/
public with sharing class TenstreetPost {

    Tenstreet_API_Settings__c settings;
    Contact contact;


    
    public TenstreetPost(Contact contact) {
        
        this.settings = Tenstreet_API_Settings__c.getInstance();
        this.contact = contact;
    }

    /*public String generateInsertXML(){
        XmlStreamWriter xml = new XmlStreamWriter();

        xml.writeStartDocument('UTF-8', '1.0');
            xml.writeStartElement(null,'TenstreetData', null);
                xml.writeStartElement(null, 'Authentication', null);
                    writeNode('ClientId', settings.Client_Id__c, xml);
                    writeNode('Password', settings.Password__c, xml);
                    writeNode('Service', settings.Service_on_Insert__c, xml);
                xml.writeEndElement();
                writeNode('CompanyId', settings.Company_Id__c, xml);
                writeNode('CompanyName', settings.Company_Name__c, xml);
                writeNode('Mode', 'PROD', xml);
                writeNode('Source', 'Pardot', xml);

                xml.writeStartElement(null, 'PersonalData', null);
                    xml.writeStartElement(null, 'PersonName', null);
                        writeNode('GivenName', contact.FirstName, xml);
                        writeNode('FamilyName', contact.LastName, xml);
                    xml.writeEndElement();
                    xml.writeStartElement(null, 'PostalAddress', null);
                        writeNode('Municipality', contact.MailingCity, xml);
                        writeNode('Region', contact.MailingState, xml);
                        writeNode('PostalCode', contact.MailingPostalCode, xml);
                        String[] addrArray = checkNotNull(contact.MailingStreet).split('\n');
                        if (addrArray.size() > 0)
                            writeNode('Address1', addrArray[0], xml);
                        if (addrArray.size() > 1)
                            writeNode('Address2', addrArray[1], xml);
                    xml.writeEndElement();
                    xml.writeStartElement(null, 'ContactDate', null);
                        writeNode('InternetEmailAddress', contact.Email, xml);
                        writeNode('PrimaryPhone', contact.Phone, xml);
                        writeNode('SecondaryPhone', contact.OtherPhone, xml);
                    xml.writeEndElement();
                xml.writeEndElement();
        //<ContactData PreferredMethod="PrimaryPhone">
                xml.writeStartElement(null, 'ApplicationData', null);
                    writeNode('AppReferrer', 'Pardot', xml);
                xml.writeEndElement();
            xml.writeEndElement();
        xml.writeEndDocument();

        return xml.getXMLString();

    }*/

    public String generateUpdateXML(){

        XmlStreamWriter xml = new XmlStreamWriter();

        xml.writeStartDocument('UTF-8', '1.0');
            xml.writeStartElement(null,'TenstreetData', null);
                xml.writeStartElement(null, 'Authentication', null);
                    writeNode('ClientId', settings.Client_Id__c, xml);
                    writeNode('Password', settings.Password__c, xml);
                    writeNode('Service', settings.Service__c, xml);
                xml.writeEndElement();
                writeNode('CompanyId', settings.Company_Id__c, xml);
                writeNode('CompanyName', settings.Company_Name__c, xml);

                xml.writeStartElement(null, 'SubjectSearchData', null);
                    writeNode('DriverId', String.valueOf(contact.Driver_Id__c), xml);
                    //writeNode('InternetEmailAddress', contact.Email, xml);
                    //xml.writeStartElement(null, 'PersonName', null);
                    //    writeNode('FamilyName', contact.LastName, xml);
                    //xml.writeEndElement();
                xml.writeEndElement();


                xml.writeStartElement(null, 'UpdatedData', null);
                    xml.writeStartElement(null, 'CustomDataElements', null);

                        xml.writeStartElement(null, 'CustomDataElement', null);
                            writeNode('CustomDataPrompt', 'Marketing Score', xml);
                            writeNode('CustomDataValue', String.valueOf(contact.pi__score__c), xml);
                            writeNode('CustomDataId', 'marketingScore', xml);
                        xml.writeEndElement();

                        xml.writeStartElement(null, 'CustomDataElement', null);
                            writeNode('CustomDataPrompt', 'Marketing Grade', xml);
                            writeNode('CustomDataValue', String.valueOf(contact.pi__grade__c), xml);
                            writeNode('CustomDataId', 'marketingGrade', xml);
                        xml.writeEndElement();
                    xml.writeEndElement();
                xml.writeEndElement();



            xml.writeEndElement();
        xml.writeEndDocument();


        return xml.getXmlString();
    }

    private static String checkNotNull(String s){
        if (s == null)
            return '';
        else return s;
    }

    public Tenstreet_History__c doPost(){

    	Http http = new Http();

        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();

        request.setEndpoint(settings.URL__c);
        request.setMethod('POST');
        request.setHeader('Content-Type','text/xml');


        request.setBody(generateUpdateXML());

        system.debug(request.getBody());

        response = http.send(request);

        Tenstreet_History__c th = parseResponse(response);
        

        /* insert not required
        if (th.Description__c == 'Unable to find subject match based on SubjectSearchData provided.'){
            request.setBody(generateInsertXML());
            system.debug(request.getBody());

            response = http.send(request);
            th = parseResponse(response);
        }*/
        return th;


    }

    private void writeNode(String name, String value, XmlStreamWriter xml){
        xml.writeStartElement(null, name, null);
            xml.writeCharacters(checkNotNull(value));
        xml.writeEndElement();
    }

    private Tenstreet_History__c parseResponse(HttpResponse response){
        Tenstreet_History__c th = new Tenstreet_History__c();
        th.Contact__c = contact.Id;
        th.Action__c = 'Sent to Tenstreet';

        if (!String.isEmpty(response.getBody())){
        	th.Description__c = response.getBody().substringBetween('<Description>','</Description>');
        
			if (response.getBody().contains('ACCEPTED')){
	            th.Result__c = 'ACCEPTED';
	        }else if (response.getBody().contains('REJECTED')){
	            th.Result__c = 'REJECTED';
	        }
	    }else{
	    	th.Result__c = 'REJECTED';
	    	th.Description__c = response.getStatusCode() + ' ' + response.getStatus();
	    }
        return th;

    }
}