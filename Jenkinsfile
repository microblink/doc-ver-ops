@Library( 'JenkinsPipelineScripts@v20.8.1' ) _

node ( "docker" ) {
    commonCDUtils.helmCDRelease('helm/doc-ver', 'master')
}
