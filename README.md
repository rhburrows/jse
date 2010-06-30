# jse: Json Stream Editor

jse allows for filtering and transforming of json streams. It is
mainly designed for mining information out of json log files.

## Usage

Use the `jse` command

### Filtering based on field values

`jse field1:value field2:'another value' file.txt`

### Regexp filtering on fields

`jse field:/^pattern.+$/ file.txt`

### Printing selected fields

`jse message:/Error/ -f message log.txt`

## Installation

`gem install jse`
