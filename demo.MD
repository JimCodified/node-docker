## Sev "High":
```sh
cat snyk-out.json| jq '. | (.vulnerabilities[] | select(.severity=="high"))'
```

## Sev "High", but ignore base image vulns:
```sh
cat snyk-out-nobase.json | jq '. | (.vulnerabilities[] | select(.severity=="high"))'
```

## "High" + network attack vectort:
```sh
cat snyk-out-nobase.json  |   jq ' . | 
(.vulnerabilities[] | select(.severity=="high") | 
select(.CVSSv3 | contains("AV:N")))'
```

## "High" + fixable, group by Dockerfile line:
```sh
cat snyk-out.json | jq '[.vulnerabilities[] |
select(.severity == "high")                 | 
select(.nearestFixedInVersion) ]            | 
group_by(.packageName)[]                    | 
sort_by(.nearestFixedInVersion)             |
 .[0]                                       | 
 {packageName, dockerfileInstruction, version, nearestFixedInVersion}' 
```
