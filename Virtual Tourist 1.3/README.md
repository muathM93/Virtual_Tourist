# VirtualTourist 
### by: Boubaid, Muath M. (muath.m.cs@gmail.com)

Virtual tourist is an app that allows users to choose any place to visit, within a single click (virtually). Also, the app allows the user to select the nearest airport based on the selected location


# App Features
1. VT is map-based application using MapKit.
2. VT saves your previously visited places (data persisiting).
3. VT downloads external resoueces from the internnet (Flicker API).
4. VT is user-friendly using UIKit components (alerts, colors).

# Implementation
* MapViewController:
1. displays a map for users.
2. allows users to place pins of randomly generated colours on as many desired locations as possible.
3. saves these locations to a data model.
4. upon clicking on any pin, it navigates to photoAlbumViewController.

* photoAlbumViewController:
is made of three main sections:
1. a map with the selected pin
2. a collection view with the fetched photos
3. photoAlbumViewController deals with users in a very friendly fashion.
4. In photoAlbumViewController there is a button called the nearest airport that button allows the user to select the nearest airport based on the selected location.



# How to build/compile
Describe the necessary steps to build/compile your app
1. Unzip the project folder.
2. Open it using xCode.
3. cmd + b (build).
4. Run the app.

# Requirements
- Xcode (IDE).
- iOS device/ simulator (to run the application).
- An internet connection (to be able to fetch images from Flicker API)

