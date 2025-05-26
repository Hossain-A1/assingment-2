

CREATE Table rangers(
  ranger_id  SERIAL PRIMARY key ,
  name VARCHAR(50) NOT NULL,
 region VARCHAR(50) NOT NULL
)



INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');


CREATE Table species (
  species_id  SERIAL PRIMARY key,
  common_name VARCHAR(50) NOT NULL,
  scientific_name VARCHAR(100) NOT NULL,
  discovery_date DATE NOT NULL,
  conservation_status VARCHAR(50) NOT NULL
)


-- Insert sample data
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');


CREATE Table sightings (
  sighting_id SERIAL PRIMARY KEY,
  species_id int ,
   constraint fk_species_id FOREIGN KEY (species_id) REFERENCES 
  species(species_id),
  ranger_id int, constraint fk_ranger_id Foreign Key (ranger_id) REFERENCES rangers (ranger_id ),
  location VARCHAR(100) NOT NULL,
  sighting_time TIMESTAMP,
notes TEXT 
)



INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


--problem(01)
INSERT into rangers (name,region) VALUES('Derek Fox','Coastal Plains')


--problem(02)
SELECT count(DISTINCT species_id) as unique_species_count from sightings

--problem(3)
SELECT * from sightings WHERE location ILIKE ('%Pass%')

--problem(04)
SELECT name ,count(species_id) as total_sightings  from rangers as r  join sightings as s on s.ranger_id  = r.ranger_id GROUP BY name

--problem(05)
SELECT common_name from species as sp  join sightings as sig on sp.species_id =sig.sighting_id WHERE sp.species_id != sig.species_id

--problem(06)
SELECT common_name ,sighting_time,name  from sightings JOIN species on sightings.sighting_id=species.species_id
JOIN rangers on sightings.sighting_id = rangers.ranger_id
ORDER BY sightings.sighting_time DESC
LIMIT 2

--problem(07)
UPDATE species
SET conservation_status = 'Historic' where discovery_date < '1800-01-01'


--problem(08)
CREATE or REPLACE Function each_sighting_time(p_ts TIMESTAMP) RETURNS text LANGUAGE plpgsql as 
$$
BEGIN
if extract(HOUR from p_ts)< 12 THEN
RETURN 'Morning';
ELSEIF extract(HOUR FROM p_ts) >= 12 and extract(HOUR from p_ts) <17 THEN RETURN 'Afternoon';
ELSE 
 RETURN 'Evening';
end IF;
end;
$$;

SELECT sighting_id,each_sighting_time(sighting_time) as time_of_day from sightings


--problem(09
DELETE FROM rangers
WHERE ranger_id NOT IN (
  SELECT ranger_id from sightings
);



select * from sightings

select * from species 

select * from rangers
