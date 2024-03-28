{{/*
Returns Yaml Replacement Spec for updating the image tag
*/}}
{{- define "helmChart.renderYamlReplacementSpec" -}}
{{- $data := .}}
{{- $replacementSpec := default dict -}}
{{- $yamlFilePath := print (get $data "chartPath") "/values.yaml" -}}
{{- $commitId := print (get $data "commitId") -}}
{{- $replacements := default list -}}
{{- $_ := set $replacementSpec "yamlFilePath"  $yamlFilePath -}}
{{- $_ := set $replacementSpec "replacements"  $replacements -}}
{{- $deploymentPaths := (get $data "deploymentPaths") -}}
{{- range $deploymentPath := $deploymentPaths -}}
{{- range $container := $deploymentPath.containers -}}
{{- $replacement := default dict -}}
{{- $_ := set $replacement "newValue" $commitId -}}
{{- if $deploymentPath.name }}
{{- $yamlPath := print $deploymentPath.name  ".deployment.containers." $container.name ".image.tag" -}}
{{- $_ := set $replacement "yamlPath" $yamlPath -}}
{{- else -}}
{{- $yamlPath := print "deployment.containers." $container.name ".image.tag" -}}
{{- $_ := set $replacement "yamlPath" $yamlPath -}}
{{- end -}}
{{- $newList := append ( get $replacementSpec "replacements" ) $replacement }}
{{- $_ :=set  $replacementSpec "replacements" $newList }}
{{- end -}}
{{- end -}}
{{ list $replacementSpec | toJson}}
{{- end -}}