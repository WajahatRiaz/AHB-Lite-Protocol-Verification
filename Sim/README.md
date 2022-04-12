This folder contains all the simulations and testbenches

Following are the key components of a design verification environment I added today:

## Transaction
The Transaction class is used as a way of communication between Generator-Driver and Monitor-Scoreboard. Fields/Signals required to generate the stimulus are declared in this class.

## Interface
It contains design signals that can be driven or monitored.

## Generator
Generates the stimulus (create and randomize the transaction class) and send it to Driver


## Driver
Receives the stimulus (transaction) from a generator and drives the packet level data inside the transaction into the DUT through the interface.

## Monitor
Observes the activity on interface signals and converts into packet level data which is sent to the scoreboard.


Working on the remaining ones.
