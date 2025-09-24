namespace sap.fe.cap.sflight;

using { managed, cuid, Currency, Country } from '@sap/cds/common';

// Master Data Entities

entity Airlines : cuid, managed {
  AirlineID     : String(3) @mandatory @title: 'Airline Code' @Common.Label: 'Airline Code' @Common.Text: Name;
  Name          : String(40) @mandatory @title: 'Airline Name' @Common.Label: 'Airline Name' @UI.MultiLineText;
  CurrencyCode  : String(5) @mandatory @Common.Label: 'Currency';
  Url           : String(255) @Common.Label: 'Website URL' @UI.IsURL;
}

entity Passengers : cuid, managed {
  CustomerID    : String(8) @mandatory @title: 'Customer Number' @Common.Label: 'Customer ID';
  Title         : String(10) @Common.Label: 'Title';
  FirstName     : String(40) @mandatory @Common.Label: 'First Name' @Common.FieldControl: #Mandatory;
  LastName      : String(40) @mandatory @Common.Label: 'Last Name' @Common.FieldControl: #Mandatory;
  Street        : String(60) @Common.Label: 'Street Address';
  PostalCode    : String(10) @Common.Label: 'Postal Code';
  City          : String(40) @Common.Label: 'City';
  CountryCode   : String(3) @Common.Label: 'Country';
  PhoneNumber   : String(30) @Common.Label: 'Phone Number' @Communication.IsPhoneNumber;
  EmailAddress  : String(256) @Common.Label: 'Email Address' @Communication.IsEmailAddress;
  DateOfBirth   : Date @Common.Label: 'Date of Birth' @UI.HiddenFilter;
}

entity TravelAgencies : cuid, managed {
  AgencyID      : String(8) @mandatory @title: 'Travel Agency ID' @Common.Label: 'Agency ID';
  Name          : String(80) @mandatory @title: 'Travel Agency Name' @Common.Label: 'Agency Name' @Common.FieldControl: #Mandatory;
  Street        : String(60) @Common.Label: 'Street Address';
  PostalCode    : String(10) @Common.Label: 'Postal Code';
  City          : String(40) @Common.Label: 'City';
  CountryCode   : String(3) @Common.Label: 'Country';
  PhoneNumber   : String(30) @Common.Label: 'Phone Number' @Communication.IsPhoneNumber;
  EmailAddress  : String(256) @Common.Label: 'Email Address' @Communication.IsEmailAddress;
  WebAddress    : String(256) @Common.Label: 'Website' @UI.IsURL;
}

entity Supplements : cuid, managed {
  SupplementID  : String(10) @mandatory @title: 'Supplement ID' @Common.Label: 'Supplement ID';
  Type          : String(20) @mandatory @Common.Label: 'Supplement Type' @Common.FieldControl: #Mandatory;
  Description   : String(100) @mandatory @Common.Label: 'Description' @UI.MultiLineText;
  Price         : Decimal(15,2) @mandatory @Common.Label: 'Price' @Measures.ISOCurrency: CurrencyCode;
  CurrencyCode  : String(5) @mandatory @Common.Label: 'Currency';
  Unit          : String(5) @Common.Label: 'Unit';
}

entity Flights : cuid, managed {
  CarrierID     : String(3) @mandatory @title: 'Airline Code' @Common.Label: 'Airline' @Common.Text: Airline.Name @Common.TextArrangement: #TextFirst;
  ConnectionID  : String(4) @mandatory @title: 'Flight Connection' @Common.Label: 'Flight Connection';
  FlightDate    : Date @mandatory @Common.Label: 'Flight Date';
  Price         : Decimal(15,2) @mandatory @Common.Label: 'Price' @Measures.ISOCurrency: CurrencyCode;
  CurrencyCode  : String(5) @mandatory @Common.Label: 'Currency';
  PlaneType     : String(10) @Common.Label: 'Plane Type';
  MaximumSeats  : Integer @Common.Label: 'Maximum Seats';
  OccupiedSeats : Integer @Common.Label: 'Occupied Seats';
  PaymentSum    : Decimal(15,2) @Common.Label: 'Total Payments' @Measures.ISOCurrency: CurrencyCode;

  // Association to Airlines
  Airline : Association to Airlines on Airline.AirlineID = CarrierID;
}

entity Airports : cuid, managed {
  AirportID     : String(3) @mandatory @title: 'Airport Code' @Common.Label: 'Airport Code' @Common.Text: Name;
  Name          : String(60) @mandatory @title: 'Airport Name' @Common.Label: 'Airport Name';
  City          : String(40) @mandatory @Common.Label: 'City';
  CountryCode   : String(3) @mandatory @Common.Label: 'Country';
  Region        : String(3) @Common.Label: 'Region';
  TimeZone      : String(6) @Common.Label: 'Time Zone';
  Latitude      : Decimal(9,6) @Common.Label: 'Latitude' @UI.HiddenFilter;
  Longitude     : Decimal(9,6) @Common.Label: 'Longitude' @UI.HiddenFilter;
}

// Primary Business Entities

entity Travel : cuid, managed {
  TravelID      : Integer @Core.Computed @Common.Label: 'Travel ID' @Common.Text: Description;
  AgencyID      : String(8) @mandatory @Common.Label: 'Travel Agency' @Common.Text: TravelAgency.Name @Common.TextArrangement: #TextFirst;
  CustomerID    : String(8) @mandatory @Common.Label: 'Customer' @Common.Text: {$edmJson: {$Path: 'Customer/LastName'}} @Common.TextArrangement: #TextFirst;
  BeginDate     : Date @mandatory @Common.Label: 'Begin Date' @Common.FieldControl: #Mandatory;
  EndDate       : Date @mandatory @Common.Label: 'End Date' @Common.FieldControl: #Mandatory @assert.range: [BeginDate,];
  BookingFee    : Decimal(15,2) @Common.Label: 'Booking Fee' @Measures.ISOCurrency: CurrencyCode;
  TotalPrice    : Decimal(15,2) @mandatory @Common.Label: 'Total Price' @Measures.ISOCurrency: CurrencyCode @Common.FieldControl: #Mandatory;
  CurrencyCode  : String(5) @mandatory @Common.Label: 'Currency';
  Description   : String(1024) @Common.Label: 'Description' @UI.MultiLineText;
  Status        : String(1) @mandatory @assert.range: ['O', 'P', 'A', 'X'] @Common.Label: 'Status' @Common.FieldControl: #Mandatory
                    @Common.Text: {$edmJson: {$If: [{$Eq: [{$Path: 'Status'}, 'O']}, 'Open',
                                              {$If: [{$Eq: [{$Path: 'Status'}, 'P']}, 'Planned',
                                              {$If: [{$Eq: [{$Path: 'Status'}, 'A']}, 'Accepted', 'Cancelled']}]}]}}
                    @UI.TextArrangement: #TextOnly;

  // Associations to Master Data
  TravelAgency : Association to TravelAgencies on TravelAgency.AgencyID = AgencyID;
  Customer     : Association to Passengers on Customer.CustomerID = CustomerID;

  // Composition to Booking
  Booking   : Composition of many Booking on Booking.Travel = $self;
}

entity Booking : cuid, managed {
  BookingID     : Integer @Core.Computed @Common.Label: 'Booking ID';
  TravelID      : Integer @Common.Label: 'Travel ID';
  CarrierID     : String(3) @mandatory @Common.Label: 'Airline' @Common.Text: Carrier.Name @Common.TextArrangement: #TextFirst;
  FlightDate    : Date @mandatory @Common.Label: 'Flight Date' @Common.FieldControl: #Mandatory;
  FlightPrice   : Decimal(15,2) @mandatory @Common.Label: 'Flight Price' @Measures.ISOCurrency: CurrencyCode;
  ConnectionID  : String(4) @mandatory @Common.Label: 'Connection ID' @Common.FieldControl: #Mandatory;
  CurrencyCode  : String(5) @mandatory @Common.Label: 'Currency';

  // Association back to Travel
  Travel : Association to Travel;

  // Associations to Master Data
  Carrier : Association to Airlines on Carrier.AirlineID = CarrierID;
  Flight  : Association to Flights on Flight.CarrierID = CarrierID
                                and Flight.ConnectionID = ConnectionID
                                and Flight.FlightDate = FlightDate;

  // Composition to BookingSupplement
  BookingSupplement : Composition of many BookingSupplement on BookingSupplement.Booking = $self;
}

entity BookingSupplement : cuid, managed {
  BookingSupplementID : Integer @Core.Computed @Common.Label: 'Booking Supplement ID';
  BookingID          : Integer @Common.Label: 'Booking ID';
  SupplementID       : String(10) @mandatory @Common.Label: 'Supplement' @Common.Text: Supplement.Description @Common.TextArrangement: #TextFirst;
  Price              : Decimal(15,2) @mandatory @Common.Label: 'Price' @Measures.ISOCurrency: CurrencyCode;
  CurrencyCode       : String(5) @mandatory @Common.Label: 'Currency';

  // Association back to Booking
  Booking : Association to Booking;

  // Association to Master Data
  Supplement : Association to Supplements on Supplement.SupplementID = SupplementID;
}