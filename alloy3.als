//1.SIGNATURES







//DATATYPES SIGNATURES

//common datatypes definitions for types oftenly found in programming languages and necessary for this
//problem




//Here are the signatures of the datatypes used in the domain of the problem itself

sig Time{
hours: one Int,
minutes: one Int
}
sig Date{
day: one Int,
month: one Int,
year: one Int
}

sig TimeDate{
timeStamp: one Time,
dateStamp: one Date
}

sig Location {
coordinates: one String,
streetName: one String,
streetNumber:one Int,
number:one Int
}

sig CarNumber{
id: one String
}

//ENTITY SIGNATURES
//Here are the signatures of the entities that are used in this model


//People that use application
abstract sig Visitor{}

sig Guest extends Visitor{}

sig User extends Visitor{
firstname: one String,
lastname: one String,
username:one String,
password:one String,
mobilephoneNumber: one String,
gender: one String,
picturePath: one String,
currentLocation:one Location,
currentZone:one TaxiZone,
codiceFiscale: one String
}


sig TaxiDriver extends User{
carNumber:one CarNumber,
licenseNumber:one String,
carModel:one String,
availability:one String,

}

sig Admin extends Visitor{
username: one String,
password: one String
}

//Communication entities

sig Message{
startpoint:one Location,
endpoint: one Location,
timestamp: one TimeDate,
sender: one User,
receiver:one User
}


sig Request extends Message{
maximumWaitingTime: lone Time
}
{
maximumWaitingTime.hours=23
maximumWaitingTime.minutes=59
}

sig Response extends Message{
accepted:one String,
estimatedTimeWaiting:one Time
}

sig Report extends Message{
reason: one String,
id:  one String
}


sig Drive{
driveId: one String,
userRequest: one Request,
taxiResponse:one Response,
reports: set Report
}


//System-related entities
sig TaxiZone{
zoneId: one String,
carIdQueue: set CarNumber,
centerPoint: one Location
}

sig Scheduler{
requestQueue: set Request,
zones: some TaxiZone
}




//2.FACTS





pred show{
#TaxiZone=1

}

run show for 15
