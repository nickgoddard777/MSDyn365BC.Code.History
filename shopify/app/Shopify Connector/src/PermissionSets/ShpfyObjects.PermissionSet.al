/// <summary>
/// Shpfy - Objects Permissions (ID 30104).
/// </summary>
permissionset 30104 "Shpfy - Objects"
{
    Access = Internal;
    Assignable = false;
    Caption = 'Shopify - Objects', MaxLength = 30;

    Permissions =
        table "Shpfy Credit Card Company" = X,
        table "Shpfy Cue" = X,
        table "Shpfy Customer" = X,
        table "Shpfy Customer Address" = X,
        table "Shpfy Customer Template" = X,
        table "Shpfy Data Capture" = X,
        table "Shpfy Gift Card" = X,
        table "Shpfy Inventory Item" = X,
        table "Shpfy Log Entry" = X,
        table "Shpfy Metafield" = X,
        table "Shpfy Order Attribute" = X,
        table "Shpfy Order Disc.Appl." = X,
        table "Shpfy Order Fulfillment" = X,
        table "Shpfy Order Header" = X,
        table "Shpfy Order Line" = X,
        table "Shpfy Order Payment Gateway" = X,
        table "Shpfy Order Risk" = X,
        table "Shpfy Order Shipping Charges" = X,
        table "Shpfy Orders To Import" = X,
        table "Shpfy Order Tax Line" = X,
        table "Shpfy Order Transaction" = X,
        table "Shpfy Payment Method Mapping" = X,
        table "Shpfy Payment Transaction" = X,
        table "Shpfy Payout" = X,
        table "Shpfy Product" = X,
        table "Shpfy Province" = X,
        table "Shpfy Registered Store" = X,
        table "Shpfy Shipment Method Mapping" = X,
        table "Shpfy Shop" = X,
        table "Shpfy Shop Collection Map" = X,
        table "Shpfy Shop Inventory" = X,
        table "Shpfy Shop Location" = X,
        table "Shpfy Synchronization Info" = X,
        table "Shpfy Tag" = X,
        table "Shpfy Tax Area" = X,
        table "Shpfy Transaction Gateway" = X,
        table "Shpfy Variant" = X,
        codeunit "Shpfy Authentication Mgt." = X,
        codeunit "Shpfy Background Syncs" = X,
        codeunit "Shpfy Base64" = X,
        codeunit "Shpfy Communication Events" = X,
        codeunit "Shpfy Communication Mgt." = X,
        codeunit "Shpfy County Code" = X,
        codeunit "Shpfy County Name" = X,
        codeunit "Shpfy Create Customer" = X,
        codeunit "Shpfy Create Item" = X,
        codeunit "Shpfy CreateProdStatusActive" = X,
        codeunit "Shpfy CreateProdStatusDraft" = X,
        codeunit "Shpfy Create Product" = X,
        codeunit "Shpfy Cust. By Bill-to" = X,
        codeunit "Shpfy Cust. By Default Cust." = X,
        codeunit "Shpfy Cust. By Email/Phone" = X,
        codeunit "Shpfy Customer API" = X,
        codeunit "Shpfy Customer Events" = X,
        codeunit "Shpfy Customer Export" = X,
        codeunit "Shpfy Customer Import" = X,
        codeunit "Shpfy Customer Mapping" = X,
        codeunit "Shpfy Export Shipments" = X,
        codeunit "Shpfy Filter Mgt." = X,
        codeunit "Shpfy Gift Cards" = X,
        codeunit "Shpfy GQL ApiKey" = X,
        codeunit "Shpfy GQL Customer" = X,
        codeunit "Shpfy GQL CustomerIds" = X,
        codeunit "Shpfy GQL FindCustByEMail" = X,
        codeunit "Shpfy GQL FindCustByPhone" = X,
        codeunit "Shpfy GQL FindVariantBySKU" = X,
        codeunit "Shpfy GQL FindVariantByBarcode" = X,
        codeunit "Shpfy GQL InventoryEntries" = X,
        codeunit "Shpfy GQL LocationOrderLines" = X,
        codeunit "Shpfy GQL NextCustomerIds" = X,
        codeunit "Shpfy GQL NextInvEntries" = X,
        codeunit "Shpfy GQL NextOrderFulfillment" = X,
        codeunit "Shpfy GQL NextOrdersToImport" = X,
        codeunit "Shpfy GQL NextProductIds" = X,
        codeunit "Shpfy GQL NextProductImages" = X,
        codeunit "Shpfy GQL NextVariantIds" = X,
        codeunit "Shpfy GQL NextVariantImages" = X,
        codeunit "Shpfy GQL OrderFulfillment" = X,
        codeunit "Shpfy GQL OrderRisks" = X,
        codeunit "Shpfy GQL OrdersToImport" = X,
        codeunit "Shpfy GQL ProductById" = X,
        codeunit "Shpfy GQL ProductIds" = X,
        codeunit "Shpfy GQL ProductImages" = X,
        codeunit "Shpfy GQL UpdateOrderAttr" = X,
        codeunit "Shpfy GQL VariantById" = X,
        codeunit "Shpfy GQL VariantIds" = X,
        codeunit "Shpfy GQL VariantImages" = X,
        codeunit "Shpfy GraphQL Queries" = X,
        codeunit "Shpfy GraphQL Rate Limit" = X,
        codeunit "Shpfy Hash" = X,
        codeunit "Shpfy Import Order" = X,
        codeunit "Shpfy Install Mgt." = X,
        codeunit "Shpfy Inventory API" = X,
        codeunit "Shpfy Inventory Events" = X,
        codeunit "Shpfy Item Reference Mgt." = X,
        codeunit "Shpfy Json Helper" = X,
        codeunit "Shpfy Math" = X,
        codeunit "Shpfy Name is Empty" = X,
        codeunit "Shpfy Name is CompanyName" = X,
        codeunit "Shpfy Name is First. LastName" = X,
        codeunit "Shpfy Name is Last. FirstName" = X,
        codeunit "Shpfy Order Events" = X,
        codeunit "Shpfy Order Fulfillments" = X,
        codeunit "Shpfy Order Mapping" = X,
        codeunit "Shpfy Order Mgt." = X,
        codeunit "Shpfy Order Risks" = X,
        codeunit "Shpfy Orders API" = X,
        codeunit "Shpfy Payments" = X,
        codeunit "Shpfy Process Order" = X,
        codeunit "Shpfy Process Orders" = X,
        codeunit "Shpfy Product API" = X,
        codeunit "Shpfy Product Events" = X,
        codeunit "Shpfy Product Export" = X,
        codeunit "Shpfy Product Image Export" = X,
        codeunit "Shpfy Product Import" = X,
        codeunit "Shpfy Product Mapping" = X,
        codeunit "Shpfy Product Price Calc." = X,
        codeunit "Shpfy RemoveProductDoNothing" = X,
        codeunit "Shpfy REST Client" = X,
        codeunit "Shpfy Shipping Charges" = X,
        codeunit "Shpfy Shipping Events" = X,
        codeunit "Shpfy Shipping Methods" = X,
        codeunit "Shpfy Shop Mgt." = X,
        codeunit "Shpfy Sync Countries" = X,
        codeunit "Shpfy Sync Customers" = X,
        codeunit "Shpfy Sync Inventory" = X,
        codeunit "Shpfy Sync Orders" = X,
        codeunit "Shpfy Sync Product Image" = X,
        codeunit "Shpfy Sync Products" = X,
        codeunit "Shpfy Sync Shop Locations" = X,
        codeunit "Shpfy ToArchivedProduct" = X,
        codeunit "Shpfy ToDraftProduct" = X,
        codeunit "Shpfy Transactions" = X,
        codeunit "Shpfy Update Customer" = X,
        codeunit "Shpfy Update Item" = X,
        codeunit "Shpfy Upgrade Mgt." = X,
        codeunit "Shpfy Variant API" = X,
        page "Shpfy Activities" = X,
        page "Shpfy Authentication" = X,
        page "Shpfy Credit Card Companies" = X,
        page "Shpfy Customer Adresses" = X,
        page "Shpfy Customer Card" = X,
        page "Shpfy Customers" = X,
        page "Shpfy Customer Templates" = X,
        page "Shpfy Data Capture List" = X,
        page "Shpfy Gift Cards" = X,
        page "Shpfy Gift Card Transactions" = X,
        page "Shpfy Inventory FactBox" = X,
        page "Shpfy Log Entries" = X,
        page "Shpfy Log Entry Card" = X,
        page "Shpfy Order" = X,
        page "Shpfy Order Attributes" = X,
        page "Shpfy Order Fulfillments" = X,
        page "Shpfy Order Risks" = X,
        page "Shpfy Orders" = X,
        page "Shpfy Order Shipping Charges" = X,
        page "Shpfy Orders to Import" = X,
        page "Shpfy Order Subform" = X,
        page "Shpfy Order Transactions" = X,
        page "Shpfy Payment Methods Mapping" = X,
        page "Shpfy Payment Transactions" = X,
        page "Shpfy Payouts" = X,
        page "Shpfy Products" = X,
        page "Shpfy Shipment Methods Mapping" = X,
        page "Shpfy Shop Card" = X,
        page "Shpfy Shop Locations Mapping" = X,
        page "Shpfy Shops" = X,
        page "Shpfy Tag Factbox" = X,
        page "Shpfy Tags" = X,
        page "Shpfy Tax Areas" = X,
        page "Shpfy Transaction Gateways" = X,
        page "Shpfy Transactions" = X,
        page "Shpfy Variants" = X,
        query "Shpfy Shipment Location" = X,
        report "Shpfy Add Item to Shopify" = X,
        report "Shpfy Create Location Filter" = X,
        report "Shpfy Create Sales Orders" = X,
        report "Shpfy Sync Customers" = X,
        report "Shpfy Sync Images" = X,
        report "Shpfy Sync Orders from Shopify" = X,
        report "Shpfy Sync Payments" = X,
        report "Shpfy Sync Products" = X,
        report "Shpfy Sync Shipm. to Shopify" = X,
        report "Shpfy Sync Stock to Shopify" = X;
}
