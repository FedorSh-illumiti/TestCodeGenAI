using { sap.fe.cap.sflight as my } from './schema';

// UI Annotations for Travel Entity
annotate my.Travel with @(
    UI.LineItem: [
        { Value: TravelID, Label: 'Travel ID' },
        { Value: CustomerID, Label: 'Customer' },
        { Value: TravelAgency.Name, Label: 'Agency' },
        { Value: BeginDate, Label: 'Start Date' },
        { Value: EndDate, Label: 'End Date' },
        { Value: TotalPrice, Label: 'Total' },
        {
            Value: Status,
            Label: 'Status'
        }
    ],
    UI.HeaderInfo: {
        TypeName: 'Travel',
        TypeNamePlural: 'Travels',
        Title: { Value: TravelID },
        Description: { Value: Description }
    },
    UI.SelectionFields: [
        TravelID,
        AgencyID,
        CustomerID,
        BeginDate,
        EndDate,
        Status
    ],
    UI.FieldGroup #GeneralInformation: {
        Label: 'General Information',
        Data: [
            { Value: TravelID },
            { Value: AgencyID },
            { Value: CustomerID },
            { Value: Description }
        ]
    },
    UI.FieldGroup #TravelDates: {
        Label: 'Travel Dates',
        Data: [
            { Value: BeginDate },
            { Value: EndDate }
        ]
    },
    UI.FieldGroup #PricingInformation: {
        Label: 'Pricing',
        Data: [
            { Value: BookingFee },
            { Value: TotalPrice },
            { Value: CurrencyCode },
            { Value: Status }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'General',
            Target: '@UI.FieldGroup#GeneralInformation'
        },
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Dates',
            Target: '@UI.FieldGroup#TravelDates'
        },
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Pricing',
            Target: '@UI.FieldGroup#PricingInformation'
        },
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Bookings',
            Target: 'Booking/@UI.LineItem'
        }
    ]
);

// Define Status Values with Semantic Colors
annotate my.Travel:Status with @(
    Common.ValueListWithFixedValues: true,
    Common.ValueList: {
        CollectionPath: 'TravelStatus',
        Parameters: [
            { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: Status, ValueListProperty: 'code' },
            { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'name' }
        ]
    }
);

// UI Annotations for Booking Entity
annotate my.Booking with @(
    UI.LineItem: [
        { Value: BookingID, Label: 'Booking' },
        { Value: CarrierID, Label: 'Airline' },
        { Value: ConnectionID, Label: 'Connection' },
        { Value: FlightDate, Label: 'Date' },
        { Value: FlightPrice, Label: 'Price' }
    ],
    UI.HeaderInfo: {
        TypeName: 'Booking',
        TypeNamePlural: 'Bookings',
        Title: { Value: BookingID },
        Description: { Value: Carrier.Name }
    },
    UI.SelectionFields: [
        BookingID,
        CarrierID,
        ConnectionID,
        FlightDate
    ],
    UI.FieldGroup #FlightInformation: {
        Label: 'Flight Information',
        Data: [
            { Value: BookingID },
            { Value: CarrierID },
            { Value: ConnectionID },
            { Value: FlightDate }
        ]
    },
    UI.FieldGroup #PricingInformation: {
        Label: 'Pricing',
        Data: [
            { Value: FlightPrice },
            { Value: CurrencyCode }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Flight',
            Target: '@UI.FieldGroup#FlightInformation'
        },
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Pricing',
            Target: '@UI.FieldGroup#PricingInformation'
        },
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Supplements',
            Target: 'BookingSupplement/@UI.LineItem'
        }
    ]
);

// UI Annotations for BookingSupplement Entity
annotate my.BookingSupplement with @(
    UI.LineItem: [
        { Value: BookingSupplementID, Label: 'Supplement ID' },
        { Value: SupplementID, Label: 'Supplement' },
        { Value: Supplement.Description, Label: 'Description' },
        { Value: Price, Label: 'Price' }
    ],
    UI.HeaderInfo: {
        TypeName: 'Booking Supplement',
        TypeNamePlural: 'Booking Supplements',
        Title: { Value: BookingSupplementID },
        Description: { Value: Supplement.Description }
    },
    UI.SelectionFields: [
        SupplementID
    ],
    UI.FieldGroup #SupplementInformation: {
        Label: 'Supplement Details',
        Data: [
            { Value: BookingSupplementID },
            { Value: SupplementID },
            { Value: Price },
            { Value: CurrencyCode }
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Details',
            Target: '@UI.FieldGroup#SupplementInformation'
        }
    ]
);

// Search Capabilities - Enable search on key fields
annotate my.Travel with {
    CustomerID @Search.defaultSearchElement;
    Description @Search.defaultSearchElement;
    TravelAgency @Search.defaultSearchElement;
};

annotate my.Booking with {
    CarrierID @Search.defaultSearchElement;
    ConnectionID @Search.defaultSearchElement;
};

annotate my.Airlines with {
    AirlineID @Search.defaultSearchElement;
    Name @Search.defaultSearchElement;
};

annotate my.Passengers with {
    CustomerID @Search.defaultSearchElement;
    FirstName @Search.defaultSearchElement;
    LastName @Search.defaultSearchElement;
    EmailAddress @Search.defaultSearchElement;
};

annotate my.TravelAgencies with {
    AgencyID @Search.defaultSearchElement;
    Name @Search.defaultSearchElement;
    City @Search.defaultSearchElement;
};

annotate my.Supplements with {
    SupplementID @Search.defaultSearchElement;
    Type @Search.defaultSearchElement;
    Description @Search.defaultSearchElement;
};

annotate my.Flights with {
    CarrierID @Search.defaultSearchElement;
    ConnectionID @Search.defaultSearchElement;
    FlightDate @Search.defaultSearchElement;
};

annotate my.Airports with {
    AirportID @Search.defaultSearchElement;
    Name @Search.defaultSearchElement;
    City @Search.defaultSearchElement;
};

// Sorting and filtering capabilities
annotate my.Travel with {
    TravelID @Common.SortOrder: [{Property: TravelID, Descending: false}];
    BeginDate @Common.SortOrder: [{Property: BeginDate, Descending: true}];
    TotalPrice @Common.SortOrder: [{Property: TotalPrice, Descending: false}];
};

annotate my.Booking with {
    BookingID @Common.SortOrder: [{Property: BookingID, Descending: false}];
    FlightDate @Common.SortOrder: [{Property: FlightDate, Descending: false}];
    FlightPrice @Common.SortOrder: [{Property: FlightPrice, Descending: false}];
};

// Value helps and input assistance
annotate my.Travel with {
    AgencyID @Common.ValueList: {
        CollectionPath: 'TravelAgencies',
        Parameters: [
            { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: AgencyID, ValueListProperty: 'AgencyID' },
            { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'Name' }
        ]
    };
    CustomerID @Common.ValueList: {
        CollectionPath: 'Passengers',
        Parameters: [
            { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: CustomerID, ValueListProperty: 'CustomerID' },
            { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'FirstName' },
            { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'LastName' }
        ]
    };
};

annotate my.Booking with {
    CarrierID @Common.ValueList: {
        CollectionPath: 'Airlines',
        Parameters: [
            { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: CarrierID, ValueListProperty: 'AirlineID' },
            { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'Name' }
        ]
    };
};

annotate my.BookingSupplement with {
    SupplementID @Common.ValueList: {
        CollectionPath: 'Supplements',
        Parameters: [
            { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: SupplementID, ValueListProperty: 'SupplementID' },
            { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'Description' },
            { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'Price' }
        ]
    };
};