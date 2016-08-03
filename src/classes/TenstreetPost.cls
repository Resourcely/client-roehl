public with sharing class TenstreetPost {

	Tenstreet_API_Settings__c settings;
	
	public TenstreetPost() {
		
		settings = Tenstreet_API_Settings__c.getInstance();
	}

	public String generateXML(){

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
			xml.writeEndElement();
		xml.writeEndDocument();


		return xml.getXmlString();




	}

	public String doPost(){

		Http http = new Http();

		HttpRequest request = new HttpRequest();
		HttpResponse response = new HttpResponse();

		request.setEndpoint(settings.URL__c);
        request.setMethod('POST');
        request.setHeader('Content-Type','text/xml');


		request.setBody(generateXML());

		response = http.send(request);

		return response.getBody();


	}

	private void writeNode(String name, String value, XmlStreamWriter xml){
		xml.writeStartElement(null, name, null);
			xml.writeCharacters(value);
		xml.writeEndElement();
	}
}