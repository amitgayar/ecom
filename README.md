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

