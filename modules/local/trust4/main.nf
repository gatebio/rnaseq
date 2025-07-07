process TRUST4 {
    tag "${sample_id}"
    publishDir "${params.trust4_outdir ?: 'results/trust4'}", mode: 'copy'

    input:
    tuple val(sample_id), path(bam_or_null), path(fq1_or_null), path(fq2_or_null)

    output:
    path "${sample_id}_trust4_out", emit: trust4_out

    conda "environment.yml"
    container params.trust4_container ?: null

    script:
    def user_params = params.trust4_opts ?: ''
    def run_cmd
    if (bam_or_null && bam_or_null.toString() != 'null') {
        run_cmd = "TRUST4 -b ${bam_or_null} -o ${sample_id}_trust4_out $user_params"
    } else {
        run_cmd = "TRUST4 -f1 ${fq1_or_null} -f2 ${fq2_or_null} -o ${sample_id}_trust4_out $user_params"
    }
    """
    mkdir -p ${sample_id}_trust4_out
    ${run_cmd}
    """
} 