# ForceLog

ForceLog is a structured logger for Salesforce Apex that is extensible to suit various log formats and providers. It provides two loggers, `ForceLog.Logger` (for handling logs on an individual level) and `ForceLog.BulkLogger` (for handling logs in bulk).

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![CircleCI](https://circleci.com/gh/davidsbond/forcelog/tree/master.svg?style=shield)](https://circleci.com/gh/davidsbond/forcelog/tree/master)

## ForceLog.Logger Example

```apex
private ForceLog.Logger log = new ForceLog.Logger('myClassName');

public String getContactNameById(String id) {
    log.withField('id', id).info('querying contact');

    try {
        Contact c = [
            SELECT Name
            FROM Contact
            WHERE ID =: id
        ];

        log.withField('contactName', c.Name).info('queried contact');

        return c.Name;
    } catch(QueryException ex) {
        log.withException(ex).error('failed to query contact');
        return null;
    }
}
```

## ForceLog.BulkLogger Example

```apex
private ForceLog.Logger log = new ForceLog.BulkLogger('myClassName');

public String getContactNameById(String id) {
    log.withField('id', id).info('querying contact');

    String name;
    try {
        Contact c = [
            SELECT Name
            FROM Contact
            WHERE ID =: id
        ];

        log.withField('contactName', c.Name).info('queried contact');

        name = c.Name;
    } catch(QueryException ex) {
        log.withException(ex).error('failed to query contact');
    }

    log.dispose();
    return name;
}
```

Please see the [wiki](https://github.com/davidsbond/forcelog/wiki) for full implementation details and documentation