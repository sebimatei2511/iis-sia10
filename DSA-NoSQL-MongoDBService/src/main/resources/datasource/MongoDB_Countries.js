// use mds;
db.Countries.insertOne(
    { "name": "Romania",
        "alpha2": "RO",
        "alpha3": "ROU",
        "region": "Europe",
        "capital": "Bucharest"
    });


db.Countries.find() ;
// SQL equivalent:
// SELECT * FROM Countries

db.Countries.find({'region': 'Europe'});