#!/usr/bin/env nextflow

/* ==============================================================================
INDUCE-seq Analysis
Processes BED files from INDUCE-seq experiments to output summarised DNA double strand breaks at AsiSI restriction sites on chromosome 21.
=================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Argument handling
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

if (params.breaks) { breaks = Channel.fromPath( "${params.breaks}/*.bed" ) } else { exit 1, '<breaks> samplesheet not specified!' }
if (params.asisi_sites) { asisi = Channel.value( file(params.asisi_sites))} else { exit 1, '<asisi_sites> samplesheet not specified!' }

nextflow.enable.dsl=2

include { FILTER_BED } from './modules/filter_bed'
include { INTERSECT_BED } from './modules/intersect_bed'
include { SUMMARISE } from './modules/summarise'
include { COLLECT_RESULTS } from './modules/collect_results'

workflow {

    filtered = FILTER_BED(breaks)

    intersected = INTERSECT_BED( filtered, asisi )

    summaries = SUMMARISE( filtered, intersected )

    COLLECT_RESULTS(summaries)
}