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

## Logging methods

Below are all methods exposed by the `ForceLog.Logger` class.

### void debug(String message [, List<String> formattingArguments])

Writes a `debug` log containing the provided message. If `formattingArguments` is provided then the first argument is treated as a pattern and the second argument for substitution and formatting in the same manner as `apex:outputText` and the Java `MessageFormat` class.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.debug('debugging information');
 log.debug('debugging {0}', new List<String> { 'information' });
```

### void info(String message [, List<String> formattingArguments])

Writes an `info` log containing the provided message. If `formattingArguments` is provided then the first argument is treated as a pattern and the second argument for substitution and formatting in the same manner as `apex:outputText` and the Java `MessageFormat` class.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.info('information');
 log.info('info{0}', new List<String> { 'rmation' });
```

### void warning(String message [, List<String> formattingArguments])

Writes a `warning` log containing the provided message. If `formattingArguments` is provided then the first argument is treated as a pattern and the second argument for substitution and formatting in the same manner as `apex:outputText` and the Java `MessageFormat` class.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.warning('warning information');
 log.warning('warning {0}', new List<String> { 'information' });
```

### void error(String message [, List<String> formattingArguments])

Writes an `err` log containing the provided message. If `formattingArguments` is provided then the first argument is treated as a pattern and the second argument for substitution and formatting in the same manner as `apex:outputText` and the Java `MessageFormat` class.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.error('error information');
 log.error('error {0}', new List<String> { 'information' });
```

### void critical(String message [, List<String> formattingArguments])

Writes a `crit` log containing the provided message. If `formattingArguments` is provided then the first argument is treated as a pattern and the second argument for substitution and formatting in the same manner as `apex:outputText` and the Java `MessageFormat` class.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.critical('critical information');
 log.critical('critical {0}', new List<String> { 'information' });
```

### void emergency(String message [, List<String> formattingArguments])

Writes an `emerg` log containing the provided message. If `formattingArguments` is provided then the first argument is treated as a pattern and the second argument for substitution and formatting in the same manner as `apex:outputText` and the Java `MessageFormat` class.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.emergency('emergency information');
 log.emergency('emergency {0}', new List<String> { 'information' });
```

### void notice(String message [, List<String> formattingArguments])

Writes a `notice` log containing the provided message. If `formattingArguments` is provided then the first argument is treated as a pattern and the second argument for substitution and formatting in the same manner as `apex:outputText` and the Java `MessageFormat` class.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.notice('notice information');
 log.notice('notice {0}', new List<String> { 'information' });
```

### void alert(String message [, List<String> formattingArguments])

Writes a `alert` log containing the provided message. If `formattingArguments` is provided then the first argument is treated as a pattern and the second argument for substitution and formatting in the same manner as `apex:outputText` and the Java `MessageFormat` class.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.alert('alert information');
```

### ForceLog.Logger withField(String key, Object value)

Adds a field to the log with the specified value. Will throw a `ReservedFieldException` when using a reserved field name. Reserved names are:

* `name`
* `level`
* `timestamp`
* `exception_message`
* `exception_type`
* `exception_stack_trace`
* `exception_line_number`
* `exception_cause`
* `request`
* `response`

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.withField('id', '12345').info('got identifier');
```

### ForceLog.Logger withFields(Map<String, Object> fields)

Adds multiple fields to the log. Will throw a `ReservedFieldException` when using a reserved field name. See documentation for `withField()` for reserved field names.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.withFields(new Map<String, Object> {
     'id' => '12345',
     'contact' => 'John Smith'
 }).info('got contact');
```

### ForceLog.Logger withSObject(String key, SObject obj)

Adds SObject data to the log under a specified key.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 Contact c = new Contact(
    FirstName = 'tester',
    LastName = 'mctest',
    Email = 'test@test.com'
 );

 insert c;

 logger.withSObject('sobject', c).info('inserted contact');
```

### ForceLog.Logger withSObject(String key, SObject obj, Set<String> excludeFields)

Adds SObject data to the log under a specified key and excludes all fields contained within the 'excludeFields' parameter.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 Contact c = new Contact(
    FirstName = 'tester',
    LastName = 'mctest',
    Email = 'test@test.com'
 );

 insert c;

 logger.withSObject('sobject', c, new Set<String> { 'Email' }).info('inserted contact');
```

### ForceLog.Logger withSObjects(String key, List<SObject> sobjects)

Adds multiple SObjects to the log under a provided key.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 List<SObject> objs = new List<SObject> {
     new Contact(
         FirstName = 'tester',
         LastName = 'mctest',
         Email = 'unit@test.com'
     ),
     new Contact(
         FirstName = 'testly',
         LastName = 'mctest',
         Email = 'unit@test.com'
     )
 };

 insert objs;

 logger.withSObjects('sobjects', objs).info('inserted contact and account');
```

### ForceLog.Logger withSObjects(String key, List<SObject> sobjects, Set<String> excludeFields)

Adds multiple SObjects to the log, under a given key. Removes fields from SObjects whose
API names match any in the 'excludeFields' parameter. You would want to use this method to
avoid placing sensitive information in your logs.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 List<SObject> objs = new List<SObject> {
     new Contact(
         FirstName = 'tester',
         LastName = 'mctest',
         Email = 'unit@test.com'
     ),
     new Contact(
         FirstName = 'testly',
         LastName = 'mctest',
         Email = 'unit@test.com'
     )
 };

 insert objs;

 logger.withSObjects('sobjects', objs, new Set<String> {
     'FirstName', 'LastName'
 }).info('inserted contact and account');
```

### ForceLog.Logger withResult([Database.SaveResult, Database.UpsertResult, Database.DeleteResult] res)

Adds a single intance of `Database.SaveResult`, `Database.UpsertResult` or `Database.DeleteResult` to the log. It
outputs all relevant fields for each type and includes all errors.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 Contact c = new Contact(
    FirstName = 'testly',
    LastName = 'mctest',
    Email = 'unit@test.com'
 );

 Database.SaveResult r = Database.insert(c);

 logger.withResult(r).info('inserted contact');
```

### ForceLog.Logger withResult(String key, [Database.SaveResult, Database.UpsertResult, Database.DeleteResult] res)

Adds a single intance of `Database.SaveResult`, `Database.UpsertResult` or `Database.DeleteResult` to the log. It
outputs all relevant fields for each type and includes all errors. The result information is nessted under the
provided key

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 Contact c = new Contact(
    FirstName = 'testly',
    LastName = 'mctest',
    Email = 'unit@test.com'
 );

 Database.SaveResult r = Database.insert(c);

 logger.withResult('save_result', r).info('inserted contact');
```

### ForceLog.Logger withResults(List<[Database.SaveResult, Database.UpsertResult, Database.DeleteResult]> results)

Adds a list of `Database.SaveResult`, `Database.UpsertResult` or `Database.DeleteResult` to the log. It
outputs all relevant fields for each type and includes all errors.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 List<SObject> objs = new List<SObject> {
     new Contact(
         FirstName = 'tester',
         LastName = 'mctest',
         Email = 'unit@test.com'
     ),
     new Contact(
         FirstName = 'testly',
         LastName = 'mctest',
         Email = 'unit@test.com'
     )
 };

 List<Database.SaveResult> rs = Database.insert(objs);

 logger.withResults(rs).info('inserted contact');
```


### ForceLog.Logger withResults(String key, List<[Database.SaveResult, Database.UpsertResult, Database.DeleteResult]> results)

Adds a list of `Database.SaveResult`, `Database.UpsertResult` or `Database.DeleteResult` to the log. It
outputs all relevant fields for each type and includes all errors. The results are nested under the
provided key.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 List<SObject> objs = new List<SObject> {
     new Contact(
         FirstName = 'tester',
         LastName = 'mctest',
         Email = 'unit@test.com'
     ),
     new Contact(
         FirstName = 'testly',
         LastName = 'mctest',
         Email = 'unit@test.com'
     )
 };

 List<Database.SaveResult> rs = Database.insert(objs);

 logger.withResults('save_results', rs).info('inserted contact');
```

### ForceLog.Logger withException(Exception ex)

Adds exception data to the log. Will add the message, type, stack trace and line number to the logging output. If the exception has a cause these will be recursively added under the `exception_cause` field.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 try {
     // ...
 } catch(Exception ex) {
    log.withException(ex).error('uh oh!');
 }
```

### ForceLog.Logger withRequest([String name,] HttpRequest req [, Set<String> includeHeaders])

Adds HTTP request data to the log. If no name is supplied it will add it in the `request` field. Headers can be included by specifying the headers to include using the `includeHeaders` argument.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');
 HttpRequest req = new HttpRequest();

 log.withRequest(req).info('got request');
 log.withRequest('my_request', req).info('got request');
 log.withRequest(req, new Set<String> { 'Content-Type' }).info('got request');
 log.withRequest('my_request', req, new Set<String> { 'Content-Type' }).info('got request');
```

### ForceLog.Logger withRequest([String name,] ResRequest req)

Adds inbound HTTP request data from `RestContext` to the log. If no name is supplied it will add it in the `request` field.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');
 RestRequest req = new RestRequest();

 log.withRequest(req).info('got request');
 log.withRequest('my_request', req).info('got request');
```

### ForceLog.Logger withResponse([String name,] HttpResponse res [, Set<String> excludeHeaders])

Adds HTTP response data to the log. If no name is supplied it will add it in the `response` field. Headers can be excluded by specifying the headers to exclude using the `excludeHeaders` argument, e.g. if they contain credentials.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');
 HttpResponse res = new HttpResponse(); // or from Http.send()

 log.withResponse(res).info('got response');
 log.withResponse('my_response', res).info('got response');
 log.withResponse(res, new Set<String> { 'X-Token' }).info('got response');
 log.withResponse('my_response', res, new Set<String> { 'X-Token }).info('got response');
```

### void dispose()

Triggers the implementation of the `bulkFlush()` method when using `ForceLog.BulkLogger`.

```apex
 ForceLog.Logger log = new ForceLog.BulkLogger('myClassName');

 log.info('trying something');

 try {
     // ...
 } catch(Exception ex) {
    log.withException(ex).error('uh oh!');
 }

 log.dispose();
```

## Extending the logger

Everyone has their own way of handling logs in Salesforce. If you need logs handled in a custom way, you can override the `flush()` method in `ForceLog.Logger` or the `bulkFlush()` method in `ForceLog.BulkLogger`. Let's say each log needs to be sent to an HTTP endpoint. You can implement a new logger that extends `ForceLog.BulkLogger` and will create an HTTP request containing all logs. By default, the logger will JSON-encode logs and write them to the debugger using `System.debug()`.

```apex
public class CalloutLogger extends ForceLog.BulkLogger {
    /**
     * @description The HTTP endpoint to send requests to
     * @type {String}
     */
    private String endpoint;

    /**
     * @description The HTTP client to use for making requests
     * @type {Http}
     */
    private Http client;

    /**
     * @description Initializes a new instance of the CalloutLogger class
     * @param {String} name The log name, should be a class or method name.
     * @param {String} endpoint The endpoint to send HTTP requests to.
     * @constructor
     */
    public CalloutLogger(String name, String endpoint) {
        // Initialize the parent class using the name.
        super(name);

        this.endpoint = endpoint;
        this.client = new Http();
    }

    /**
     * @description Creates an HTTP POST request containing
     * the JSON-encoded logs as the body.
     * @param {List<Map<String, Object>>} logs The log data
     * @return {void}
     */
    protected override void bulkFlush(List<Map<String, Object>> logs) {
        HttpRequest req = new HttpRequest();

        req.setEndpoint(this.endpoint);
        req.setMethod('POST');
        req.setBody(JSON.serialize(logs));

        this.client.send(req);
    }
}
```
