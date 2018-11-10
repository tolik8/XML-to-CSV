load data
 infile 'minust_fiz.csv'
 into table minust_fiz
 fields terminated by ";" optionally enclosed by '"'		  
 ( fio, adr, kved, stan )