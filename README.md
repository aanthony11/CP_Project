# Tuurns

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
Turrns is a turn-based or cyclic tasks app. It allows users to keeps track of tasks that are shared between a group of people (i.e. who's turn is it to buy groceries, do the dishes, do a task at the office).

### App Evaluation
- **Category:** Lifestyle
- **Mobile:** Primarily mobile as of now but could potenitally be developed for web but would not as functional as the mobile app.
- **Story:** This app connects users to easily keep track of mundane tasks. It also functions as a shared grocery list / whats in the fridge list.
- **Market:** Anyone who lives with others can use this app to organize a part of their home.
- **Habit:** It will most likely be used approximately once a week but could be used as often as daily. Wouldn't need constant interaction.
- **Scope:** The main target audience would be students in communal living in college/university but could trickle down to families as it's adopted more.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User is able to login.
* User is able to sign up.
* User is able to create a group.
* User is able to add a task that is displayed to everyone in the group
* Chore designated in turn-style action
* Push notification to tell user it is their turn
* User can check off task in list, and task is designated to next person

**Optional Nice-to-have Stories**

* Users can chat with their groups
* Users can create a shared grocery list
* Users can create a whats in th fridge list
* Calendar view of tasks list
* Profile customization

### 2. Screen Archetypes

* Login
   * User is able to login to the app. 
* Register
   * (Must sign up first) 
* Creation
    * User is able to create a group.
    * User is able to add a task that is displayed to everyone in the group
* Stream
    * ...task that is displayed to everyone in the group
    * Chore designated in turn-style action
    * User can check off task in list, and task is designated to next person
* Detail
    * User can tap on item to view full list in full detail

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Groups
* Tasks

**Flow Navigation** (Screen to Screen)

* Login Screen
=> Home
* Registration Screen
=> Home
* Stream
=> Creation
=> Detail

## Wireframes

### Screenshots

<p float="left">
  <img src="Screenshots/iPhone 11 Pro Max - First Screen.png" width=250>
  <img src="Screenshots/iPhone 11 Pro Max - Login.png" width=250> 
  <img src="Screenshots/iPhone 11 Pro Max - Signup.png" width=250>
</p>
</br>
<p float="left">
  <img src="Screenshots/iPhone 11 Pro Max - Tasks.png" width=250>
  <img src="Screenshots/iPhone 11 Pro Max - Tasks Detail.png" width=250>
</p>
</br>
<p float="left">
  <img src="Screenshots/iPhone 11 Pro Max - Groups.png" width=250>
  <img src="Screenshots/iPhone 11 Pro Max - Groups Detail.png" width=250>
</p>
</br>

### Screen Recording

<img src="http://g.recordit.co/L6iMC1iA2y.gif" width=250>



## Schema 
### Models
</br>Task
| Property      | Type     | Description |
| ------------- | -------- | ------------|
| objectId      | String   | unique id for the task (default field) |
| creator        | Pointer to User| task creator |
| notes       | String   | notes by author/group |
| group | Pointer to Group   | task's association to group |
| frequency | Array[Number]   | flexible frequency of task |
| createdAt     | DateTime | date when task is created (default field) |
| updatedAt     | DateTime | date when task is last updated (default field) |

</br>Group


| Property | Type | Description |
| -------- | -------- | -------- |
| objectId      | String   | unique id for the task (default field) |
| name | String | name of the group |
| users        | Array[Pointer to User]| users in group |
| createdAt     | DateTime | date when task is created (default field) |
| updatedAt     | DateTime | date when task is last updated (default field) |

</br>User

| Property | Type | Description |
| -------- | -------- | -------- |
| objectId      | String   | unique id for the task (default field) |
| firstName       | String   | first name of user |
| lastName       | String   | last name of user |
| email       | String   | email of user |
| salt       | String   | for hashing password |
| password       | String   | encrypted password |
| group        | Pointer to Group| group of user |
| createdAt     | DateTime | date when task is created (default field) |
| updatedAt     | DateTime | date when task is last updated (default field) |

### Networking
#### List of network requests by screen
- Login Screen
    - (Read/GET) User logs into app
        - User can also create new profile
- Signup Screen
    - (Create/POST) User signs up
- Tasks Feed Screen
    - (Read/GET) Query all tasks from group
    - (Create/POST) User creates new task for group
- Tasks Detail Screen
    - (Update/PUT) Can change task's group association
- Groups Screen
    - (Read/GET) Display all groups that user is in
    - (Create/POST) User can create new group
- Groups Detail Screen 
    - (Create/POST) User can add others to it

#### Code snippets
##### (Read/GET) Query all tasks from group
```
// iOS
// (Read/GET) Query all tasks where user is in current group
let query = PFQuery(className:"Task")
query.whereKey("users", equalTo: currentUser)
query.order(byDescending: "createdAt")
query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
   if let error = error {
      print(error.localizedDescription)
   } else if let posts = posts {
      print("Successfully retrieved \(posts.count) posts.")
      // TODO: Do something with posts...
   }
} 
```
##### (Read/GET) Display all groups that user is in
```
// iOS
// (Read/GET) Query all groups where user is in group
let query = PFQuery(className:"Group")
query.whereKey("group", equalTo: currentGroup)
query.order(byAscending: "name")
query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
   if let error = error {
      print(error.localizedDescription)
   } else if let posts = posts {
      print("Successfully retrieved \(posts.count) posts.")
      // TODO: Do something with posts...
   }
} 
```

#### OPTIONAL: Existing API endpoints
- None

