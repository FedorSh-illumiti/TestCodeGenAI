namespace sap.fe.cap.sflight;

using { managed, cuid } from '@sap/cds/common';

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