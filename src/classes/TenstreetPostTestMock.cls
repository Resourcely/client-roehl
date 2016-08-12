/* 
* This class simulates a Web Service response for testing.
* @author Mark Troupe
* @since 08.08.2016 (MM.dd.yyyy)
*/
@isTest
global class TenstreetPostTestMock implements HttpCalloutMock {

	global HTTPResponse respond(HTTPRequest req) {
        
    	String resBody;
        String emailAddr = req.getBody().substringBetween('<InternetEmailAddress>','</InternetEmailAddress>');
        Boolean isUpdate = req.getBody().contains('SubjectSearchData');

        if (emailAddr == 'match@test.com' && isUpdate){

			resBody = '<?xml version="1.0" encoding="UTF-8"?>' +
			'<TenstreetResponse>' +
			    '<Version>1.0</Version>' +
			    '<DateTime>' + system.now().format() + '</DateTime>' +
			    '<Mode>TEST</Mode>' +
			    '<DriverId>123456</DriverId>' +
			    '<DriverName>Mr Test</DriverName>' +
			    '<Status>ACCEPTED</Status>' +
			    '<Description>Record update.</Description>' +
			    '<FieldsUpdated>0</FieldsUpdated>' +
			'</TenstreetResponse>';

    	}else if (emailAddr == 'dontmatch@test.com' && isUpdate){
    		resBody = '<?xml version="1.0" encoding="UTF-8"?>' +
			'<TenstreetResponse>' +
			    '<Version>1.0</Version>' +
			    '<DateTime>' + system.now().format() + '</DateTime>' +
			    '<Mode>TEST</Mode>' +
			    '<DriverId></DriverId>' +
			    '<DriverName></DriverName>' +
			    '<Status>REJECTED</Status>' +
			    '<Description>Unable to find subject match based on SubjectSearchData provided.</Description>' +
			    '<FieldsUpdated>0</FieldsUpdated>' +
			'</TenstreetResponse>';

    	}else if (emailAddr == 'dontmatch@test.com' && !isUpdate){
    		resBody = '<?xml version="1.0" encoding="UTF-8"?>' +
			'<TenstreetResponse>' +
			    '<Version>1.0</Version>' +
			    '<DateTime>' + system.now().format() + '</DateTime>' +
			    '<Mode>TEST</Mode>' +
			    '<DriverId>987654</DriverId>' +
			    '<DriverName>Mr Test</DriverName>' +
			    '<Status>ACCEPTED</Status>' +
			    '<Description>New driver created.</Description>' +
			    '<FieldsUpdated>0</FieldsUpdated>' +
			'</TenstreetResponse>';

    	}
		
         
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(resBody);
		res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
   
}