-- ftp://arccf10.tor.ec.gc.ca/wsc/software/HYDAT/
CREATE TABLE 'AGENCY_LIST' ('AGENCY_ID' INTEGER, 'AGENCY_EN' TEXT, 'AGENCY_FR' TEXT);
CREATE TABLE 'ANNUAL_INSTANT_PEAKS' ('STATION_NUMBER' TEXT, 'DATA_TYPE' TEXT, 'YEAR' INTEGER, 'PEAK_CODE' TEXT, 'PRECISION_CODE' INTEGER, 'MONTH' INTEGER, 'DAY' INTEGER, 'HOUR' INTEGER, 'MINUTE' INTEGER, 'TIME_ZONE' TEXT, 'PEAK' DOUBLE, 'SYMBOL' TEXT);
CREATE TABLE 'ANNUAL_STATISTICS' ('STATION_NUMBER' TEXT, 'DATA_TYPE' TEXT, 'YEAR' INTEGER, 'MEAN' DOUBLE, 'MIN_MONTH' INTEGER, 'MIN_DAY' INTEGER, 'MIN' DOUBLE, 'MIN_SYMBOL' TEXT, 'MAX_MONTH' INTEGER, 'MAX_DAY' INTEGER, 'MAX' DOUBLE, 'MAX_SYMBOL' TEXT);
CREATE TABLE 'CONCENTRATION_SYMBOLS' ('CONCENTRATION_SYMBOL' TEXT, 'CONCENTRATION_EN' TEXT, 'CONCENTRATION_FR' TEXT);
CREATE TABLE 'DATA_SYMBOLS' ('SYMBOL_ID' TEXT, 'SYMBOL_EN' TEXT, 'SYMBOL_FR' TEXT);
CREATE TABLE 'DATA_TYPES' ('DATA_TYPE' TEXT, 'DATA_TYPE_EN' TEXT, 'DATA_TYPE_FR' TEXT);
CREATE TABLE 'DATUM_LIST' ('DATUM_ID' INTEGER, 'DATUM_EN' TEXT, 'DATUM_FR' TEXT);
CREATE TABLE 'DLY_FLOWS' ('STATION_NUMBER' TEXT, 'YEAR' INTEGER, 'MONTH' INTEGER, 'FULL_MONTH' INTEGER, 'NO_DAYS' INTEGER, 'MONTHLY_MEAN' DOUBLE, 'MONTHLY_TOTAL' DOUBLE, 'FIRST_DAY_MIN' INTEGER, 'MIN' DOUBLE, 'FIRST_DAY_MAX' INTEGER, 'MAX' DOUBLE, 'FLOW1' DOUBLE, 'FLOW_SYMBOL1' TEXT, 'FLOW2' DOUBLE, 'FLOW_SYMBOL2' TEXT, 'FLOW3' DOUBLE, 'FLOW_SYMBOL3' TEXT, 'FLOW4' DOUBLE, 'FLOW_SYMBOL4' TEXT, 'FLOW5' DOUBLE, 'FLOW_SYMBOL5' TEXT, 'FLOW6' DOUBLE, 'FLOW_SYMBOL6' TEXT, 'FLOW7' DOUBLE, 'FLOW_SYMBOL7' TEXT, 'FLOW8' DOUBLE, 'FLOW_SYMBOL8' TEXT, 'FLOW9' DOUBLE, 'FLOW_SYMBOL9' TEXT, 'FLOW10' DOUBLE, 'FLOW_SYMBOL10' TEXT, 'FLOW11' DOUBLE, 'FLOW_SYMBOL11' TEXT, 'FLOW12' DOUBLE, 'FLOW_SYMBOL12' TEXT, 'FLOW13' DOUBLE, 'FLOW_SYMBOL13' TEXT, 'FLOW14' DOUBLE, 'FLOW_SYMBOL14' TEXT, 'FLOW15' DOUBLE, 'FLOW_SYMBOL15' TEXT, 'FLOW16' DOUBLE, 'FLOW_SYMBOL16' TEXT, 'FLOW17' DOUBLE, 'FLOW_SYMBOL17' TEXT, 'FLOW18' DOUBLE, 'FLOW_SYMBOL18' TEXT, 'FLOW19' DOUBLE, 'FLOW_SYMBOL19' TEXT, 'FLOW20' DOUBLE, 'FLOW_SYMBOL20' TEXT, 'FLOW21' DOUBLE, 'FLOW_SYMBOL21' TEXT, 'FLOW22' DOUBLE, 'FLOW_SYMBOL22' TEXT, 'FLOW23' DOUBLE, 'FLOW_SYMBOL23' TEXT, 'FLOW24' DOUBLE, 'FLOW_SYMBOL24' TEXT, 'FLOW25' DOUBLE, 'FLOW_SYMBOL25' TEXT, 'FLOW26' DOUBLE, 'FLOW_SYMBOL26' TEXT, 'FLOW27' DOUBLE, 'FLOW_SYMBOL27' TEXT, 'FLOW28' DOUBLE, 'FLOW_SYMBOL28' TEXT, 'FLOW29' DOUBLE, 'FLOW_SYMBOL29' TEXT, 'FLOW30' DOUBLE, 'FLOW_SYMBOL30' TEXT, 'FLOW31' DOUBLE, 'FLOW_SYMBOL31' TEXT);
CREATE TABLE 'DLY_LEVELS' ('STATION_NUMBER' TEXT, 'YEAR' INTEGER, 'MONTH' INTEGER, 'PRECISION_CODE' INTEGER, 'FULL_MONTH' INTEGER, 'NO_DAYS' INTEGER, 'MONTHLY_MEAN' DOUBLE, 'MONTHLY_TOTAL' DOUBLE, 'FIRST_DAY_MIN' INTEGER, 'MIN' DOUBLE, 'FIRST_DAY_MAX' INTEGER, 'MAX' DOUBLE, 'LEVEL1' DOUBLE, 'LEVEL_SYMBOL1' TEXT, 'LEVEL2' DOUBLE, 'LEVEL_SYMBOL2' TEXT, 'LEVEL3' DOUBLE, 'LEVEL_SYMBOL3' TEXT, 'LEVEL4' DOUBLE, 'LEVEL_SYMBOL4' TEXT, 'LEVEL5' DOUBLE, 'LEVEL_SYMBOL5' TEXT, 'LEVEL6' DOUBLE, 'LEVEL_SYMBOL6' TEXT, 'LEVEL7' DOUBLE, 'LEVEL_SYMBOL7' TEXT, 'LEVEL8' DOUBLE, 'LEVEL_SYMBOL8' TEXT, 'LEVEL9' DOUBLE, 'LEVEL_SYMBOL9' TEXT, 'LEVEL10' DOUBLE, 'LEVEL_SYMBOL10' TEXT, 'LEVEL11' DOUBLE, 'LEVEL_SYMBOL11' TEXT, 'LEVEL12' DOUBLE, 'LEVEL_SYMBOL12' TEXT, 'LEVEL13' DOUBLE, 'LEVEL_SYMBOL13' TEXT, 'LEVEL14' DOUBLE, 'LEVEL_SYMBOL14' TEXT, 'LEVEL15' DOUBLE, 'LEVEL_SYMBOL15' TEXT, 'LEVEL16' DOUBLE, 'LEVEL_SYMBOL16' TEXT, 'LEVEL17' DOUBLE, 'LEVEL_SYMBOL17' TEXT, 'LEVEL18' DOUBLE, 'LEVEL_SYMBOL18' TEXT, 'LEVEL19' DOUBLE, 'LEVEL_SYMBOL19' TEXT, 'LEVEL20' DOUBLE, 'LEVEL_SYMBOL20' TEXT, 'LEVEL21' DOUBLE, 'LEVEL_SYMBOL21' TEXT, 'LEVEL22' DOUBLE, 'LEVEL_SYMBOL22' TEXT, 'LEVEL23' DOUBLE, 'LEVEL_SYMBOL23' TEXT, 'LEVEL24' DOUBLE, 'LEVEL_SYMBOL24' TEXT, 'LEVEL25' DOUBLE, 'LEVEL_SYMBOL25' TEXT, 'LEVEL26' DOUBLE, 'LEVEL_SYMBOL26' TEXT, 'LEVEL27' DOUBLE, 'LEVEL_SYMBOL27' TEXT, 'LEVEL28' DOUBLE, 'LEVEL_SYMBOL28' TEXT, 'LEVEL29' DOUBLE, 'LEVEL_SYMBOL29' TEXT, 'LEVEL30' DOUBLE, 'LEVEL_SYMBOL30' TEXT, 'LEVEL31' DOUBLE, 'LEVEL_SYMBOL31' TEXT);
CREATE TABLE 'MEASUREMENT_CODES' ('MEASUREMENT_CODE' TEXT, 'MEASUREMENT_EN' TEXT, 'MEASUREMENT_FR' TEXT);
CREATE TABLE 'OPERATION_CODES' ('OPERATION_CODE' TEXT, 'OPERATION_EN' TEXT, 'OPERATION_FR' TEXT);
CREATE TABLE 'PEAK_CODES' ('PEAK_CODE' TEXT, 'PEAK_EN' TEXT, 'PEAK_FR' TEXT);
CREATE TABLE 'PRECISION_CODES' ('PRECISION_CODE' INTEGER, 'PRECISION_EN' TEXT, 'PRECISION_FR' TEXT);
CREATE TABLE 'REGIONAL_OFFICE_LIST' ('REGIONAL_OFFICE_ID' INTEGER, 'REGIONAL_OFFICE_NAME_EN' TEXT, 'REGIONAL_OFFICE_NAME_FR' TEXT);
CREATE TABLE 'SAMPLE_REMARK_CODES' ('SAMPLE_REMARK_CODE' INTEGER, 'SAMPLE_REMARK_EN' TEXT, 'SAMPLE_REMARK_FR' TEXT);
CREATE TABLE 'SED_DATA_TYPES' ('SED_DATA_TYPE' TEXT, 'SED_DATA_TYPE_EN' TEXT, 'SED_DATA_TYPE_FR' TEXT);
CREATE TABLE 'SED_DLY_LOADS' ('STATION_NUMBER' TEXT, 'YEAR' INTEGER, 'MONTH' INTEGER, 'FULL_MONTH' INTEGER, 'NO_DAYS' INTEGER, 'MONTHLY_MEAN' DOUBLE, 'MONTHLY_TOTAL' DOUBLE, 'FIRST_DAY_MIN' INTEGER, 'MIN' DOUBLE, 'FIRST_DAY_MAX' INTEGER, 'MAX' DOUBLE, 'LOAD1' DOUBLE, 'LOAD2' DOUBLE, 'LOAD3' DOUBLE, 'LOAD4' DOUBLE, 'LOAD5' DOUBLE, 'LOAD6' DOUBLE, 'LOAD7' DOUBLE, 'LOAD8' DOUBLE, 'LOAD9' DOUBLE, 'LOAD10' DOUBLE, 'LOAD11' DOUBLE, 'LOAD12' DOUBLE, 'LOAD13' DOUBLE, 'LOAD14' DOUBLE, 'LOAD15' DOUBLE, 'LOAD16' DOUBLE, 'LOAD17' DOUBLE, 'LOAD18' DOUBLE, 'LOAD19' DOUBLE, 'LOAD20' DOUBLE, 'LOAD21' DOUBLE, 'LOAD22' DOUBLE, 'LOAD23' DOUBLE, 'LOAD24' DOUBLE, 'LOAD25' DOUBLE, 'LOAD26' DOUBLE, 'LOAD27' DOUBLE, 'LOAD28' DOUBLE, 'LOAD29' DOUBLE, 'LOAD30' DOUBLE, 'LOAD31' DOUBLE);
CREATE TABLE 'SED_DLY_SUSCON' ('STATION_NUMBER' TEXT, 'YEAR' INTEGER, 'MONTH' INTEGER, 'FULL_MONTH' INTEGER, 'NO_DAYS' INTEGER, 'MONTHLY_TOTAL' DOUBLE, 'FIRST_DAY_MIN' INTEGER, 'MIN' DOUBLE, 'FIRST_DAY_MAX' INTEGER, 'MAX' DOUBLE, 'SUSCON1' DOUBLE, 'SUSCON_SYMBOL1' TEXT, 'SUSCON2' DOUBLE, 'SUSCON_SYMBOL2' TEXT, 'SUSCON3' DOUBLE, 'SUSCON_SYMBOL3' TEXT, 'SUSCON4' DOUBLE, 'SUSCON_SYMBOL4' TEXT, 'SUSCON5' DOUBLE, 'SUSCON_SYMBOL5' TEXT, 'SUSCON6' DOUBLE, 'SUSCON_SYMBOL6' TEXT, 'SUSCON7' DOUBLE, 'SUSCON_SYMBOL7' TEXT, 'SUSCON8' DOUBLE, 'SUSCON_SYMBOL8' TEXT, 'SUSCON9' DOUBLE, 'SUSCON_SYMBOL9' TEXT, 'SUSCON10' DOUBLE, 'SUSCON_SYMBOL10' TEXT, 'SUSCON11' DOUBLE, 'SUSCON_SYMBOL11' TEXT, 'SUSCON12' DOUBLE, 'SUSCON_SYMBOL12' TEXT, 'SUSCON13' DOUBLE, 'SUSCON_SYMBOL13' TEXT, 'SUSCON14' DOUBLE, 'SUSCON_SYMBOL14' TEXT, 'SUSCON15' DOUBLE, 'SUSCON_SYMBOL15' TEXT, 'SUSCON16' DOUBLE, 'SUSCON_SYMBOL16' TEXT, 'SUSCON17' DOUBLE, 'SUSCON_SYMBOL17' TEXT, 'SUSCON18' DOUBLE, 'SUSCON_SYMBOL18' TEXT, 'SUSCON19' DOUBLE, 'SUSCON_SYMBOL19' TEXT, 'SUSCON20' DOUBLE, 'SUSCON_SYMBOL20' TEXT, 'SUSCON21' DOUBLE, 'SUSCON_SYMBOL21' TEXT, 'SUSCON22' DOUBLE, 'SUSCON_SYMBOL22' TEXT, 'SUSCON23' DOUBLE, 'SUSCON_SYMBOL23' TEXT, 'SUSCON24' DOUBLE, 'SUSCON_SYMBOL24' TEXT, 'SUSCON25' DOUBLE, 'SUSCON_SYMBOL25' TEXT, 'SUSCON26' DOUBLE, 'SUSCON_SYMBOL26' TEXT, 'SUSCON27' DOUBLE, 'SUSCON_SYMBOL27' TEXT, 'SUSCON28' DOUBLE, 'SUSCON_SYMBOL28' TEXT, 'SUSCON29' DOUBLE, 'SUSCON_SYMBOL29' TEXT, 'SUSCON30' DOUBLE, 'SUSCON_SYMBOL30' TEXT, 'SUSCON31' DOUBLE, 'SUSCON_SYMBOL31' TEXT);
CREATE TABLE 'SED_SAMPLES' ('STATION_NUMBER' TEXT, 'SED_DATA_TYPE' TEXT, 'DATE' DATETIME, 'SAMPLE_REMARK_CODE' TEXT, 'TIME_SYMBOL' TEXT, 'FLOW' DOUBLE, 'FLOW_SYMBOL' TEXT, 'SAMPLER_TYPE' TEXT, 'SAMPLING_VERTICAL_LOCATION' TEXT, 'SAMPLING_VERTICAL_SYMBOL' TEXT, 'TEMPERATURE' DOUBLE, 'CONCENTRATION' DOUBLE, 'CONCENTRATION_SYMBOL' TEXT, 'DISSOLVED_SOLIDS' DOUBLE, 'SAMPLE_DEPTH' DOUBLE, 'STREAMBED' TEXT, 'SV_DEPTH1' DOUBLE, 'SV_DEPTH2' DOUBLE);
CREATE TABLE 'SED_SAMPLES_PSD' ('STATION_NUMBER' TEXT, 'SED_DATA_TYPE' TEXT, 'DATE' DATETIME, 'PARTICLE_SIZE' DOUBLE, 'PERCENT' INTEGER);
CREATE TABLE 'SED_VERTICAL_LOCATION' ('SAMPLING_VERTICAL_LOCATION_ID' TEXT, 'SAMPLING_VERTICAL_LOCATION_EN' TEXT, 'SAMPLING_VERTICAL_LOCATION_FR' TEXT);
CREATE TABLE 'SED_VERTICAL_SYMBOLS' ('SAMPLING_VERTICAL_SYMBOL' TEXT, 'SAMPLING_VERTICAL_EN' TEXT, 'SAMPLING_VERTICAL_FR' TEXT);
CREATE TABLE 'STATIONS' ('STATION_NUMBER' TEXT, 'STATION_NAME' TEXT, 'PROV_TERR_STATE_LOC' TEXT, 'REGIONAL_OFFICE_ID' TEXT, 'HYD_STATUS' TEXT, 'SED_STATUS' TEXT, 'LATITUDE' DOUBLE, 'LONGITUDE' DOUBLE, 'DRAINAGE_AREA_GROSS' DOUBLE, 'DRAINAGE_AREA_EFFECT' DOUBLE, 'RHBN' INTEGER, 'REAL_TIME' INTEGER, 'CONTRIBUTOR_ID' INTEGER, 'OPERATOR_ID' INTEGER, 'DATUM_ID' INTEGER);
CREATE TABLE 'STN_DATA_COLLECTION' ('STATION_NUMBER' TEXT, 'DATA_TYPE' TEXT, 'YEAR_FROM' INTEGER, 'YEAR_TO' INTEGER, 'MEASUREMENT_CODE' TEXT, 'OPERATION_CODE' TEXT);
CREATE TABLE 'STN_DATA_RANGE' ('STATION_NUMBER' TEXT, 'DATA_TYPE' TEXT, 'SED_DATA_TYPE' TEXT, 'YEAR_FROM' INTEGER, 'YEAR_TO' INTEGER, 'RECORD_LENGTH' INTEGER);
CREATE TABLE 'STN_DATUM_CONVERSION' ('STATION_NUMBER' TEXT, 'DATUM_ID_FROM' INTEGER, 'DATUM_ID_TO' INTEGER, 'CONVERSION_FACTOR' DOUBLE);
CREATE TABLE 'STN_DATUM_UNRELATED' ('STATION_NUMBER' TEXT, 'DATUM_ID' INTEGER, 'YEAR_FROM' DATETIME, 'YEAR_TO' DATETIME);
CREATE TABLE 'STN_OPERATION_SCHEDULE' ('STATION_NUMBER' TEXT, 'DATA_TYPE' TEXT, 'YEAR' INTEGER, 'MONTH_FROM' TEXT, 'MONTH_TO' TEXT);
CREATE TABLE 'STN_REGULATION' ('STATION_NUMBER' TEXT, 'YEAR_FROM' INTEGER, 'YEAR_TO' INTEGER, 'REGULATED' INTEGER);
CREATE TABLE 'STN_REMARKS' ('STATION_NUMBER' TEXT, 'REMARK_TYPE_CODE' INTEGER, 'YEAR' INTEGER, 'REMARK_EN' TEXT, 'REMARK_FR' TEXT);
CREATE TABLE 'STN_REMARK_CODES' ('REMARK_TYPE_CODE' INTEGER, 'REMARK_TYPE_EN' TEXT, 'REMARK_TYPE_FR' TEXT);
CREATE TABLE 'STN_STATUS_CODES' ('STATUS_CODE' TEXT, 'STATUS_EN' TEXT, 'STATUS_FR' TEXT);
CREATE TABLE 'VERSION' ('Version' TEXT, 'Date' DATETIME);
CREATE UNIQUE INDEX 'STN_DATUM_UNRELATED_PrimaryKey' ON 'STN_DATUM_UNRELATED' ('STATION_NUMBER' , 'DATUM_ID' )
CREATE  INDEX 'OPERATION_CODES_OPERATION_CODE' ON 'OPERATION_CODES' ('OPERATION_CODE' )
CREATE UNIQUE INDEX 'OPERATION_CODES_PrimaryKey' ON 'OPERATION_CODES' ('OPERATION_CODE' )
CREATE UNIQUE INDEX 'STN_OPERATION_SCHEDULE___uniqueindex' ON 'STN_OPERATION_SCHEDULE' ('STATION_NUMBER' , 'DATA_TYPE' , 'YEAR' )
CREATE  INDEX 'MEASUREMENT_CODES_MEASUREMENT_CODE' ON 'MEASUREMENT_CODES' ('MEASUREMENT_CODE' )
CREATE UNIQUE INDEX 'MEASUREMENT_CODES_PrimaryKey' ON 'MEASUREMENT_CODES' ('MEASUREMENT_CODE' )
CREATE UNIQUE INDEX 'DATUM_LIST_PrimaryKey' ON 'DATUM_LIST' ('DATUM_ID' )
CREATE  INDEX 'PEAK_CODES_PEAK_CODE' ON 'PEAK_CODES' ('PEAK_CODE' )
CREATE UNIQUE INDEX 'PEAK_CODES_PrimaryKey' ON 'PEAK_CODES' ('PEAK_CODE' )
CREATE UNIQUE INDEX 'DATA_SYMBOLS_PrimaryKey' ON 'DATA_SYMBOLS' ('SYMBOL_ID' )
CREATE  INDEX 'DATA_SYMBOLS_SYMBOL_ID' ON 'DATA_SYMBOLS' ('SYMBOL_ID' )
CREATE UNIQUE INDEX 'SED_VERTICAL_LOCATION_PrimaryKey' ON 'SED_VERTICAL_LOCATION' ('SAMPLING_VERTICAL_LOCATION_ID' )
CREATE UNIQUE INDEX 'DLY_LEVELS_PrimaryKey' ON 'DLY_LEVELS' ('STATION_NUMBER' , 'YEAR' , 'MONTH' )
CREATE UNIQUE INDEX 'STATIONS___uniqueindex' ON 'STATIONS' ('STATION_NUMBER' )
CREATE  INDEX 'STATIONS_OPERATOR_ID' ON 'STATIONS' ('OPERATOR_ID' )
CREATE UNIQUE INDEX 'STN_REMARK_CODES_PrimaryKey' ON 'STN_REMARK_CODES' ('REMARK_TYPE_CODE' )
CREATE  INDEX 'STN_REMARK_CODES_REMARK_TYPE_CODE' ON 'STN_REMARK_CODES' ('REMARK_TYPE_CODE' )
CREATE UNIQUE INDEX 'SAMPLE_REMARK_CODES_PrimaryKey' ON 'SAMPLE_REMARK_CODES' ('SAMPLE_REMARK_CODE' )
CREATE  INDEX 'SAMPLE_REMARK_CODES_SAMPE_REMARK_CODE' ON 'SAMPLE_REMARK_CODES' ('SAMPLE_REMARK_CODE' )
CREATE UNIQUE INDEX 'STN_DATA_COLLECTION___uniqueindex' ON 'STN_DATA_COLLECTION' ('STATION_NUMBER' , 'DATA_TYPE' , 'YEAR_FROM' )
CREATE UNIQUE INDEX 'AGENCY_LIST_PrimaryKey' ON 'AGENCY_LIST' ('AGENCY_ID' )
CREATE UNIQUE INDEX 'SED_DLY_LOADS_PrimaryKey' ON 'SED_DLY_LOADS' ('STATION_NUMBER' , 'YEAR' , 'MONTH' )
CREATE UNIQUE INDEX 'STN_DATUM_CONVERSION_PrimaryKey' ON 'STN_DATUM_CONVERSION' ('STATION_NUMBER' , 'DATUM_ID_FROM' , 'DATUM_ID_TO' )
CREATE UNIQUE INDEX 'STN_STATUS_CODES_PrimaryKey' ON 'STN_STATUS_CODES' ('STATUS_CODE' )
CREATE  INDEX 'STN_STATUS_CODES_STATUS_CODE' ON 'STN_STATUS_CODES' ('STATUS_CODE' )
CREATE  INDEX 'PRECISION_CODES_PRECISION_CODE' ON 'PRECISION_CODES' ('PRECISION_CODE' )
CREATE UNIQUE INDEX 'PRECISION_CODES_PrimaryKey' ON 'PRECISION_CODES' ('PRECISION_CODE' )
CREATE UNIQUE INDEX 'REGIONAL_OFFICE_LIST_PrimaryKey' ON 'REGIONAL_OFFICE_LIST' ('REGIONAL_OFFICE_ID' )
CREATE  INDEX 'REGIONAL_OFFICE_LIST_REGIONAL_OFFICE_ID' ON 'REGIONAL_OFFICE_LIST' ('REGIONAL_OFFICE_ID' )
CREATE UNIQUE INDEX 'SED_DLY_SUSCON_PrimaryKey' ON 'SED_DLY_SUSCON' ('STATION_NUMBER' , 'YEAR' , 'MONTH' )
CREATE UNIQUE INDEX 'SED_DATA_TYPES_PrimaryKey' ON 'SED_DATA_TYPES' ('SED_DATA_TYPE' )
CREATE UNIQUE INDEX 'SED_SAMPLES_PrimaryKey' ON 'SED_SAMPLES' ('STATION_NUMBER' , 'SED_DATA_TYPE' , 'DATE' )
CREATE  INDEX 'SED_SAMPLES_SAMPLE_REMARK_CODE' ON 'SED_SAMPLES' ('SAMPLE_REMARK_CODE' )
CREATE UNIQUE INDEX 'ANNUAL_STATISTICS_PrimaryKey' ON 'ANNUAL_STATISTICS' ('STATION_NUMBER' , 'DATA_TYPE' , 'YEAR' )
CREATE UNIQUE INDEX 'SED_SAMPLES_PSD_PrimaryKey' ON 'SED_SAMPLES_PSD' ('STATION_NUMBER' , 'SED_DATA_TYPE' , 'DATE' , 'PARTICLE_SIZE' )
CREATE UNIQUE INDEX 'DLY_FLOWS_PrimaryKey' ON 'DLY_FLOWS' ('STATION_NUMBER' , 'YEAR' , 'MONTH' )
CREATE UNIQUE INDEX 'ANNUAL_INSTANT_PEAKS___uniqueindex' ON 'ANNUAL_INSTANT_PEAKS' ('STATION_NUMBER' , 'DATA_TYPE' , 'YEAR' , 'PEAK_CODE' )
CREATE  INDEX 'ANNUAL_INSTANT_PEAKS_PRECISION_CODE' ON 'ANNUAL_INSTANT_PEAKS' ('PRECISION_CODE' )
CREATE UNIQUE INDEX 'STN_REGULATION_PrimaryKey' ON 'STN_REGULATION' ('STATION_NUMBER' )
CREATE UNIQUE INDEX 'STN_REMARKS___uniqueindex' ON 'STN_REMARKS' ('STATION_NUMBER' , 'REMARK_TYPE_CODE' , 'YEAR' )
CREATE UNIQUE INDEX 'SED_VERTICAL_SYMBOLS_PrimaryKey' ON 'SED_VERTICAL_SYMBOLS' ('SAMPLING_VERTICAL_SYMBOL' )
CREATE  INDEX 'SED_VERTICAL_SYMBOLS_SAMPLING_VERTICAL_LOCATION_ID' ON 'SED_VERTICAL_SYMBOLS' ('SAMPLING_VERTICAL_SYMBOL' )
CREATE UNIQUE INDEX 'DATA_TYPES_PrimaryKey' ON 'DATA_TYPES' ('DATA_TYPE' )
CREATE UNIQUE INDEX 'CONCENTRATION_SYMBOLS_PrimaryKey' ON 'CONCENTRATION_SYMBOLS' ('CONCENTRATION_SYMBOL' )
CREATE UNIQUE INDEX 'STN_DATA_RANGE_PrimaryKey' ON 'STN_DATA_RANGE' ('STATION_NUMBER' , 'DATA_TYPE' , 'SED_DATA_TYPE' )
