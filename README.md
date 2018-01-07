# NAME asi_bod

*   Manipulate and view the ASIObjectDictionary.xml and BOD.json files


## SYNOPSIS
    asi_bod [global options] command [command options] [arguments...]

## Overview

Tool to view, search and potentially merge the Grin Tech Phaserunner
`BOD.json` file and the ASI `ASIObjectDictionary.xml` file.

The `BOD.json` file is the original Grin Tech file that ships with the
+PhaseRunner v0.9.9.1+ software as of Jan 1 2018.

This gem ships with `BODm.json` which is the same as the Grin Tech `BOD.json`
except the Descriptions from the ASI `ASIObjectDictionary.xml` file that
shipped with the `BacDoorSetup_1_5_4` software.

If you want to start with the original or another version of the `BOD.json` or
the `ASIObjectDictionary.xml` then you can override the defaults with the +-a,
--asi_file+ or +-b, --bod_file+ flags

## COMMANDS
    find  - Find a node in one or both of the dictionaries
    help  - Shows a list of commands or help for one command
    merge - Merge the Description from asi to bod
    view  - View the data

## Detailed Command Line Info


## asi_bod - Manipulate and view the ASIObjectDictionary.xml and BOD.json files

v0.1.0

### Global Options
### -a|--asi_file arg

Path to the ASIObjectDictionary XML file

Default Value
:   ASIObjectDictionary.xml


### -b|--bod_file arg

Path to the BOD JSON file

Default Value
:   BOD.json


### --[no-]address_view
View Address


### --[no-]description_view
View Description


### --help
Show this message


### --[no-]name_view
View Name


### -[s|--](no-)scale_view
View Scale


### -[u|--](no-)units
View Units


### --version
Display the program version


### Commands
#### Command: `find `
Find a node in one or both of the dictionaries

##### Options
##### -[a|--](no-)asi
Search the asi dictionary


##### -[b|--](no-)bod
Search the bod dictionary


##### Commands
###### Command: `by_address `
Find by register address

Find by register address. Must select at least one of asi or bod and specify
search_term
###### Command: `by_key_substring `
Find by the substring of a key

Find by the substring of a Must select at least one of asi or bod and specify
search_term
#### Command: `help  command`
Shows a list of commands or help for one command

Gets help for the application or its commands. Can also list the commands in a
way helpful to creating a bash-style completion function
##### Options
##### -c
List commands one per line, to assist with shell completion


#### Command: `merge `
Merge the Description from asi to bod

Merge the Description from asi to bod Do not merge if Description has
"Reserved" in it Or if the Bod doesnt have the key
##### Options
##### -[j|--](no-)json
Output Json


#### Command: `view `
View the data

##### Options
##### -[j|--](no-)json
Output as Json instead of CSV


##### Commands
###### Command: `asi `
Pretty Print output of the simplified ASI ObjectDictionary as a hash

###### Command: `bod `
Pretty Print output of the simplified BOD as a hash

Default Command
:   bod

