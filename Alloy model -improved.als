//1.SIGNATURES







//DATATYPES SIGNATURES

//common datatypes definitions for types oftenly found in programming languages and necessary for this
//problem




//Here are the signatures of the datatypes used in the domain of the problem itself

sig Time{
hours: one Int,
minutes: one Int
}{
hours>=0
hours<24
minutes>=0
minutes<60
}

sig Date{
day: one Int,
month: one Int,
year: one Int
}{
day>0
day<=31
month>0
month<=12
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
gender: one Character,
picturePath: one String,
currentLocation:one Location,
currentZone:one TaxiZone,
codiceFiscale: one String
}


sig TaxiDriver extends User{
carId:one CarNumber,
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
accepted:one Strings,
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
carIdQueue: set CarNumber,
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


//a taxi drivers can respond to requests that are from users in that taxizone


fact responseCondition1{
no r:Request | r.sender. currentZone!=r.receiver.currentZone
}

fact responseCondition2{
no r:Response | r.sender. currentZone!=r.receiver.currentZone
}




//no longer estimated time in response than time proposed in a request. this can't be a drive formed event

fact timesCondition {
 no d: Drive | (d.userRequest.maximumWaitingTime.minutes) < (d.taxiResponse.estimatedTimeWaiting.minutes)
}

//since we assume that the areas are at most 2km square each, we won't allow waiting times in hours in this case

fact timesCondition2{
no d:Drive | (d.userRequest.maximumWaitingTime.hours>0)
}


fact timesCondition3{
no d:Drive | (d.taxiResponse.estimatedTimeWaiting.hours>0)
}





//no one taxi in two different taxi zones

fact oneTaxiCanOnlyBeInOneTaxiZone {
 no t: TaxiDriver | some z1, z2:TaxiZone |
 z1!=z2 and (t.carId in z1.carIdQueue) and
 (t.carId in z2.carIdQueue)
}

