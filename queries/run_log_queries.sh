#!/usr/bin/env bash
#
# ./run_log_queries.sh &> run_log_queries_output.txt

xsb --quietload --noprompt --nofeedback --nobanner << END_XSB_STDIN

['$RULES_DIR/log_query_rules'].
['$QUERIES_DIR/log_queries'].
['$FACTS_DIR/yw_extract_facts'].
['$FACTS_DIR/yw_model_facts'].
['$FACTS_DIR/reconfacts'].


printall('lq1(OccurrenceID, IsMarineValue) - Given an occurrenceID "MCZ:Orn:149849", confirm if the record is Marine or not?', lq1(_,_)).

printall('lq2(MarineCount) - How many records are Marine (noMarine)?', lq2(_)).

printall('lq3(RecordID) - Which records are Marine?', lq3(_)).

% printall('log_record_source(OccurrenceID, MarineValue, Source)', log_record_source(_,_,_)).

% printall('log_record_index(OccurrenceID, MarineValue, Index)', log_record_index(_,_,_)).

% printall('log_record_match_result(OccurrenceID, MarineValue, ScientificName, ScientificNameAuthorship, MatchFound, Source)', log_record_match_result(_,_,_,_,_,_)).

printall('lq4(OccurrenceID, MatchFound, Source_Used) - Given an occurrenceID, is a match found (GUID:not null --> Match; GUID:null --> Unable to validate)? What data sources (validation services) were used (GBIFLookup or WoRMSLookup)?', lq4(_,_,_)).

% printall('log_marine_match(OccurrenceID)', log_marine_match(_)).

printall('lq5(MarineMatchCount) - How many Marine(noMarine) records found a match?', lq5(_)).

printall('lq6(OccurrenceID) - Which records found a match?', lq6(_)).

printall('lq7(NoMatchCount) - How many records could not find a match?', lq7(_)).

% printall('log_record_data_value(OccurrenceID,DataName, DataNameValue, TaggedDataRecord,TaggedDataRecordValue, MScientificNameAuthorship,MScientificNameAuthorshipValue, NMScientificNameAuthorship,NMScientificNameAuthorshipValie, WoRMSOutput,WoRMSOutputValue, GBIFOutput, GBIFOutputValue)', log_record_data_value(_,_,_,_,_,_,_,_,_,_,_,_,_)).

% printall('data_record(H, DataName, DataRecord)', data_record(_,_,_)).


END_XSB_STDIN












