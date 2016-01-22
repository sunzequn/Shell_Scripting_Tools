LOAD DATA LOCAL INFILE 'data/allCountries.txt'
INTO TABLE geoname
CHARACTER SET 'utf8mb4'
(geonameid, name, asciiname, alternatenames, latitude, longitude, fclass, fcode, country, cc2, admin1, admin2, admin3, admin4, population, elevation, gtopo30, timezone, moddate);

LOAD DATA LOCAL INFILE 'data/alternateNames.txt'
INTO TABLE alternatename
CHARACTER SET 'utf8mb4'
(alternatenameid, geonameid, isoLanguage, alternateName, isPreferredName, isShortName, isColloquial, isHistoric);

LOAD DATA LOCAL INFILE 'data/iso-languagecodes.txt'
INTO TABLE iso_languagecodes
CHARACTER SET 'utf8mb4'
IGNORE 1 LINES
(iso_639_3, iso_639_2, iso_639_1, language_name);

LOAD DATA LOCAL INFILE 'data/admin1CodesASCII.txt'
INTO TABLE admin1CodesAscii
CHARACTER SET 'utf8mb4'
(code, name, nameAscii, geonameid);

LOAD DATA LOCAL INFILE 'data/admin2Codes.txt'
INTO TABLE admin2Codes
CHARACTER SET 'utf8mb4'
(code, name, nameAscii, geonameid);

LOAD DATA LOCAL INFILE 'data/hierarchy.txt'
INTO TABLE hierarchy
CHARACTER SET 'utf8mb4'
(parentId, childId, type);

LOAD DATA LOCAL INFILE 'data/featureCodes_en.txt'
INTO TABLE featureCodes
CHARACTER SET 'utf8mb4'
(code, name, description);

LOAD DATA LOCAL INFILE 'data/timeZones.txt'
INTO TABLE timeZones
CHARACTER SET 'utf8mb4'
IGNORE 1 LINES
(timeZoneId, GMT_offset, DST_offset);

LOAD DATA LOCAL INFILE 'data/countryInfo.txt'
INTO TABLE countryinfo
CHARACTER SET 'utf8mb4'
IGNORE 51 LINES
(iso_alpha2, iso_alpha3, iso_numeric, fips_code, name, capital, areaInSqKm, population, continent, tld, currency, currencyName, phone, postalCodeFormat, postalCodeRegex, languages, geonameid, neighbours, equivalentFipsCode);

LOAD DATA LOCAL INFILE 'data/continentCodes.txt'
INTO TABLE continentCodes
CHARACTER SET 'utf8mb4'
FIELDS TERMINATED BY ','
(code, name, geonameId);

LOAD DATA LOCAL INFILE 'data/zip/allCountries.txt'
INTO TABLE postalCodes
CHARACTER SET 'utf8mb4'
(country, postal_code, name, admin1_name, admin1_code, admin2_name, admin2_code, admin3_name, admin3_code, latitude, longitude, accuracy)
