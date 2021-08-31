# **bitfinex-Trade**
an iOS native application that displays available trading pairs; using the Bitfinex Public API

## **Architecture Of The app:**
I am following the MVVM-P pattern where we have 
- Model -> that holds data (in this case from network operations)
- View / View Controller -> that's the canvas and the binder for all elements
- View model -> that hold business logic including control on network connections and custodian of Model
- Presentation Layer -> which converts Data in the models from the View model to suit the Views need.

Reason For going with this approach:
The application can be made easier to maintain in the long go especially when UI changes happen
Business Logics can be kept hidden from UI changes thanks to the presentation layer.
VC can be kept to control the Views rather than making Business logic as the View model does it.

We have a Network Manager and a socket connection manager all using URL sessions. This is kept separate for reusability accounts

## **UI**
The app is split into two VC
Trade Pair Listing VC
Real-Time info VC

### **Trade Pair Listing VC**
Trade pair listing VC shows all available Trade pairs. I am filtering out funding currencies as the requirements is for trade pairs. This happens at the parsing level in the model itself.
I am using a table view with diffable data sources by making table view cell presentation as hashable to display the list.

### **Real-Time info VC**

here I am using a collection view with diffable data as two cell presentations, as part of two sections, 
The first section with ticker info cell shows updates received from socket connection subscribed for ticker updates.
The second section handles Trade updates.

The whole UI is getting Updated corresponding to the update.

#### Github actions:
I could not make it up and running actions due to workspace not found error. I am running out of time too, this can be taken up later on if needed.

### Unit Test and Feature Test:
All view models where logic sits are covered under unit and feature testing.
