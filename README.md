# my_shop

This application is a simple shop that allow users to explore products, add orders to cart and issue the order. 


## Getting Started

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Learned Lessons: 
### State Management  
#### Why state management and what it is: 
passing data via constructors can be quite cumbersome and difficult that lead to unneccessary rebuilds of entire app or major pars of the app. That is why we need to use state. State is data which affects the UI (might change over time). UI is a function of data (state). There are 2 types of states app-wide state and local state. 
- App-wide state: affect entire app (e.g. authontication, is used logged in) 
- local state: affects only a widget on its own 

#### Provider Pattern:
Data provider gets attached to a widget. Once it is attached, any child within that widget can go ahead and listen to this provider. If a widget has provider listener, then it get rebuild every time that the data in the provider changes.  

- Using nest models and providers 
- Different Provider syntax: (ChangeNotifierProvider vs ChangeNotifierProvider.value vs MultiProvider) 
- Consumer vs provider.of 

