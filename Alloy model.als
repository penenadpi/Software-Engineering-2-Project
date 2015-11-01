//DATATYPES SIGNATURES
//Here are the signatures of the datatypes used in the domain of the problem itself
sig Integer{}
sig Strings{}

sig Time{
hours: one integer,
minutes: one integer
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
