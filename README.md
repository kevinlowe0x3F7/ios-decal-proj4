#LocalEats

## Authors
* Kevin Lowe
* Jeffrey Liu

## Purpose
* LocalEats uses Yelp API to present the user with local restaurants,
which are randomly presented in a Tinder-like manner.

## Features
* Ability to see restaurants nearby based on current location or a
given location
* Ability to save restaurants as a user profile even with killed app
* Filter and sort restaurants based on price and distance

## Control Flow
* For a first time user, they would be prompted to make an account,
entering a username and password. Once an account is made, the user will now
see the list of restaurants, presented one by one, with some basic
information on the restaurant (name, rating, price, etc.).The user
can decide whether to skip onto the next restaurant or save the restaurant
for later, either by swiping left or right or through buttons on the
screen. Once they are done looking at restaurants, they can go into their
profile and see the restaurants in a saved list.

## Implementation

### Model
* RestaurantList.swift
    * Contains the list of restaurants that the MainRestaurantViewController
    will use to display restaurants one by one. Updates the list based on
    the location in the user profile.
* Restaurant.swift
    * A Restaurant object holds information on each individual restaurant,
    which is taken from the Yelp API. The BasicRestaurantViewController
    and DetailedRestaurantViewController will use this data to present
    in their views.
* UserProfile.swift
    * Stores the information unique to the user, such as their settings,
    the restaurants that they have saved, and the location if given.

### View
* MainRestaurantView
    * Main screen which presents the restaurants one by one
* SavedRestaurantView
    * Profile table view which presents the user with the
    restaurants that they have saved
* SettingsView
    * Settings for user to toggle options, such as to give a location,
    filter based on price, sort them, etc.
* BasicRestaurantView
    * A subview contained within the main restaurant view. Holds basic
    information for some restaurant. In other words, presents a basic
    profile with some information for each restaurant including name,
    price, distance, and rating.
* DetailedRestaurantView
    * View that contains more information than the basic profile, such as
    recent reviews, location, business hours, phone number, etc.

### Controller
* MainRestaurantViewController
    * Handles swipe gestures to save a restaurant or move onto the next one,
    also handles transitions to settings and user profile.
* SavedRestaurantViewController
    * Organizes the table view, with option to delete a restaurant from
    the profile. Tapping on an restaurant in this table view will take
    the user to the detailed restaurant view
* SettingsViewController
    * Settings for user to toggle options, such as to give a location,
    filter based on price, sort them, etc.
* BasicRestaurantViewController
    * Grabs the data for a restaurant from the model and displays it in
    the BasicRestaurantView. Handles the tap gesture that takes the user
    to a detailed view of the same restaurant.
* DetailedRestaurantViewController
    * Grabs more detailed information from the model and displays it in
    a DetailedRestaurantView.

