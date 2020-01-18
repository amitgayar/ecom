This Project is a Flutter Application of MPos System for **Express Stores**

## The project contains the following :

### main.dart
The [main.dart](lib/main.dart) runs the app while - 
- Specifying the set of orientations the application interface can be displayed in using
  ```
  SystemChrome.setPreferredOrientations()
  ```
- Creating an instance of SharedPreferences to check for authentication token on the basis of which user is navigated to 
  either to Login Page or Home Page
  
- Creating an object of cron for creating a cron schedule to get data sync frequency at the set time 
  ```
  final getFrequencyCron = new Cron();
  ```
  
### app.dart
The [app.dart](lib/app.dart) contains : 
- Global Key used to navigate out of context used in LoginES.dart to navigate to home screen if authentication token is set
  ```
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  ```
- Object of connectivity class to check connectivity mode
  ```
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  ```
- An instance of SharedPreferences to check the status of the synced data and on the basis of that calling
  getSyncAPI() and postSyncAPI()
        


### UI Sections : 
- Home 
  ###### Associated Files : [lib/AppScreens/carts/*](lib/AppScreens/carts/) **and** [home.dart](lib/home.dart)
  The Home Section is divided into 4 sections : 
  - [Tabs](lib/home.dart)
  
    Contains the Tab Headings(also showing the Cart Status) and the screen for each of the three carts.
  - [Quick Links](lib/AppScreens/carts/cartFunctionalities.dart)
    - Search Bar to browse through products and categories
    - Add Custom Products by an OnTap button event or barcode scanner
    - Add Products to cart by OnTap event or barcode scanner
  - [Cart](lib/AppScreens/carts/CartDescendant.dart)
      
      It Contains : 
    - The Rows of items in cart where Mrp, Sp, Quantity are editable
    - The cart summary with user action to add taxes to the cart or not. It also contains the Discount field which is 
      filled by the user but cannot be greater than cart total value
  - [LastBarSection](lib/AppScreens/carts/CartDescendant.dart) and [Payment Mode](lib/AppScreens/carts/CartDescendant.dart)
    
    One of them is displayed at a time.
    - LastBarSection contains actionable buttons to choose customer for the cart, to clear the cart and to go to the Payment         Mode
    - Payment Mode contains : 
      - [Credit Mode](lib/AppScreens/carts/credit_payment_modes.dart)
        ```
        - contains Amount Paid by the customer, the rest if any is added to the his credits
        - this mode is selectable only when any customer is chosen for the cart
        - PRINT Action Button
        ```
      - [Other Modes](lib/AppScreens/carts/other_payment_modes.dart) 
        ```
        - PAYTM, BHIMUPI, CASH, DEBIT/CREDIT CARD, OTHER 
        - PRINT Action Button
        ```
      
- Request Stocks
  ###### Associated Files : [lib/AppScreens/request_stocks/*](lib/AppScreens/request_stocks/)
  Consists of 4 sections : 
  - The Main Screen 1
  - Request New Stocks Screen => Request Sent Screen
  - Accept Stocks Screen => Accepted Stocks Screen
  - Request History
  ```
               ------> Request New Stocks Screen-------> Request Sent Screen
                                                       
  Main Screen  ----------------------------------------> Request Sent Screen

               --------> Accept Stocks Screen ---------> Accepted Stocks Screen
  ```
- Customers
  ###### Associated Files : [lib/AppScreens/customers/*](lib/AppScreens/customers/)
  Consists of 3 Screens : 
  - [Screen 1](lib/AppScreens/customers/customers_screen1.dart)
  
    contains 
    - list of customers displayed under 2 Tabs - customers and customers on credit
    - search field 
  - [Screen 2](lib/AppScreens/customers/customers_screen2.dart)
  
    contains 
    - Selected Customer's details and his/her orders displayed under 2 Tabs - Order History and Credit History
  - [Screen 3](lib/AppScreens/customers/customers_screen3.dart)
  
    contains
    - Selected Customer's details and Pay
    - 
- Orders
  ###### Associated Files : [lib/AppScreens/orders/*](lib/AppScreens/orders/)
  Consists of 3 Screens : 
   - [Screen 1](lib/AppScreens/customers/orders_screen1.dart)
  
     contains 
    - list of orders with filters - credit, date, payment mode, status
    - search field 
  - [Screen 2](lib/AppScreens/customers/orders_screen2.dart)
  
    contains 
    - Selected Orders's details with Refund action navigating the user to go the Order Screen 3
  - [Screen 3](lib/AppScreens/customers/orders_screen3.dart)
  
    contains
    - Editable Rows to enter quantity to return
    - Payment modes selection for refund
    - TextField to enter Amount Paid on refund
  ###### Associated Files : [lib/AppScreens/sales_report/*](lib/AppScreens/sales_report/)
  Consists of [Single Screen](lib/AppScreens/sales_report/) with a pop up Stack to set date and time filters
- Login
  ###### Associated Files : [lib/loginES.dart](lib/loginES.dart)
  Consists of :
  - Logo
  - TextFields to enter mobile number and associated password
  - LOGIN Action Button
- Drawer
  ###### Associated Files : [lib/AppScreens/drawer_express_store.dart](lib/AppScreens/drawer_express_store.dart)
  Consists of :
  - Logo
  - Store Details
  - Sections Button to navigate to all sections
  - Logout
### Backend Functionalities : 

