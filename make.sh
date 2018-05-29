#!/usr/bin/env bash

# @BEGIN Make
# @PARAM settings.sh
# @IN SourceScript @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/file_branching_taxon_lookup.yaml


# @BEGIN SetVariables @desc Set variables and create output directories
# @PARAM settings.sh
# @OUT FACTS_DIR
# @OUT VIEWS_DIR
# @OUT RESULTS_DIR
# set variables
source settings.sh

# create output directories
mkdir -p $FACTS_DIR
mkdir -p $VIEWS_DIR
mkdir -p $RESULTS_DIR
# @END SetVariables

# @BEGIN GenerateProspectiveProvenance @desc Export YW model and extract facts, and draw complete workflow graph with URI template
# @IN SourceScript @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/file_branching_taxon_lookup.yaml
# @PARAM FACTS_DIR
# @PARAM RESULTS_DIR
# @OUT yw_extract_facts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/yw_extract_facts.P
# @OUT yw_model_facts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/yw_model_facts.P
# @OUT complete_wf_graph_uri.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/complete_wf_graph_uri_make.gv
# export YW model and extract facts, and draw complete workflow graph with URI template
cp yw.properties yw_make.properties
cp yw_wf.properties yw.properties
$YW_CMD graph
dot -Tpdf $RESULTS_DIR/complete_wf_graph_uri.gv > $RESULTS_DIR/complete_wf_graph_uri.pdf
dot -Tsvg $RESULTS_DIR/complete_wf_graph_uri.gv > $RESULTS_DIR/complete_wf_graph_uri.svg
# @END GenerateProspectiveProvenance

# @BEGIN MaterializeViewsOfYWFacts
# @IN yw_extract_facts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/yw_extract_facts.P
# @IN yw_model_facts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/yw_model_facts.P
# @PARAM VIEWS_DIR
# @IN materialize_yw_views.sh @URI file:queries/materialize_yw_views.sh 
# @OUT yw_views.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/views/yw_views.P
# materialize views of YW facts
$QUERIES_DIR/materialize_yw_views.sh > $VIEWS_DIR/yw_views.P
# @END MaterializeViewsOfYWFacts

# @BEGIN ListWorkflowOutputs @desc list workflow outputs
# @IN list_workflow_outputs.sh @URI file:queries/list_workflow_outputs.sh
# @IN yw_views.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/views/yw_views.P
# @OUT workflow_outputs.txt @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/workflow_outputs.txt
# list workflow outputs
$QUERIES_DIR/list_workflow_outputs.sh > $RESULTS_DIR/workflow_outputs.txt
# @END ListWorkflowOutputs

# @BEGIN RunTheWorkflow
# @IN SourceScript @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/file_branching_taxon_lookup.yaml
# @PARAM DarwinCoreArchive @URI file:packages/kurator_FileBranchingTaxonLookup/data/kurator_sample_data_v2.txt
# @OUT ScriptOutput @URI file:{workspace}/mergedoutputfile.csv    
# @OUT LogFile @URI file:runlog.log

# run the workflow
java -jar target/kurator-validation-1.0.2-SNAPSHOT-jar-with-dependencies.jar -f packages/kurator_FileBranchingTaxonLookup/workflows/file_branching_taxon_lookup.yaml -p inputfile=packages/kurator_FileBranchingTaxonLookup/data/kurator_sample_data_v2.txt -l ALL > ./packages/kurator_FileBranchingTaxonLookup/workflows/results/runlog.log 2>&1
# @END RunTheWorkflow

cp -r packages/kurator_FileBranchingTaxonLookup/data packages/kurator_FileBranchingTaxonLookup/workflows/results/
cp -r workspace_* packages/kurator_FileBranchingTaxonLookup/workflows/results/

# @BEGIN GenerateReconfacts
# @PARAM DarwinCoreArchive @URI file:packages/kurator_FileBranchingTaxonLookup/data/kurator_sample_data_v2.txt
# @IN ScriptOutput @URI file:{workspace}/mergedoutputfile.csv    
# @IN LogFile @URI file:runlog.log
# @IN yw_model_facts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/yw_model_facts.P
# @OUT reconfacts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/reconfacts.P
# generate reconfacts.P to facts/ folder 
$YW_CMD recon
# @END GenerateReconfacts


# @BEGIN RunQ1ProspectiveProvenanceUpstreamSubgraphQueries @desc Draw worfklow graph upstream of a productName
# @IN productName
# @IN render_wf_graph_upstream_of_data_q1.sh @URI file:queries/render_wf_graph_upstream_of_data_q1.sh
# @IN yw_views.P @URI file: packages/kurator_FileBranchingTaxonLookup/workflows/views/yw_views.P
# @OUT wf_upstream_of_{productName}.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/wf_upstream_of_{productName}.gv
##############
#   Q1_pro   #
##############

# draw worfklow graph upstream of UpdatedOccurrenceFile
productName=UpdatedOccurrenceFile
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'$productName\' > $RESULTS_DIR/wf_upstream_of_$productName.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.pdf
dot -Tsvg $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.svg

# draw worfklow graph upstream of GBIFUpdatedRecord
productName="GBIFUpdatedRecord"
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'$productName\' > $RESULTS_DIR/wf_upstream_of_$productName.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.pdf
dot -Tsvg $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.svg

# draw worfklow graph upstream of LogFile
productName="LogFile"
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'$productName\' > $RESULTS_DIR/wf_upstream_of_$productName.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.pdf
dot -Tsvg $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.svg

# draw worfklow graph upstream of MarineDataRecord
productName="MarineDataRecord"
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'$productName\' > $RESULTS_DIR/wf_upstream_of_$productName.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.pdf
dot -Tsvg $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.svg
# @END RunQ1ProspectiveProvenanceUpstreamSubgraphQueries

# @BEGIN RunQ2ProspectiveProvenanceUpstreamListQueries @desc List workflow inputs upstream of a productName
# @IN productName
# @IN list_inputs_upstream_of_data_q2.sh @URI file:queries/list_inputs_upstream_of_data_q2.sh
# @IN yw_views.P @URI file: packages/kurator_FileBranchingTaxonLookup/workflows/views/yw_views.P
# @OUT inputs_upstream_of_{productName}.txt @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/inputs_upstream_of_{productName}.txt
##############
#   Q2_pro   #
##############

# list workflow inputs upstream of output data UpdatedOccurrenceFile
$QUERIES_DIR/list_inputs_upstream_of_data_q2.sh \'UpdatedOccurrenceFile\' UpdatedOccurrenceFile > $RESULTS_DIR/inputs_upstream_of_UpdatedOccurrenceFile.txt

# list workflow inputs upstream of intermediate data MergedStream
$QUERIES_DIR/list_inputs_upstream_of_data_q2.sh \'MergedStream\' MergedStream > $RESULTS_DIR/inputs_upstream_of_MergedStream.txt
# @END RunQ2ProspectiveProvenanceUpstreamListQueries


# @BEGIN RunQ3ProspectiveProvenanceDownstreamSubgraphQueries @desc Draw workflow graph downstream of a productName
# @IN productName
# @IN render_wf_graph_downstream_of_data_q3.sh @URI file:queries/render_wf_graph_downstream_of_data_q3.sh
# @IN yw_views.P @URI file: packages/kurator_FileBranchingTaxonLookup/workflows/views/yw_views.P
# @OUT wf_downstream_of_{productName}.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/wf_downstream_of_{productName}.gv
##############
#   Q3_pro   #
##############

# draw workflow graph downstream of DataRecord
$QUERIES_DIR/render_wf_graph_downstream_of_data_q3.sh \'DataRecord\' > $RESULTS_DIR/wf_downstream_of_DataRecord.gv
dot -Tpdf $RESULTS_DIR/wf_downstream_of_DataRecord.gv > $RESULTS_DIR/wf_downstream_of_DataRecord.pdf
dot -Tsvg $RESULTS_DIR/wf_downstream_of_DataRecord.gv > $RESULTS_DIR/wf_downstream_of_DataRecord.svg

# draw workflow graph downstream of Workspace
$QUERIES_DIR/render_wf_graph_downstream_of_data_q3.sh \'Workspace\' > $RESULTS_DIR/wf_downstream_of_Workspace.gv
dot -Tpdf $RESULTS_DIR/wf_downstream_of_Workspace.gv > $RESULTS_DIR/wf_downstream_of_Workspace.pdf
dot -Tsvg $RESULTS_DIR/wf_downstream_of_Workspace.gv > $RESULTS_DIR/wf_downstream_of_Workspace.svg
# @END RunQ3ProspectiveProvenanceDownstreamSubgraphQueries

# @BEGIN RunQ4ProspectiveProvenanceDownstreamListQueries @desc List workflow outputs downstream of a productName
# @IN productName
# @IN list_outputs_downstream_of_data_q4.sh @URI file:queries/list_outputs_downstream_of_data_q4.sh
# @IN yw_views.P @URI file: packages/kurator_FileBranchingTaxonLookup/workflows/views/yw_views.P
# @OUT outputs_downstream_of_{productName}.txt @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/outputs_downstream_of_{productName}.txt
##############
#   Q4_pro   #
##############

# list workflow outputs downstream of DataRecord
$QUERIES_DIR/list_outputs_downstream_of_data_q4.sh \'DataRecord\' DataRecord > $RESULTS_DIR/outputs_downstream_of_DataRecord.txt

# list workflow outputs downstream of Workspace
$QUERIES_DIR/list_outputs_downstream_of_data_q4.sh \'Workspace\' Workspace > $RESULTS_DIR/outputs_downstream_of_Workspace.txt
# @END RunQ4ProspectiveProvenanceDownstreamListQueries

# @BEGIN RunQ5HybridProvenanceFileLevelGraphQueries @desc Draw recon workflow graph with all (file-level) runtime observables
# @IN render_recon_complete_wf_graph_q5.sh @URI file:queries/render_recon_complete_wf_graph_q5.sh
# @IN yw_views.P @URI file: packages/kurator_FileBranchingTaxonLookup/workflows/views/yw_views.P
# @IN reconfacts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/reconfacts.P
# @OUT wf_recon_complete_graph_all_observables.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/wf_recon_complete_graph_all_observables.gv
##############
#   Q5_pro   #
##############

# draw recon workflow graph with all (file-level) runtime observables
$QUERIES_DIR/render_recon_complete_wf_graph_q5.sh > $RESULTS_DIR/wf_recon_complete_graph_all_observables.gv
dot -Tpdf $RESULTS_DIR/wf_recon_complete_graph_all_observables.gv > $RESULTS_DIR/wf_recon_complete_graph_all_observables.pdf
dot -Tsvg $RESULTS_DIR/wf_recon_complete_graph_all_observables.gv > $RESULTS_DIR/wf_recon_complete_graph_all_observables.svg
# @END RunQ5HybridProvenanceFileLevelGraphQueries


# @BEGIN RunQ6RetrospectiveProvenanceUpstreamSubgraphQueries @desc Draw recon worfklow graph upstream of a productName
# @IN productName
# @IN render_wf_recon_graph_upstream_of_data_q6.sh @URI file:queries/render_wf_recon_graph_upstream_of_data_q6.sh
# @IN yw_views.P @URI file: packages/kurator_FileBranchingTaxonLookup/workflows/views/yw_views.P
# @IN reconfacts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/reconfacts.P
# @OUT wf_recon_upstream_of_{productName}.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/wf_recon_upstream_of_{productName}.gv
##############
#   Q6_pro   #
##############

# draw recon worfklow graph upstream of UpdatedOccurrenceFile
productName="UpdatedOccurrenceFile"
$QUERIES_DIR/render_wf_recon_graph_upstream_of_data_q6.sh \'$productName\' > $RESULTS_DIR/wf_recon_upstream_of_$productName.gv
dot -Tpdf $RESULTS_DIR/wf_recon_upstream_of_$productName.gv > $RESULTS_DIR/wf_recon_upstream_of_$productName.pdf
dot -Tsvg $RESULTS_DIR/wf_recon_upstream_of_$productName.gv > $RESULTS_DIR/wf_recon_upstream_of_$productName.svg

# draw recon worfklow graph upstream of LogFile
productName="LogFile"
$QUERIES_DIR/render_wf_recon_graph_upstream_of_data_q6.sh \'$productName\' > $RESULTS_DIR/wf_recon_upstream_of_$productName.gv
dot -Tpdf $RESULTS_DIR/wf_recon_upstream_of_$productName.gv > $RESULTS_DIR/wf_recon_upstream_of_$productName.pdf
dot -Tsvg $RESULTS_DIR/wf_recon_upstream_of_$productName.gv > $RESULTS_DIR/wf_recon_upstream_of_$productName.svg
# @END RunQ6RetrospectiveProvenanceUpstreamSubgraphQueries

# @BEGIN RunQ7HybridProvenanceRecordLevelGraphQueries @desc Given an occurrenceID, draw hybrid complete provenance graph with record-level runtime observables
# @IN occurrenceID
# @IN render_recon_complete_wf_graph_record_level_q7.sh @URI file:queries/render_recon_complete_wf_graph_record_level_q7.sh
# @IN yw_views.P @URI file: packages/kurator_FileBranchingTaxonLookup/workflows/views/yw_views.P
# @IN reconfacts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/reconfacts.P
# @IN LogFile @URI file:runlog.log
# @IN yw_model_facts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/yw_model_facts.P
# @OUT wf_recon_complete_graph_of_{occurrenceID}.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/wf_recon_complete_graph_of_{occurrenceID}.gv
##############
#   Q7_pro   #
##############

# given an occurrenceID, draw hybrid complete provenance graph with record-level runtime observables
# isMarine occurrenceID="MCZ:Mala:303063"
occurrenceID=MCZ:Mala:303063
$QUERIES_DIR/render_recon_complete_wf_graph_record_level_q7.sh \'$occurrenceID\' > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv
dot -Tpdf $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.pdf
dot -Tsvg $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.svg

# noMarine occurrenceID="MCZ:Mala:278687"
occurrenceID=MCZ:Mala:278687
$QUERIES_DIR/render_recon_complete_wf_graph_record_level_q7.sh \'$occurrenceID\' > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv
dot -Tpdf $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.pdf
dot -Tsvg $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.svg
 
occurrenceID=MCZ:Mala:120797
$QUERIES_DIR/render_recon_complete_wf_graph_record_level_q7.sh \'$occurrenceID\' > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv
dot -Tpdf $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.pdf
dot -Tsvg $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.svg
# @END RunQ7HybridProvenanceRecordLevelGraphQueries

# @BEGIN RunQ8RunOtherLogQueries @desc LQ1: Given an occurrenceID=MCZ:Orn:149849, confirm if the record is Marine or not?\nLQ2: How many records are Marine (noMarine)?\nLQ3: Which records are Marine?\nLQ4: Given an occurrenceID, is a match found (GUID:not null=Match; GUID:null=Unable to validate)?\n What data sources (validation services) were used (GBIFLookup or WoRMSLookup)?\nLQ5: How many Marine(noMarine) records found a match?\nLQ6: Which records found a match?\nLQ7: How many records could not find a match?
# @IN run_log_queries.sh @URI file:queries/run_log_queries.sh
# @IN reconfacts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/reconfacts.P
# @IN LogFile @URI file:runlog.log
# @IN log_queries.P @URI file:queries/log_queries.P
# @IN yw_model_facts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/yw_model_facts.P
# @IN yw_extract_facts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/yw_extract_facts.P
# @OUT run_log_queries_output.txt @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/run_log_queries_output.txt
##############
#   Q8_pro   #
##############

# run other log queries
$QUERIES_DIR/run_log_queries.sh &> $RESULTS_DIR/run_log_queries_output.txt
# LQ1: Given an occurrenceID "MCZ:Orn:149849", confirm if the record is Marine or not?
# LQ2: How many records are Marine (noMarine)?
# LQ3: Which records are Marine?
# LQ4: Given an occurrenceID, is a match found (GUID:not null --> Match; GUID:null --> Unable to validate)? What data sources (validation services) were used (GBIFLookup or WoRMSLookup)? 
# LQ5: How many Marine(noMarine) records found a match?
# LQ6: Which records found a match?
# LQ7: How many records could not find a match?
# @END RunQ8RunOtherLogQueries

# @BEGIN RunQ9HybridProvenanceAggregateLevelGraphQueries @desc Draw hybrid complete provenance graph with aggregate statistics
# @IN render_recon_complete_wf_aggregate_level_q9.sh @URI file:queries/render_recon_complete_wf_aggregate_level_q9.sh
# @IN yw_views.P @URI file: packages/kurator_FileBranchingTaxonLookup/workflows/views/yw_views.P
# @IN reconfacts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/reconfacts.P
# @IN LogFile @URI file:runlog.log
# @IN yw_model_facts.P @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/facts/yw_model_facts.P
# @OUT wf_recon_complete_graph_of_aggregate_level.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/wf_recon_complete_graph_of_aggregate_level.gv
##############
#   Q9_pro   #
##############
# draw hybrid complete provenance graph with aggregate statistics
$QUERIES_DIR/render_recon_complete_wf_aggregate_level_q9.sh > $RESULTS_DIR/wf_recon_complete_graph_of_aggregate_level.gv
dot -Tpdf $RESULTS_DIR/wf_recon_complete_graph_of_aggregate_level.gv > $RESULTS_DIR/wf_recon_complete_graph_of_aggregate_level.pdf
dot -Tsvg $RESULTS_DIR/wf_recon_complete_graph_of_aggregate_level.gv > $RESULTS_DIR/wf_recon_complete_graph_of_aggregate_level.svg
# @END RunQ9HybridProvenanceAggregateLevelGraphQueries

# @OUT complete_wf_graph_uri.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/complete_wf_graph_uri_make.gv
# @OUT workflow_outputs.txt @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/workflow_outputs.txt
# @OUT ScriptOutput @URI file:{workspace}/mergedoutputfile.csv    
# @OUT LogFile @URI file:runlog.log
# @OUT wf_upstream_of_{productName}.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/wf_upstream_of_{productName}.gv
# @OUT inputs_upstream_of_{productName}.txt @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/inputs_upstream_of_{productName}.txt
# @OUT wf_downstream_of_{productName}.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/wf_downstream_of_{productName}.gv
# @OUT outputs_downstream_of_{productName}.txt @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/outputs_downstream_of_{productName}.txt
# @OUT wf_recon_upstream_of_{productName}.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/wf_recon_upstream_of_{productName}.gv
# @OUT wf_recon_complete_graph_all_observables.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/wf_recon_complete_graph_all_observables.gv
# @OUT wf_recon_complete_graph_of_{occurrenceID}.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/wf_recon_complete_graph_of_{occurrenceID}.gv
# @OUT run_log_queries_output.txt @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/run_log_queries_output.txt
# @OUT wf_recon_complete_graph_of_aggregate_level.gv @URI file:packages/kurator_FileBranchingTaxonLookup/workflows/results/wf_recon_complete_graph_of_aggregate_level.gv
# @END Make

