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
//owner: one TaxiDriver
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
centerPoint: one Location,

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


//User mandatory fields
fact noSenderMissing{
		all m:Message | (#m.sender=1) 
}



//Admin mandatory fields
fact noUsernameMissingAdmin{
		all a:Admin | (#a.password=1)
}

fact noPasswordMissingAdmin{
		all a:Admin | (#a.password=1)
}
//



//Scheduler must have at least one zone
fact minZones{
	all s:Scheduler| (#s.zones>1)
}






//Taxi driver is eligible if and only if has a car and license number
fact noUnlicensedAndCarlessTaxiDriver{
	all t:TaxiDriver | (#t.carId=1) and (#t.licenseNumber=1) and (#t.carModel=1)
}




//No duplicate and overlap-alike facts



//no duplicate usernames
fact noDuplicateUser{
	no  u1,u2: User |(u1!=u2) and  (u1.username=u2.username)
}

//no possibility for one user to register more than once with a same fiscal code


fact noFakeProfiles{
	no u1,u2: User | (u1!=u2) and (u1.codiceFiscale=u2.codiceFiscale)
}


//




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
	no z1,z2: TaxiZone | (z1!=z2)  and (z1.centerPoint=z2.centerPoint)
}

//No taxi zones with same ids

fact noSameIdZones{
	no  z1,z2: TaxiZone | (z1!=z2) and  (z1.zoneId=z2.zoneId)
}



//No car number belonging to different owners at the same time
//fact noSameCarOwner{
	//no  cn1, cn2: CarNumber | (cn1!=cn2) and  (cn1.owner=cn2.owner)
//}

fact noSameCarNumbers{
	no  cn1, cn2: CarNumber | (cn1!=cn2) and (cn1.id=cn2.id)
}




//No two taxi drivers with same car
fact noSameDriverCars{
	no td1, td2: TaxiDriver | (td1!=td2) and  (td1.carId=td2.carId)
}

//No taxi drivers with same license id allowed
fact noSameLicense{
	no  td1,td2: TaxiDriver | (td1!=td2) and  (td1.licenseNumber=td2.licenseNumber)
}

//No two drives with same ids

fact noSameDriveId{
	no d1,d2: Drive | (d1!=d2) and (d1.driveId=d2.driveId)
}


//A taxi drivers can respond to requests that are from users in that taxi zone

fact responseCondition1{
no r:Request | r.sender. currentZone!=r.receiver.currentZone
}

fact responseCondition2{
no r:Response | r.sender. currentZone!=r.receiver.currentZone
}

//No two requests from same sender can be in one queue of request per taxi zone

fact noTwoZonesSameSender{
 no r1,r2:Request | some z:TaxiZone|
 r1!=r2 and (r1 in z.requestQueue) and
 (r2 in z.requestQueue) and (r1.sender=r2.receiver)
}


//One request can't belong to queues of two different taxi zones at the same time

fact noTwoZonesSameRequest{
 no r: Request | some z1, z2:TaxiZone |
 z1!=z2 and (r in z1.requestQueue) and
 (r in z2.requestQueue)
}





//Are always the right actors reported in a drive
fact driveReportsRule{
all d:Drive,r:Report| (r in d.reports) and (   (r.sender =d.userRequest.sender) or (r.sender=d.userRequest.receiver)    )
}

//The condition when a drive is considered correct
fact correctDrive{
all d:Drive| (d.userRequest.sender = d.taxiResponse.receiver)
}





//One taxi can't belong to queues of two different taxi zones
fact oneTaxiCanOnlyBeInOneTaxiZone {
 no t: TaxiDriver | some z1, z2:TaxiZone |
 z1!=z2 and (t.carId in z1.carIdQueue) and
 (t.carId in z2.carIdQueue)
}



//All zones belong to one scheduler per city

fact allBelong{
all t:TaxiZone| some s:Scheduler| (t in s.zones)
}




//3. ASSERTS

//Checking if there are  same requests in two zones
assert NoTwoZonesSameRequest{
 no r: Request | some z1, z2:TaxiZone |
 z1!=z2 and (r in z1.requestQueue) and
 (r in z2.requestQueue)
}
check NoTwoZonesSameRequest for 5


//Checking if there is no self-message

assert NoSelfMessage{
 no m: Message | m.sender=m.receiver
}
check NoSelfMessage for 5





//Checking add request
assert addRequest{
all r:Request, t1:TaxiZone,t2:TaxiZone | (r not in t1.requestQueue) and  addRequestToTaxiZone[r,t1,t2] implies (r in t2.requestQueue)
}

check addRequest for 5

assert deleteRequest{
all r:Request, t1:TaxiZone,t2:TaxiZone | (r  in t1.requestQueue) and  removeRequestFromTaxiZone[r,t1,t2] implies (r not in t2.requestQueue)
}
check addRequest for 5

//Are always the right actors reported in a drive
assert driveReports{
all d:Drive,r:Report| (r in d.reports) and (   (r.sender =d.userRequest.sender) or (r.sender=d.userRequest.receiver))
}
check driveReports for 5





//DriveRule
assert driveRule{
all d:Drive| (d.userRequest.sender = d.taxiResponse.receiver)
}
check driveRule for 5



//Should find counterexample!- Simulating a situation where two taxi drivers register with same car
//A trivially false assert will result in counterexamples being found when it is checked. 
//Since anything makes such an assertion false, any example of the system will be a counterexample. 
assert assignSame1{
all cn:CarNumber, t1,t2,t3,t4:TaxiDriver| AssignCarNumber [cn, t1, t2] and AssignCarNumber [cn,t3,t4]
}
check assignSame1 for 10



//Shouldn't find a counterexample this time
assert assignSame2{
all cn:CarNumber, t1,t2,t3,t4:TaxiDriver| AssignCarNumber [cn, t1, t2] and AssignCarNumber [cn, t3, t4] implies (t4=t2)
}
check assignSame2 for 10

//4. PREDICATES

//To genrate world example
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
#TaxiZone=2
#CarNumber=2
}
run show for 5









//Adding request to a taxi zone
pred addRequestToTaxiZone(r:Request, t1,t2:TaxiZone)
{
r not in t1.requestQueue implies t2.requestQueue=t1.requestQueue+r
}
run addRequestToTaxiZone for 5

//Removing request from a taxi zone
pred removeRequestFromTaxiZone(r:Request, t1,t2:TaxiZone)
{
t2.requestQueue=t1.requestQueue-r
}
run removeRequestFromTaxiZone for 5


//Assigning taxi driver a car number


pred  AssignCarNumber(cn:CarNumber, td1,td2:TaxiDriver)
{
td2.carId=td1.carId+cn
}
run AssignCarNumber for 5









