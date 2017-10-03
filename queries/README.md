##Simple Generic Queries
- render_complete_wf_graph.sh
  - *Create a Graphviz-generated layout of the complete workflow with URI template.*
- list_workflow_outputs.sh
  - *What outputs does the workflow (script) have?*
- materialize_yw_views.sh
  - *Auxiliary script to materialize YW views for subsequent queries.*


##Advanced Generic Queries
- render_wf_graph_upstream_of_data_q1.sh 
  - *Show the workflow that is upstream of a given data item.*
- list_dependent_inputs_q2.sh 
  - *Given a data item, determine on which inputs it depends.*
- render_wf_graph_downstream_of_data_q3.sh 
  - *Given a data item to what other downstream items does it contribute? (Note: Don't "read" this graph upstream! Use the upstream query for it. Exercise: Explain what the problem is with an "upstream reading" of a downstream query ..)*
- list_dependent_outputs_q4.sh 
  - *Given a data item, which outputs does it contribute to?*
- render_wf_recon_graph_upstream_of_data_q5.sh 
  - *Hybrid "Make-this-product" query: show reconstructed upstream provenance in context of the workflow.*
- render_wf_recon_graph_complete_graph_all_observables_q6.sh 
  - *Hybrid "Make-all-product" query: show reconstructed provenance with all observables in context of the workflow.*
- render_recon_complete_wf_graph_record_level_q7.sh 
  - *Hybrid "Make-all-record" query: Given an occurrenceID, show reconstructed hybrid complete provenance provenance with record-level runtime observables in context of the workflow.*
- run_log_queries.sh 
  - *Run other log queries.*
- render_recon_complete_wf_aggregate_level_q9.sh
  - *Hybrid "Aggregate-statistics" query: show hybrid complete provenance graph for aggregate statistics.*
