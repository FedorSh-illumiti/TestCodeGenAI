namespace sap.fe.cap.sflight;

using { managed, cuid } from '@sap/cds/common';

// Master Data Entities

entity Airlines : cuid, managed {
  AirlineID     : String(3) @mandatory @title: 'Airline Code';
  Name          : String(40) @mandatory @title: 'Airline Name';
  CurrencyCode  : String(5) @mandatory;
  Url           : String(255);
}

entity Passengers : cuid, managed {
  CustomerID    : String(8) @mandatory @title: 'Customer Number';
  Title         : String(10);
  FirstName     : String(40) @mandatory;
  LastName      : String(40) @mandatory;
  Street        : String(60);
  PostalCode    : String(10);
  City          : String(40);
  CountryCode   : String(3);
  PhoneNumber   : String(30);
  EmailAddress  : String(256);
  DateOfBirth   : Date;
}

entity TravelAgencies : cuid, managed {
  AgencyID      : String(8) @mandatory @title: 'Travel Agency ID';
  Name          : String(80) @mandatory @title: 'Travel Agency Name';
  Street        : String(60);
  PostalCode    : String(10);
  City          : String(40);
  CountryCode   : String(3);
  PhoneNumber   : String(30);
  EmailAddress  : String(256);
  WebAddress    : String(256);
}

entity Supplements : cuid, managed {
  SupplementID  : String(10) @mandatory @title: 'Supplement ID';
  Type          : String(20) @mandatory;
  Description   : String(100) @mandatory;
  Price         : Decimal(15,2) @mandatory;
  CurrencyCode  : String(5) @mandatory;
  Unit          : String(5);
}

entity Flights : cuid, managed {
  CarrierID     : String(3) @mandatory @title: 'Airline Code';
  ConnectionID  : String(4) @mandatory @title: 'Flight Connection';
  FlightDate    : Date @mandatory;
  Price         : Decimal(15,2) @mandatory;
  CurrencyCode  : String(5) @mandatory;
  PlaneType     : String(10);
  MaximumSeats  : Integer;
  OccupiedSeats : Integer;
  PaymentSum    : Decimal(15,2);

  // Association to Airlines
  Airline : Association to Airlines on Airline.AirlineID = CarrierID;
}

entity Airports : cuid, managed {
  AirportID     : String(3) @mandatory @title: 'Airport Code';
  Name          : String(60) @mandatory @title: 'Airport Name';
  City          : String(40) @mandatory;
  CountryCode   : String(3) @mandatory;
  Region        : String(3);
  TimeZone      : String(6);
  Latitude      : Decimal(9,6);
  Longitude     : Decimal(9,6);
}

// Primary Business Entities

entity Travel : cuid, managed {
  TravelID      : Integer @Core.Computed;
  AgencyID      : String(8) @mandatory;
  CustomerID    : String(8) @mandatory;
  BeginDate     : Date @mandatory;
  EndDate       : Date @mandatory;
  BookingFee    : Decimal(15,2);
  TotalPrice    : Decimal(15,2) @mandatory;
  CurrencyCode  : String(5) @mandatory;
  Description   : String(1024);
  Status        : String(1) @mandatory @assert.range: ['O', 'P', 'A', 'X'];

  // Composition to Booking
  Booking   : Composition of many Booking on Booking.Travel = $self;
}

entity Booking : cuid, managed {
  BookingID     : Integer @Core.Computed;
  TravelID      : Integer;
  FlightDate    : Date @mandatory;
  FlightPrice   : Decimal(15,2) @mandatory;
  ConnectionID  : String(4) @mandatory;
  CurrencyCode  : String(5) @mandatory;

  // Association back to Travel
  Travel : Association to Travel;

  // Composition to BookingSupplement
  BookingSupplement : Composition of many BookingSupplement on BookingSupplement.Booking = $self;
}

entity BookingSupplement : cuid, managed {
  BookingSupplementID : Integer @Core.Computed;
  BookingID          : Integer;
  SupplementID       : String(10) @mandatory;
  Price              : Decimal(15,2) @mandatory;
  CurrencyCode       : String(5) @mandatory;

  // Association back to Booking
  Booking : Association to Booking;
}