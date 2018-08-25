# ForceLog

ForceLog is a structured logger for Salesforce Apex that is extendable to suit various log formats and providers.

## Example

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

## Logging methods

### void debug(String message)

Writes a `debug` log containing the provided message.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.debug('debugging information');
```

### void info(String message)

Writes an `info` log containing the provided message.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.info('information');
```

### void warning(String message)

Writes an `warning` log containing the provided message.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.warning('warning information');
```

### void error(String message)

Writes an `error` log containing the provided message.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.error('error information');
```

### void panic(String message)

Writes an `panic` log containing the provided message.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 log.panic('panic information');
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

### ForceLog.Logger withException(Exception ex)

Adds exception data to the log. Will add the message, type, stack trace and line number to the logging output.

```apex
 ForceLog.Logger log = new ForceLog.Logger('myClassName');

 try {
     // ...
 } catch(Exception ex) {
    log.withException(ex).error('uh oh!');
 }
```

## Extending the logger

Everyone has their own way of handling logs in Salesforce. If you need logs handled in a custom way, you can override the `flush()` method. Let's say each log needs to be sent to an HTTP endpoint. You can implement a new logger that extends `ForceLog.Logger` and will create an HTTP request on every log written (**Note:** this is not best practice, just an example). By default, the logger will JSON-encode logs and write them to the debugger using `System.debug()`.

```apex
public class CalloutLogger extends ForceLog.Logger {
    private String endpoint;

    private Http client;

    public CalloutLogger(String name, String endpoint) {
        super(name);
        this.endpoint = endpoint;
        this.client = new Http();
    }

    public override void flush(Map<String, Object> log) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.endpoint);
        req.setMethod('POST');
        req.setBody(JSON.serialize(log));

        this.client.send(req);
    }
}
```