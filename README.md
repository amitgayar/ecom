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
  ###### Associated Files : [lib/AppScreens/carts/](lib/AppScreens/carts/) ,  [home.dart](lib/home.dart)
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
        - also contains PRINT Action Button
        ```
      - [Other Modes](lib/AppScreens/carts/other_payment_modes.dart) 
        ```
        - PAYTM, BHIMUPI, CASH, DEBIT/CREDIT CARD, OTHER 
        - also contains PRINT Action Button
        ```
      
- Request Stocks
  ###### Associated Files : [lib/AppScreens/request_stocks/](lib/AppScreens/request_stocks/)
- Customers
  ###### Associated Files : [lib/AppScreens/customers/](lib/AppScreens/customers/)
- Orders
  ###### Associated Files : [lib/AppScreens/orders/](lib/AppScreens/orders/)
- Sales Report
  ###### Associated Files : [lib/AppScreens/sales_report/](lib/AppScreens/sales_report/)
- Login/Logout
  ###### Associated Files : [lib/loginES.dart](lib/loginES.dart)
### Backend Functionalities : 

