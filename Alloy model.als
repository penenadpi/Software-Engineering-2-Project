//1.SIGNATURES





//DATATYPES SIGNATURES
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
dayStamp: one Date
}

sig Location {
coordinates: one String,
streetName: one String,
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
picturePath: one String
}


sig TaxiDriver extends User{
carId:one CarNumber,
licenseNumber:one String,
carModel:one String,
availability:one String

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

sig Response extends Message{
accepted:one String,
estimatedTimeWaiting:one Time
}

sig Report extends Message{
reason: one String
}

//System-related entities
sig TaxiZone{
carIdQueue: some CarNumber,
centerPoint: one Location
}

sig Scheduler{
requestQueue: set Request
zones: some TaxiZone
}




//2.FACTS





//noEmpty-alike facts

fact noEmptyTime{
	all t:Time | (#t.hours=1) and (#t.minutes=1)
}


fact noEmptyDate{
	all d: Date | (#d.day=1) and (#d.month=1) and (#d.year=1)
}

fact noEmptyTimeDate{
	all td:TimeDate (#td.timeStamp=1) and (#td.dateStamp=1)
}

fact noEmptyLocation{
	all l:Location (#l.coordinates=1) and (#l.streetName=1) and (#l.streetNumber=1)
}


//no duplicate users
fact noDuplicateUser{
	no disj u1,u2: User | (u1.username=u2.username)
}

//no self-communication

fact noSelfCommunication{
	all u:User, m:Message | not ( (m.sender=u1) and (m.receiver=u1) )
}

//no driving to same destination 

fact noSameStartAsEnd{
	all m:Message | not ( m.startpoint=m.endpoint )
}



