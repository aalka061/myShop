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

## Screenshots

![Screenshot from 2021-02-05 17-58-54](https://user-images.githubusercontent.com/32111609/107097961-1b18ac80-67dc-11eb-90e8-c5cb3d6d5769.png)

![Screenshot from 2021-02-05 17-59-30](https://user-images.githubusercontent.com/32111609/107097964-1b18ac80-67dc-11eb-8b40-99bb24b43b76.png)

![Screenshot from 2021-02-05 17-59-44](https://user-images.githubusercontent.com/32111609/107097965-1b18ac80-67dc-11eb-9704-62c7d2c8876f.png)

![Screenshot from 2021-02-05 18-00-00](https://user-images.githubusercontent.com/32111609/107097966-1bb14300-67dc-11eb-951e-66912a91f781.png)
