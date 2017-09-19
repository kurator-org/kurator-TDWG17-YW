# sequence of commands to run for demonstration at SPNHC, along with some notes on points.

# workflow with yes workflow markup (branches, java + python, file and data record passing, abstraction in yesworkflow)
vim  vim packages/kurator_branching/workflows/file_branching_taxon_lookup.yaml

source settings.sh

# use yesworkflow to generate a prospective provenance diagram
$YW_CMD graph $WORKFLOWS_DIR/file_branching_taxon_lookup.yaml \
         -c extract.comment="#" \
         -c graph.view=combined \
         -c graph.layout=tb \
          > $RESULTS_DIR/complete_wf_graph_uri.gv
dot -Tpdf $RESULTS_DIR/complete_wf_graph_uri.gv > $RESULTS_DIR/complete_wf_graph_uri.pdf
dot -Tsvg $RESULTS_DIR/complete_wf_graph_uri.gv > $RESULTS_DIR/complete_wf_graph_uri.svg

evince $RESULTS_DIR/complete_wf_graph_uri.pdf &

# run the workflow to get a log file (in background while going through the diagram)
java -jar target/kurator-validation-1.0.1-SNAPSHOT-jar-with-dependencies.jar -f packages/kurator_branching/workflows/file_branching_taxon_lookup.yaml -p inputfile=packages/kurator_branching/data/kurator_sample_data.txt -l=All &

# generate retrospective provenance (graphs plus queries)
sh make.sh
# (page up through query results)


# retrospective provenance (file level view)
evince packages/kurator_branching/workflows/results/wf_recon_complete_graph_all_observables.pdf 

# retrospective provanance (record level view)
evince packages/kurator_branching/workflows/results/wf_recon_complete_graph_of_MCZ\:Mala\:303063.pdf

# Using prolog variant language XSB to run queries on retrospective provenance facts extracted from log by yesworkflow, and to make graphs

$XSB 

['./rules/log_query_rules'].
['./queries/log_queries'].
['./packages/kurator_branching/workflows/facts/yw_extract_facts'].
['./packages/kurator_branching/workflows/facts/yw_model_facts'].
['./packages/kurator_branching/workflows/facts/reconfacts'].
lq2(MarineCount).
lq4('MCZ:Mala:123853',MatchFound,Source_Used).

# lets us ask and graph answers to questions that aren't present in the output data (but were captured in the logs - this name wasn't found, where was it looked up?)
evince packages/kurator_branching/workflows/results/wf_recon_complete_graph_nomatch_of_MCZ\:Mala\:123853.pdf
