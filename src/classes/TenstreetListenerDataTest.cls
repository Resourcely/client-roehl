/* 
* Test class for TenstreetListenerData class, testing that the class parses 
* the XML correctly
* @author Mark Troupe
* @since 08.08.2016 (MM.dd.yyyy)
*/
@isTest
public with sharing class TenstreetListenerDataTest{
 
	public static testMethod void testParsing(){

		TenstreetListenerData data = TenstreetListenerData.parseTenstreetData(testXML);

		system.assertEquals('20193181',data.driverId);
		system.assertEquals('1183', data.companyId);
		system.assertEquals('Mark', data.personalData.PersonName.GivenName);
		system.assertEquals('Troupe', data.personalData.PersonName.FamilyName);

		system.assertEquals('Lincoln Park', data.personalData.PostalAddress.Municipality);
		system.assertEquals('MI', data.personalData.PostalAddress.Region);
		system.assertEquals('48146', data.personalData.PostalAddress.PostalCode);
		system.assertEquals('2166 Council Av', data.personalData.PostalAddress.Address1);
		system.assertEquals('My House', data.personalData.PostalAddress.Address2);

		system.assertEquals('zzzz1984@yahoo.com', data.personalData.ContactData.InternetEmailAddress);
		system.assertEquals('313-555-4045', data.personalData.ContactData.PrimaryPhone);
		system.assertEquals('555-7777', data.personalData.ContactData.SecondaryPhone);

		system.assertEquals(true, data.personalData.communicationPreferences.emailOptIn);
		system.assertEquals(false, data.personalData.communicationPreferences.textOptIn);
		system.assertEquals('Declined', data.applicationData.status);
		system.assertEquals('IntelliApp - GYCDL', data.applicationData.appSource);
		system.assertEquals('2016-07-26 02:25:10', data.applicationData.lastApplicationDate);

		system.assertEquals('Get Your CDL', data.applicationData.CustomDataElements.customDataElementsMap.get('experience'));
		system.assertEquals('NOT FOUND ON APPLICATION', data.applicationData.CustomDataElements.customDataElementsMap.get('division'));
		system.assertEquals('', data.applicationData.CustomDataElements.customDataElementsMap.get('disqualifiedReason'));
		system.assertEquals('No Reply', data.applicationData.CustomDataElements.customDataElementsMap.get('declinedReason'));
		system.assertEquals('NOT FOUND ON APPLICATION', data.applicationData.CustomDataElements.customDataElementsMap.get('fleet'));
		system.assertEquals('', data.applicationData.CustomDataElements.customDataElementsMap.get('rehireReligible'));
		system.assertEquals('direct', data.applicationData.CustomDataElements.customDataElementsMap.get('applicationReferrerCode'));
		system.assertEquals('', data.applicationData.CustomDataElements.customDataElementsMap.get('marketingFirstActivity'));
		system.assertEquals('', data.applicationData.CustomDataElements.customDataElementsMap.get('marketingLastActivity'));
		system.assertEquals('', data.applicationData.CustomDataElements.customDataElementsMap.get('marketingList'));
		system.assertEquals('', data.applicationData.CustomDataElements.customDataElementsMap.get('marketingScore'));
		system.assertEquals('', data.applicationData.CustomDataElements.customDataElementsMap.get('marketingGrade'));

	}

	static String testXML = '<?xml version="1.0" encoding="UTF-8"?>' +
'<TenstreetData>' +
'  <Mode>PROD</Mode>' +
'  <DriverId>20193181</DriverId>' +
'  <CompanyId>1183</CompanyId>' +
'  <Source>Tenstreet</Source>' +
'  <InitiatedByUser>Kesha Kopca</InitiatedByUser>' +
'  <InitiatedByUserEmail>kesha.kopca@roehl.net</InitiatedByUserEmail>' +
'  <PersonalData>' +
'    <PersonName>' +
'      <Prefix/>' +
'      <GivenName>Mark</GivenName>' +
'      <MiddleName>Shaun</MiddleName>' +
'      <FamilyName>Troupe</FamilyName>' +
'      <Affix/>' +
'    </PersonName>' +
'    <PostalAddress>' +
'      <CountryCode>US</CountryCode>' +
'      <Municipality>Lincoln Park</Municipality>' +
'      <Region>MI</Region>' +
'      <PostalCode>48146</PostalCode>' +
'      <Address1>2166 Council Av</Address1>' +
'      <Address2>My House</Address2>' +
'    </PostalAddress>' +
'    <AllPostalAddresses residence_address_more_than_x_years="yes"/>' +
'    <GovernmentID countryCode="US" issuingAuthority="SSA" documentType="SSN">snipped</GovernmentID>' +
'    <DateOfBirth>snipped</DateOfBirth>' +
'    <ContactData PreferredMethod="PrimaryPhone" PreferredTime="Any">' +
'      <InternetEmailAddress>zzzz1984@yahoo.com</InternetEmailAddress>' +
'      <PrimaryPhone>313-555-4045</PrimaryPhone>' +
'      <SecondaryPhone>555-7777</SecondaryPhone>' +
'    </ContactData>' +
'    <CommunicationPreferences>' +
'      <CommunicationPreference media="email">opt_in</CommunicationPreference>' +
'      <CommunicationPreference media="text">opt_out</CommunicationPreference>' +
'    </CommunicationPreferences>' +
'  </PersonalData>' +
'  <ApplicationData>' +
'    <LastApplicationId>50774385</LastApplicationId>' +
'    <Worklist/>' +
'    <WorklistInfo/>' +
'    <WorklistGroup/>' +
'    <AppReferrer>direct</AppReferrer>' +
'    <MarketingOptIn>opt_in</MarketingOptIn>' +
'    <DriverScore>200</DriverScore>' +
'    <Status>Declined</Status>' +
'    <AppSource>IntelliApp - GYCDL</AppSource>' +
'    <LastApplicationDate>2016-07-26 02:25:10</LastApplicationDate>' +
'    <AppSourceHistory>' +
'      <AppSources>' +
'        <AppSourceName>IntelliApp - GYCDL</AppSourceName>' +
'        <AppSourceDate>2016-07-26 02:25:00</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>RoehlGYCDLLead</AppSourceName>' +
'        <AppSourceDate>2016-07-26 02:09:53</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>RoehlJobsLead</AppSourceName>' +
'        <AppSourceDate>2016-07-26 02:07:42</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>IntelliApp - GYCDL</AppSourceName>' +
'        <AppSourceDate>2016-04-21 12:16:11</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>RoehlGYCDLLead</AppSourceName>' +
'        <AppSourceDate>2016-04-21 11:50:46</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>RoehlJobsLead</AppSourceName>' +
'        <AppSourceDate>2016-04-21 11:46:49</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>Update</AppSourceName>' +
'        <AppSourceDate>2016-03-17 11:01:32</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>Update</AppSourceName>' +
'        <AppSourceDate>2016-03-17 11:00:46</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>IntelliApp - GYCDL</AppSourceName>' +
'        <AppSourceDate>2016-02-28 01:32:21</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>RoehlGYCDLLead</AppSourceName>' +
'        <AppSourceDate>2016-02-27 18:28:21</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>RoehlJobsLead</AppSourceName>' +
'        <AppSourceDate>2016-02-27 18:25:12</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>IntelliApp</AppSourceName>' +
'        <AppSourceDate>2015-06-13 11:30:31</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>RoehlJobsLead</AppSourceName>' +
'        <AppSourceDate>2015-06-13 11:17:33</AppSourceDate>' +
'      </AppSources>' +
'      <AppSources>' +
'        <AppSourceName>RoehlJobsLead</AppSourceName>' +
'        <AppSourceDate>2015-06-12 23:30:24</AppSourceDate>' +
'      </AppSources>' +
'    </AppSourceHistory>' +
'    <RecruiterAssigned>Kesha Kopca</RecruiterAssigned>' +
'    <RecruiterAssignedEmail>kesha.kopca@roehl.net</RecruiterAssignedEmail>' +
'    <SecondaryUserAssigned/>' +
'    <SecondaryUserAssignedEmail></SecondaryUserAssignedEmail>' +
'    <Licenses>' +
'      <License>' +
'        <CurrentLicense>y</CurrentLicense>' +
'        <LicenseNumber>snipped</LicenseNumber>' +
'        <ExpirationDate>02/05/2020</ExpirationDate>' +
'        <OriginalIssueDate/>' +
'        <Region>MI</Region>' +
'        <CountryCode>US</CountryCode>' +
'        <CommercialDriversLicense>n</CommercialDriversLicense>' +
'        <LicenseClass></LicenseClass>' +
'        <LicenseHasNoEndorsements>y</LicenseHasNoEndorsements>' +
'        <RestrictionNoNightDriving>n</RestrictionNoNightDriving>' +
'        <RestrictionCorrectiveLenses>n</RestrictionCorrectiveLenses>' +
'        <RestrictionNoAirBrakes>n</RestrictionNoAirBrakes>' +
'        <RestrictionOther>n</RestrictionOther>' +
'        <LicenseHasNoRestrictions>n</LicenseHasNoRestrictions>' +
'        <HazMatExpirationDate/>' +
'        <PhysicalExpirationDate>08/26/2016</PhysicalExpirationDate>' +
'      </License>' +
'    </Licenses>' +
'    <Accidents have_accidents="n"/>' +
'    <UnemploymentPeriods/>' +
'    <Employers>' +
'      <Employer>' +
'        <StartDate>01/01/2012</StartDate>' +
'        <EndDate>07/01/2016</EndDate>' +
'        <EmployerName>Abc Transportation Livonia Mi</EmployerName>' +
'        <Phone>734-591-3888</Phone>' +
'        <PositionHeld>Driver</PositionHeld>' +
'        <PositionSubjectToFmcsrs/>' +
'        <PositionDotSafetySensitive/>' +
'        <OperateCommercialMotorVehicle>n</OperateCommercialMotorVehicle>' +
'        <ReasonForLeaving>Seeking full time non commission employment</ReasonForLeaving>' +
'        <CurrentlyEmployed>y</CurrentlyEmployed>' +
'        <DriverTerminated>n</DriverTerminated>' +
'        <PostalAddress>' +
'          <CountryCode>US</CountryCode>' +
'          <Municipality>Livonia</Municipality>' +
'          <Region>MI</Region>' +
'          <PostalCode>48150</PostalCode>' +
'          <Address1>13420 Wayne road</Address1>' +
'          <Address2/>' +
'        </PostalAddress>' +
'        <AreasDriven/>' +
'        <NumberStatesDriven/>' +
'        <MilesDrivenWeekly/>' +
'        <TruckType/>' +
'        <TrailerType/>' +
'        <WeeklyPay/>' +
'        <Supervisor>Kevin Cadwell</Supervisor>' +
'        <ContactEmployer>y</ContactEmployer>' +
'        <TrailerLength/>' +
'        <Fax/>' +
'        <CentsPerMile/>' +
'        <JobDescription/>' +
'        <HoursPerWeek/>' +
'        <TerminationReason/>' +
'      </Employer>' +
'    </Employers>' +
'    <Schools/>' +
'    <TruckingSchool/>' +
'    <TruckingSchools/>' +
'    <Military/>' +
'    <MotorVehicleRecords/>' +
'    <CriminalRecords/>' +
'    <Violations>' +
'      <Violation>' +
'        <DriverHaveViolation>n</DriverHaveViolation>' +
'        <ViolationDate/>' +
'        <ViolationState/>' +
'        <ViolationCharge/>' +
'        <WhileDrivingCommercialVehicle/>' +
'        <MphOverLimit/>' +
'        <PenaltyFined/>' +
'        <PenaltyLicenseSuspended/>' +
'        <PenaltyLicenseRevoked/>' +
'        <PenaltyCommunityService/>' +
'        <PenaltyOther/>' +
'        <FineAmount/>' +
'        <AdditionalComments/>' +
'      </Violation>' +
'    </Violations>' +
'    <CustomDataElements>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Experience</CustomDataPrompt>' +
'        <CustomDataValue>Get Your CDL</CustomDataValue>' +
'        <CustomDataId>experience</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Division</CustomDataPrompt>' +
'        <CustomDataValue>NOT FOUND ON APPLICATION</CustomDataValue>' +
'        <CustomDataId>division</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Hire Date</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>hireDate</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Disqualified Reason</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>disqualifiedReason</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Declined Reason</CustomDataPrompt>' +
'        <CustomDataValue>No Reply</CustomDataValue>' +
'        <CustomDataId>declinedReason</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Fleet</CustomDataPrompt>' +
'        <CustomDataValue>NOT FOUND ON APPLICATION</CustomDataValue>' +
'        <CustomDataId>fleet</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Confirmation #</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>confirmationNumber</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Pick Up Time/Location</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>pickUpTimeLocation</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Hotel</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>hotel</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Canada Restricted</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>canadaRestricted</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Re-Hire</CustomDataPrompt>' +
'        <CustomDataValue>No</CustomDataValue>' +
'        <CustomDataId>rehire</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Military</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>military</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Apprenticeship Prgm</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>apprenticeshipPrgm</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Apprent Prgm Date</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>apprentPrgmDate</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Termination Date</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>terminationDate</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Termination Status</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>terminationStatus</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Rehire Eligible</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>rehireReligible</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Referred By</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>referredBy</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Application Referrer Code</CustomDataPrompt>' +
'        <CustomDataValue>direct</CustomDataValue>' +
'        <CustomDataId>applicationReferrerCode</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>App Referral</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>appReferral</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Agreement: SJSTP</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>agreementSjstp</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Agreement Type</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>agreementType</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Marketing Campaign</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>marketingCampaign</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Marketing First Activity</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>marketingFirstActivity</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Marketing Last Activity</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>marketingLastActivity</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Marketing List</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>marketingList</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Marketing Score</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>marketingScore</CustomDataId>' +
'      </CustomDataElement>' +
'      <CustomDataElement>' +
'        <CustomDataPrompt>Marketing Grade</CustomDataPrompt>' +
'        <CustomDataValue/>' +
'        <CustomDataId>marketingGrade</CustomDataId>' +
'      </CustomDataElement>' +
'    </CustomDataElements>' +
'  </ApplicationData>' +
'  <ProviderVerifiedData/>' +
'</TenstreetData>';

}