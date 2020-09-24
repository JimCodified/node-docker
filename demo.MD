# Snyk Scanning Demonstrations
The following steps will give you a few quick examples of vulnerability scanning using Docker Desktop with Snyk

_NOTE:_ If you're just testing with various CLI options to find what you like, it's probably easiest to just scan once & dump the output to a file instead of running the scan every...single...time (esp for bigger images). Some of the steps below assume this has been done (`cat` command is the start)

## Basic vuln scan
```sh
docker scan imagename:tag
```

## Detailed vuln scan including base image recommendations and Dockerfile command mapping
```sh
docker scan imagename:tag -f Dockerfile
```

## Detailed scan, but ignore base image vulnerabilities
```sh
docker scan imagename:tag -f Dockerfile --exclude-base
```

## generate a dependency tree along with the scan results
```sh
docker scan imagename:tag -f Dockerfile --dependency-tree
```

# Using JSON output and filtering
The following examples use the `--json` output option and the `jq` utility. If you don't have `jq` the  install instructions are [available here](https://stedolan.github.io/jq/download/).

_NOTE:_ The commands below assume you've already run a scan and dumped the results to an output file. This is purely for speed. You can just as easily swap out the first part of each command (`cat <file>`) for a `docker scan` command.

## Filter to only show Sev "High":
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
