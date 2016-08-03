global class TenstreetListenerData {
	public String mode;

    public String companyId;

    public String driverId;

    public String source;
    public PersonalData personalData;

    public ApplicationData applicationData;

    public static Set<String> requiredCustomElements;

    public static TenstreetListenerData parseTenstreetData(String xmlString){
		
		requiredCustomElements = new Set<String>();
		requiredCustomElements.add('experience');
		requiredCustomElements.add('division');
		requiredCustomElements.add('disqualifiedReason');
		requiredCustomElements.add('declinedReason');
		requiredCustomElements.add('fleet');
		requiredCustomElements.add('rehireReligible');
		requiredCustomElements.add('applicationReferrerCode');
		requiredCustomElements.add('marketingFirstActivity');
		requiredCustomElements.add('marketingLastActivity');
		requiredCustomElements.add('marketingList');
		requiredCustomElements.add('marketingScore');
		requiredCustomElements.add('marketingGrade');
		TenstreetListenerData data;

		Dom.Document doc = new Dom.Document();
        doc.load(xmlString);

        if (doc.getRootElement().getName() == 'TenstreetData'){
        	data = new TenstreetListenerData();
	            
	        data.process(doc.getRootElement());
	    }

	    return data;
	}


    public void process(Dom.XmlNode inNode){



        for(Dom.XmlNode innerNode :inNode.getChildElements()){
            if(innerNode.getName() == 'DriverId'){
                driverId = innerNode.getText();
            } else if(innerNode.getName() ==  'CompanyId'){
                companyId = innerNode.getText();
            } else if(innerNode.getName() == 'PersonalData'){
            	personalData = new PersonalData();
            	personalData.process(innerNode);
            }else if(innerNode.getName() == 'ApplicationData'){
            	applicationData = new ApplicationData();
            	applicationData.process(innerNode);
            }
            
        }
    }





	global class ApplicationData{
		public String status;
		public String appSource;
		public String lastApplicationDate;

		public CustomDataElements customDataElements;

		public void process(Dom.XmlNode inNode){
	        for(Dom.XmlNode innerNode :inNode.getChildElements()){
	            if(innerNode.getName() ==  'Status'){
	                status = innerNode.getText();
	            }else if(innerNode.getName() == 'AppSource'){
	            	appSource = innerNode.getText();
	            }else if(innerNode.getName() == 'LastApplicationDate'){
	            	lastApplicationDate = innerNode.getText();
	            }else if(innerNode.getName() == 'CustomDataElements'){
            		customDataElements = new CustomDataElements();
            		customDataElements.process(innerNode);
            	}
            
	        }
	    }
	}

	global class CustomDataElements{

		public Map<String, CustomDataElement> customDataElementsMap;

		public void process(Dom.XmlNode inNode){
			customDataElementsMap = new Map<String, CustomDataElement>();
			for(Dom.XmlNode innerNode :inNode.getChildElements()){
	    		if(innerNode.getName() == 'CustomDataElement'){
	                CustomDataElement customDataElement = new CustomDataElement();
	                customDataElement.process(innerNode);
	                if (requiredCustomElements.contains(customDataElement.customDataId))
	                	customDataElementsMap.put(customDataElement.customDataId, customDataElement);
	            }
	        }
	    }
	}

	global class CustomDataElement{

		public String customDataValue;
		public String customDataPrompt;
		public String customDataId;

		public void process(Dom.XmlNode inNode){
	        for(Dom.XmlNode innerNode :inNode.getChildElements()){
	            if(innerNode.getName() == 'CustomDataId'){
	            	customDataId = innerNode.getText();

	            }
	            else if(innerNode.getName() == 'CustomDataValue'){
	            	customDataValue = innerNode.getText();
	           }
	            else if(innerNode.getName() == 'CustomDataPrompt'){
	            	customDataPrompt = innerNode.getText();
	            }
	        }
	    }
	}

	global class PersonalData{
		public PersonName personName;
		public PostalAddress postalAddress;
		public ContactData contactData;
		public CommunicationPreferences communicationPreferences;

		public void process(Dom.XmlNode inNode){
	        for(Dom.XmlNode innerNode :inNode.getChildElements()){
	            if(innerNode.getName() == 'PersonName'){
	            	personName = new PersonName();
	            	personName.process(innerNode);
	            }
	            else if(innerNode.getName() == 'PostalAddress'){
	            	postalAddress = new PostalAddress();
	            	postalAddress.process(innerNode);
	            }
	            else if(innerNode.getName() == 'ContactData'){
	            	contactData = new ContactData();
	            	contactData.process(innerNode);
	            }
	            else if(innerNode.getName() == 'CommunicationPreferences'){
	            	communicationPreferences = new CommunicationPreferences();
	            	communicationPreferences.process(innerNode);
	            }
	        }
	    }
	}

	global class CommunicationPreferences{

		public Boolean emailOptIn = false;
		public Boolean textOptIn = false;

		public void process(Dom.XmlNode inNode){
	        for(Dom.XmlNode innerNode :inNode.getChildElements()){


	        	if (innerNode.getAttributeCount() > 0) {

	  				for (Integer i = 0; i< innerNode.getAttributeCount(); i++ ) {
	  					system.debug(innerNode.getAttributeKeyAt(i));
	  					if (innerNode.getAttributeKeyAt(i) == 'media'){
	  						if (innerNode.getText() == 'opt_in'){
		  						if (innerNode.getAttributeValue(innerNode.getAttributeKeyAt(i), innerNode.getAttributeKeyNsAt(i)) == 'email')
		  							emailOptIn = true;
		  					
		  						else if (innerNode.getAttributeValue(innerNode.getAttributeKeyAt(i), innerNode.getAttributeKeyNsAt(i)) == 'text')
		  							textOptIn = true;
		  						
		  					}
	  					}

	    			}
	  			} 

			}


		}


	}

	global class ContactData{
		public String internetEmailAddress;
		public String primaryPhone;
		public String secondaryPhone;

		public void process(Dom.XmlNode inNode){
	        for(Dom.XmlNode innerNode :inNode.getChildElements()){
	            if(innerNode.getName() ==  'InternetEmailAddress'){
	                internetEmailAddress = innerNode.getText();
	            }else if(innerNode.getName() == 'PrimaryPhone'){
	            	primaryPhone = innerNode.getText();
	            }else if(innerNode.getName() == 'SecondaryPhone'){
	            	secondaryPhone = innerNode.getText();
	            }
	        }
	    }



	}

	global class PostalAddress{
		public String municipality;
		public String region;
		public String postalCode;
		public String address1;
		public String address2;

		public void process(Dom.XmlNode inNode){
	        for(Dom.XmlNode innerNode :inNode.getChildElements()){
	            if(innerNode.getName() ==  'Municipality'){
	                municipality = innerNode.getText();
	            }else if(innerNode.getName() == 'Region'){
	            	region = innerNode.getText();
	            }else if(innerNode.getName() == 'PostalCode'){
	            	postalCode = innerNode.getText();
	            }else if(innerNode.getName() == 'Address1'){
	            	address1 = innerNode.getText();
	            }else if(innerNode.getName() == 'Address2'){
	            	address2 = innerNode.getText();
	            }
	        }
	    }



	}

	global class PersonName{
	 	public String givenName;
	 	public String familyName;
		
		
		public String communicationPreference;
		
		public void process(Dom.XmlNode inNode){
	        for(Dom.XmlNode innerNode :inNode.getChildElements()){
	            if(innerNode.getName() ==  'GivenName'){
	                givenName = innerNode.getText();
	            }else if(innerNode.getName() == 'FamilyName'){
	            	familyName = innerNode.getText();
	            }
	        }
	    }

	}
}