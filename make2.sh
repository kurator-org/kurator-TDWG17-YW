#!/bin/bash

# set variables
sh settings.sh

# create output directories
mkdir -p $FACTS_DIR
mkdir -p $VIEWS_DIR
mkdir -p $RESULTS_DIR

# export YW model and extract facts
echo "yw graph"
$YW_CMD graph
# $YW_CMD model $WORKFLOWS_DIR/file_branching_taxon_lookup.yaml \
#         -c extract.language=bash \
# 		  -c extract.listfile=listing.txt \
#         -c extract.factsfile=$FACTS_DIR/yw_extract_facts.P \
#         -c model.factsfile=$FACTS_DIR/yw_model_facts.P \
#         -c query.engine=xsb

# run the workflow
#java -jar target/kurator-validation-1.0.1-SNAPSHOT-jar-with-dependencies.jar -f packages/kurator_branching/workflows/file_branching_taxon_lookup.yaml -p inputfile=packages/kurator_branching/data/kurator_sample_data.txt -l ALL > runlog.log 2>&1

# draw complete workflow graph with URI template
$YW_CMD graph $WORKFLOWS_DIR/file_branching_taxon_lookup_qz_v2.yaml \
         -c extract.comment="#" \
         -c graph.view=combined \
         -c graph.layout=tb \
          > $RESULTS_DIR/complete_wf_graph_uri.gv
dot -Tpdf $RESULTS_DIR/complete_wf_graph_uri.gv > $RESULTS_DIR/complete_wf_graph_uri.pdf
dot -Tsvg $RESULTS_DIR/complete_wf_graph_uri.gv > $RESULTS_DIR/complete_wf_graph_uri.svg
echo "yw graph complete_wf_graph_uri"

# draw complete workflow graph
# $QUERIES_DIR/render_complete_wf_graph.sh > $RESULTS_DIR/complete_wf_graph.gv
# dot -Tpdf $RESULTS_DIR/complete_wf_graph.gv > $RESULTS_DIR/complete_wf_graph.pdf
# dot -Tsvg $RESULTS_DIR/complete_wf_graph.gv > $RESULTS_DIR/complete_wf_graph.svg

# materialize views of YW facts
echo "materialize views" 
$QUERIES_DIR/materialize_yw_views.sh > $VIEWS_DIR/yw_views.P

# list workflow outputs
echo "list workflow outputs" 
$QUERIES_DIR/list_workflow_outputs.sh > $RESULTS_DIR/workflow_outputs.txt

# generate reconfacts.P to facts/ folder 
echo "yw recon"
$YW_CMD recon


##############
#   Q1_pro   #
##############

echo "q1"

# draw worfklow graph upstream of OutputFile
productName="OutputFile"
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'$productName\' > $RESULTS_DIR/wf_upstream_of_$productName.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.pdf
dot -Tsvg $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.svg

# draw worfklow graph upstream of GBIFOutput
productName="GBIFOutput"
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'$productName\' > $RESULTS_DIR/wf_upstream_of_$productName.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.pdf
dot -Tsvg $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.svg

# draw worfklow graph upstream of LogFile
productName="LogFile"
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'$productName\' > $RESULTS_DIR/wf_upstream_of_$productName.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.pdf
dot -Tsvg $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.svg

# draw worfklow graph upstream of <MarineDataRecord[scientificName:scientificNameAuthorship]>
productName="<MarineDataRecord[scientificName:scientificNameAuthorship]>"
$QUERIES_DIR/render_wf_graph_upstream_of_data_q1.sh \'$productName\' > $RESULTS_DIR/wf_upstream_of_$productName.gv
dot -Tpdf $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.pdf
dot -Tsvg $RESULTS_DIR/wf_upstream_of_$productName.gv > $RESULTS_DIR/wf_upstream_of_$productName.svg


##############
#   Q2_pro   #
##############

echo "q2"
# list workflow inputs upstream of output data OutputFile
$QUERIES_DIR/list_inputs_upstream_of_data_q2.sh \'OutputFile\' OutputFile > $RESULTS_DIR/inputs_upstream_of_OutputFile.txt

# list workflow inputs upstream of intermediate data MergedStream
$QUERIES_DIR/list_inputs_upstream_of_data_q2.sh \'MergedStream\' MergedStream > $RESULTS_DIR/inputs_upstream_of_MergedStream.txt

##############
#   Q3_pro   #
##############

echo "q3"
# draw workflow graph downstream of DataRecord
$QUERIES_DIR/render_wf_graph_downstream_of_data_q3.sh \'DataRecord\' > $RESULTS_DIR/wf_downstream_of_DataRecord.gv
dot -Tpdf $RESULTS_DIR/wf_downstream_of_DataRecord.gv > $RESULTS_DIR/wf_downstream_of_DataRecord.pdf
dot -Tsvg $RESULTS_DIR/wf_downstream_of_DataRecord.gv > $RESULTS_DIR/wf_downstream_of_DataRecord.svg

# draw workflow graph downstream of Workspace
$QUERIES_DIR/render_wf_graph_downstream_of_data_q3.sh \'Workspace\' > $RESULTS_DIR/wf_downstream_of_Workspace.gv
dot -Tpdf $RESULTS_DIR/wf_downstream_of_Workspace.gv > $RESULTS_DIR/wf_downstream_of_Workspace.pdf
dot -Tsvg $RESULTS_DIR/wf_downstream_of_Workspace.gv > $RESULTS_DIR/wf_downstream_of_Workspace.svg

##############
#   Q4_pro   #
##############

echo "q4"
# list workflow outputs downstream of DataRecord
$QUERIES_DIR/list_outputs_downstream_of_data_q4.sh \'DataRecord\' DataRecord > $RESULTS_DIR/outputs_downstream_of_DataRecord.txt

# list workflow outputs downstream of Workspace
$QUERIES_DIR/list_outputs_downstream_of_data_q4.sh \'Workspace\' Workspace > $RESULTS_DIR/outputs_downstream_of_Workspace.txt


##############
#   Q5_pro   #
##############

echo "q5"
# draw recon worfklow graph upstream of OutputFile
productName="OutputFile"
$QUERIES_DIR/render_wf_recon_graph_upstream_of_data_q5.sh \'$productName\' > $RESULTS_DIR/wf_recon_upstream_of_$productName.gv
dot -Tpdf $RESULTS_DIR/wf_recon_upstream_of_$productName.gv > $RESULTS_DIR/wf_recon_upstream_of_$productName.pdf
dot -Tsvg $RESULTS_DIR/wf_recon_upstream_of_$productName.gv > $RESULTS_DIR/wf_recon_upstream_of_$productName.svg

# draw recon worfklow graph upstream of LogFile
productName="LogFile"
$QUERIES_DIR/render_wf_recon_graph_upstream_of_data_q5.sh \'$productName\' > $RESULTS_DIR/wf_recon_upstream_of_$productName.gv
dot -Tpdf $RESULTS_DIR/wf_recon_upstream_of_$productName.gv > $RESULTS_DIR/wf_recon_upstream_of_$productName.pdf
dot -Tsvg $RESULTS_DIR/wf_recon_upstream_of_$productName.gv > $RESULTS_DIR/wf_recon_upstream_of_$productName.svg


##############
#   Q6_pro   #
##############

echo "q6 recon hybrid file level runtime observables" 

# draw recon workflow graph with all (file-level) runtime observables
$QUERIES_DIR/render_recon_complete_wf_graph_q6.sh > $RESULTS_DIR/wf_recon_complete_graph_all_observables.gv
dot -Tpdf $RESULTS_DIR/wf_recon_complete_graph_all_observables.gv > $RESULTS_DIR/wf_recon_complete_graph_all_observables.pdf
dot -Tsvg $RESULTS_DIR/wf_recon_complete_graph_all_observables.gv > $RESULTS_DIR/wf_recon_complete_graph_all_observables.svg

##############
#   Q7_pro   #
##############

# given an occurrenceID, draw hybrid complete provenance graph with record-level runtime observables
# isMarine occurrenceID="MCZ:Mala:303063"
# occurrenceID="MCZ:Mala:303063"
# $QUERIES_DIR/render_recon_complete_wf_graph_record_level_q7.sh \'$occurrenceID\' > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv
# dot -Tpdf $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.pdf
# dot -Tsvg $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.svg

# notMarine occurrenceID="MCZ:Mala:278687"
# $QUERIES_DIR/render_recon_complete_wf_graph_record_level_q7.sh \'$occurrenceID\' > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv
# dot -Tpdf $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.pdf
# dot -Tsvg $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.gv > $RESULTS_DIR/wf_recon_complete_graph_of_$occurrenceID.svg
 

##############
#   Q8_pro   #
##############

echo "run hybrid record level observables queries"  
# run other log queries
$QUERIES_DIR/run_log_queries.sh &> $RESULTS_DIR/run_log_queries_output.txt
# LQ1: Given an occurrenceID "MCZ:Orn:149849", confirm if the record is Marine or not?
# LQ2: How many records are Marine (noMarine)?
# LQ3: Which records are Marine?
# LQ4: Given an occurrenceID, is a match found (GUID:not null --> Match; GUID:null --> Unable to validate)? What data sources (validation services) were used (GBIFLookup or WoRMSLookup)? 
# LQ5: How many Marine(noMarine) records found a match?
# LQ6: Which records found a match?
# LQ7: How many records could not find a match?
