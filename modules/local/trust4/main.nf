process TRUST4 {
    conda "${moduleDir}/environment.yml"
    container 'biocontainers/trust4:1.1.6.1--h5ca1c30_0'

    tag "${sample_id}"
    publishDir "${params.trust4_outdir ?: 'results/trust4'}", mode: 'copy'

    input:
    val sample_id
    val mode
    path bam
    path fq1
    path fq2
    path fasta_vdj
    path ref

    output:
    path "${sample_id}_trust4_out/*", emit: trust4_out

    script:
    def user_params = params.trust4_opts ?: ''
    def outdir = "${sample_id}_trust4_out"
    def outprefix = "${outdir}/${sample_id}"
    def run_cmd
    if (mode == 'bam') {
        run_cmd = "run-trust4 -f ${fasta_vdj} --ref ${ref} -b ${bam} -o ${outprefix} $user_params"
    } else {
        run_cmd = "run-trust4 -f ${fasta_vdj} --ref ${ref} -1 ${fq1} -2 ${fq2} -o ${outprefix} $user_params"
    }
    """
    mkdir -p ${outdir}
    ${run_cmd}
    """
}