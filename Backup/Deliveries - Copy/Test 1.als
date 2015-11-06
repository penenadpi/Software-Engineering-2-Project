//1.SIGNATURES







//DATATYPES SIGNATURES

//common datatypes definitions for types oftenly found in programming languages and necessary for this
//problem

sig Strings{}
sig Char{}
sig Integer{}


//Here are the signatures of the datatypes used in the domain of the problem itself in terms of time and space

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
dateStamp: one Date
}

sig Location {
coordinates: one Strings,
streetName: one Strings,
streetNumber:one Integer
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
gender: one Char,
picturePath: one Strings,
currentLocation:one Location,
currentZone:one TaxiZone,
codiceFiscale: one Strings
}


sig TaxiDriver extends User{
carId:one CarNumber,
licenseNumber:one Strings,
carModel:one Strings,
availability:one Char,
emergency:one Char
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
reason: one Strings,
id:  one Strings
}


sig Drive{
driveId: one Strings,
userRequest: one Request,
taxiResponse:one Response,
reports: set Report
}


//System-related entities
sig TaxiZone{
zoneId: one Strings,
requestQueue: set Request,
carIdQueue: set CarNumber,
centerPoint: one Location
}

sig Scheduler{

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

//User mandatory fields
fact noUserMissingInfo{
		all u:User | (#u.username=1) and (#u.password=1)
}



//Admin mandatory fields
fact noUsernameMissingAdmin{
		all a:Admin | (#a.password=1)
}

fact noPasswordMissingAdmin{
		all a:Admin | (#a.password=1)
}
//

//Taxi driver is eligible if and only if has a car and license number
fact noUnlicensedAndCarlessTaxiDriver{
	all t:TaxiDriver | (#t.carId=1) and (#t.licenseNumber=1) and (#t.carModel=1)
}




//No duplicate and overlap-alike facts



//no duplicate usernames
fact noDuplicateUser{
	no disj u1,u2: User | (u1.username=u2.username)
}

//no possibility for one user to register more than once with a same fiscal code


fact noFakeProfiles{
	no disj u1,u2: User | (u1.codiceFiscale=u2.codiceFiscale)
}



//No self-communication allowed - all the requests,responses and report are towards differnt users

fact noSelfCommunication{
	all u:User, m:Message | not ( (m.sender=u) and (m.receiver=u) )
}

//No sending requests, responses or reports to same location

fact noSameStartAsEnd{
	all m:Message | not ( m.startpoint=m.endpoint )
}

//No taxi zones with same center points

fact noSameZones{
	no disj z1,z2: TaxiZone | not  (z1.centerPoint=z2.centerPoint)
}

//No taxi zones with same ids

fact noSameIdZones{
	no disj z1,z2: TaxiZone | not  (z1.zoneId=z2.zoneId)
}


//No two taxi drivers with same car
fact noSameDriverCars{
	no disj td1, td2: TaxiDriver | not (td1.carId=td2.carId)
}

//No taxi drivers with same license id allowed
fact noSameLicense{
	no disj td1,td2: TaxiDriver | not (td1.licenseNumber=td2.licenseNumber)
}

//No two drives with same ids

fact noSameDriveId{
	no disj d1,d2: Drive | not (d1.driveId=d2.driveId)
}


//A taxi drivers can respond to requests that are from users in that taxi zone

fact responseCondition1{
no r:Request | r.sender. currentZone!=r.receiver.currentZone
}

fact responseCondition2{
no r:Response | r.sender. currentZone!=r.receiver.currentZone
}

//One request can't belong to queues of two different taxi zones



//One taxi can't belong to queues of two different taxi zones

fact oneTaxiCanOnlyBeInOneTaxiZone {
 no t: TaxiDriver | some z1, z2:TaxiZone |
 z1!=z2 and (t.carId in z1.carIdQueue) and
 (t.carId in z2.carIdQueue)
}

pred show(){
#User=2
#TaxiDriver=2
#Guest=2
#Drive=2
#Strings=2
#Char=2
#Integer=2
#Time=2
#Date=2
#TimeDate=2
#Request=2
#Response=2
#Location=3
#Scheduler=1
}
run show for 5






