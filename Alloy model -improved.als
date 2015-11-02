//1.SIGNATURES







//DATATYPES SIGNATURES

//common datatypes definitions for types oftenly found in programming languages and necessary for this
//problem

sig Character{
}

sig Integer{
}

sig Strings{
}



//Here are the signatures of the datatypes used in the domain of the problem itself

sig Time{
hours: one Integer,
minutes: one Integer
}

sig Date{
day: one Integer,
month: one Integer,
year: one Integer
}

sig TimeDate{
timeStamp: one Time,
dayStamp: one Date
}

sig Location {
coordinates: one Strings,
streetName: one Strings,
number:one Integer
}

sig CarNumber{
id: one Strings
}

//ENTITY SIGNATURES
//Here are the signatures of the entities that are used in this model


//People that use application
abstract sig Visitor{}

sig Guest extends Visitor{}

sig User extends Visitor{
firstname: one Strings,
lastname: one Strings,
username:one Strings,
password:one Strings,
mobilephoneNumber: one Strings,
gender: one Character,
picturePath: one String
}


sig TaxiDriver extends User{
carId:one CarNumber,
licenseNumber:one Strings,
carModel:one Strings,
availability:one Character

}

sig Admin extends Visitor{
username: one Strings,
password: one Strings
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
accepted:one Strings,
estimatedTimeWaiting:one Time
}

sig Report extends Message{
reason: one Strings
}


sig Drive{
driveId: one Strings,
userRequest: one Request,
taxiResponse:one Response,
reports: some Report
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
	all td:TimeDate | (#td.timeStamp=1) and (#td.dateStamp=1)
}

fact noEmptyLocation{
	all l:Location | (#l.coordinates=1) and (#l.streetName=1) and (#l.streetNumber=1)
}


fact noPasswordMissingUser{
		all u:User | (#u.password=1)
}

fact noPasswordMissingAdmin{
		all a:Admin | (#a.password=1)
}

fact noUnlicensedAndCarlessTaxiDriver{
	all t:TaxiDriver | (#t.carNumber=1) and (#t.licenseNumber=1) and (#t.carModel=1)
}

//No duplicate and overlap-alike facts





//no duplicate users
fact noDuplicateUser{
	no disj u1,u2: User | (u1.username=u2.username)
}

//no self-communication

fact noSelfCommunication{
	all u:User, m:Message | not ( (m.sender=u) and (m.receiver=u) )
}

//no driving to same destination 

fact noSameStartAsEnd{
	all m:Message | not ( m.startpoint=m.endpoint )
}

//no same taxi zones with same center points

fact noSameZones{
	no disj z1,z2: TaxiZone | not  (z1.centerPoint=z2.centerPoint)
}

//no two taxi drivers with same car
fact noSameDriverCars{
	no disj td1, td2: TaxiDriver | not (z1.carId=z2.carId)
}

//no taxi drivers with same liense id allowed
fact noSameLicense{
	no disj td1,td2: TaxiDriver | not (td1.licenseNumber=td2.licenseNumber)
}

//no two drives with same ids

fact noSameDriveId{
	no disj d1,d2: Drive | not (drive1.driveId=d2.driveId)
}

