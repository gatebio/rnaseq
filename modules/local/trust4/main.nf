process TRUST4 {
    conda "${moduleDir}/environment.yml"
    container 'biocontainers/trust4:1.1.6.1--h5ca1c30_0'

    tag "${sample_id}"
    publishDir "${params.trust4_outdir ?: 'results/trust4'}", mode: 'copy'

    input:
    val sample_id
    path bam_or_null, optional: true
    path fq1_or_null, optional: true
    path fq2_or_null, optional: true
    path fasta_vdj
    path ref

    output:
    path "${sample_id}_trust4_out", emit: trust4_out

    script:
    def user_params = params.trust4_opts ?: ''
    def run_cmd
    if (bam_or_null && bam_or_null.toString() != 'null') {
        run_cmd = "TRUST4 --ref ${ref} -f ${fasta_vdj} -b ${bam_or_null} -o ${sample_id}_trust4_out $user_params"
    } else {
        run_cmd = "TRUST4 --ref ${ref} -f ${fasta_vdj} -1 ${fq1_or_null} -2 ${fq2_or_null} -o ${sample_id}_trust4_out $user_params"
    }
    """
    mkdir -p ${sample_id}_trust4_out
    ${run_cmd}
    """
}       