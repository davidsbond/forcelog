
/*
 * @description A structured logger for Salesforce Apex. allows for
 * the creation of JSON-encodable logs that can be handled in a way
 * of your choosing by implementing the flush() method.
 * @author David Bond <davidsbond93@gmail.com>
 */
public with sharing class ForceLog {
    /**
     * @description Exception thrown when a reserved field name is
     * provided to the withField() method.
     */
    public class ReservedFieldException extends Exception {}

    /**
     * @description Supported log levels.
     */
    private enum Level {
        DEBUG,
        INFO,
        WARNING,
        ERROR,
        PANIC
    }

    /**
     * @description SError message for a reserved field.
     */
    private static final String RESERVED_FIELD_ERROR = 'Field name "{0}" is reserved';

    /**
     * @description SError message for a reserved field used by withException().
     */
    private static final String RESERVED_EXCEPTION_FIELD_ERROR = 'Field name "{0}" is reserved, use withException() instead';

    /**
     * @description SError message for a reserved field used by withRequest().
     */
    private static final String RESERVED_REQUEST_FIELD_ERROR = 'Field name "{0}" is reserved, use withRequest() instead';

    /**
     * @description SError message for a reserved field used by withResponse().
     */
    private static final String RESERVED_RESPONSE_FIELD_ERROR = 'Field name "{0}" is reserved, use withResponse() instead';

    /**
     * @description Map of reserved field names and their error messages.
     */
    private static final Map<String, String> RESERVED_FIELDS = new Map<String, String> {
        'name' => RESERVED_FIELD_ERROR,
        'level' => RESERVED_FIELD_ERROR,
        'timestamp' => RESERVED_FIELD_ERROR,
        'exception_message' => RESERVED_EXCEPTION_FIELD_ERROR,
        'exception_type' => RESERVED_EXCEPTION_FIELD_ERROR,
        'exception_stack_trace' => RESERVED_EXCEPTION_FIELD_ERROR,
        'exception_line_number' => RESERVED_EXCEPTION_FIELD_ERROR,
        'exception_cause' => RESERVED_EXCEPTION_FIELD_ERROR,
        'request' => RESERVED_REQUEST_FIELD_ERROR,
        'response' => RESERVED_RESPONSE_FIELD_ERROR
    };

    /**
     * @description The Logger class is responsible for producing structured
     * logs and will execute the `flush()` method every time a write method
     * is used (debug, info, warning, error, panic)
     */
    public abstract class Logger {

        /**
         * @description The fields the log will contain
         * @type {Map<String, Object>}
         */
        private Map<String, Object> fields;

        /**
         * @description The name for this log, should be
         * a class or method name.
         * @type {String}
         */
        private String name;

        /**
         * @description Initializes a new instance of the 
         * Logger class.
         * @param {String} name The log name, should be a class or method name.
         * @constructor
         */
        public Logger(String name) {
            this.fields = new Map<String, Object>();
            this.name = name;
        }

        /**
         * @description Creates a debug log containing
         * the given message.
         * @param {String} message The debug message
         * @return {void}
         */
        public void debug(String message) {
            this.write(message, Level.DEBUG);
        }

        /**
         * @description Creates an info log containing
         * the given message.
         * @param {String} message The info message
         * @return {void}
         */
        public void info(String message) {
            this.write(message, Level.INFO);
        }

        /**
         * @description Creates a warning log containing
         * the given message.
         * @param {String} message The warning message
         * @return {void}
         */
        public void warning(String message) {
            this.write(message, Level.WARNING);
        }

        /**
         * @description Creates an error log containing
         * the given message.
         * @param {String} message The error message
         * @return {void}
         */
        public void error(String message) {
            this.write(message, Level.ERROR);
        }

        /**
         * @description Creates a panic log containing
         * the given message.
         * @param {String} message The panic message
         * @return {void}
         */
        public void panic(String message) {
            this.write(message, Level.PANIC);
        }

        /**
         * @description Default implementation of flush(). Writes the
         * JSON serialized logs to the debugger.
         * @param {Map<String, Object>} log The log data represented as a map.
         * @return {void}
         */ 
        protected virtual void flush(Map<String, Object> log) {
            System.debug(JSON.serialize(log));
        }

        /**
         * @description Adds multiple fields to the log
         * @param {Map<String, Object>} fields The fields to log
         * @return {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withFields(Map<String, Object> fields) {
            for (String key : fields.keySet()) {
                this.withField(key, fields.get(key));
            }

            return this;
        }

        /**
         * @description Adds a field to the log
         * @param {String} name The field name
         * @param {Object} value The field's value
         * @throws {ReservedFieldException} Exception thrown when reserved field
         * names are used.
         * @return {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withField(String name, Object value) {
            // Throw a ReservedFieldException if trying to use a reserved field name.
            if(RESERVED_FIELDS.keySet().contains(name)) {
                throw new ReservedFieldException(String.format(RESERVED_FIELDS.get(name), new List<String> { name }));
            } else {
                this.fields.put(name, value);
            }

            return this;
        }

        /**
         * @description Adds exception data to the log.
         * @param {Exception} ex The exception to log, traverses the cause
         * of each exception to log the root cause of any exception.
         * @return {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withException(Exception ex) {
            // Add exception details to the log fields.
            this.fields.putAll(getExceptionFields(ex));

            return this;
        }

        /**
         * @description Adds HttpRequest data to the log.
         * @param {HttpRequest} req The HttpRequest to log.
         * @return {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withRequest(HttpRequest req) {
            return withRequest(req, new Set<String>());
        }

        /**
         * @description Adds HttpRequest data to the log using a defined field name.
         * @param {String} name The field name.
         * @param {HttpRequest} req The HttpRequest to log.
         * @return {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withRequest(String name, HttpRequest req) {
            return withRequest(name, req, new Set<String>());
        }

        /**
         * @description Adds HttpRequest data to the log including headers.
         * @param {HttpRequest} req The HttpRequest to log.
         * @param {Set<String>} includeHeaders The headers to include in the log.
         * @return {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withRequest(HttpRequest req, Set<String> includeHeaders) {
            return withRequest('request', req, includeHeaders);
        }

        /**
         * @description Adds HttpRequest data to the log including headers using a defined field name.
         * @param {String} name The field name.
         * @param {HttpRequest} req The HttpRequest to log.
         * @param {Set<String>} includeHeaders The headers to include in the log.
         * @return {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withRequest(String name, HttpRequest req, Set<String> includeHeaders) {
            Map<String, Object> requestFields = new Map<String, Object> {
                'body' => req.getBody(),
                'compressed' => req.getCompressed(),
                'endpoint' => req.getEndpoint(),
                'method' => req.getMethod()
            };
            
            if (!includeHeaders.isEmpty()) {
                // Build up the map of headers if they should be included
                Map<String, String> headers = new Map<String, String>();

                for (String header : includeHeaders) {
                    headers.put(header, req.getHeader(header));
                }

                requestFields.put('headers', headers);
            }

            this.fields.put(name, requestFields);

            return this;
        }

        /**
         * @description Adds HttpResponse data to the log.
         * @param {HttpResponse} res The HttpResponse to log.
         * @return {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withResponse(HttpResponse res) {
            return withResponse(res, new Set<String>());
        }

        /**
         * @description Adds HttpResponse data to the log using a defined field name.
         * @param {String} name The field name.
         * @param {HttpResponse} res The HttpResponse to log.
         * @return {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withResponse(String name, HttpResponse res) {
            return withResponse(name, res, new Set<String>());
        }

        /**
         * @description Adds HttpResponse data to the log excluding headers.
         * @param {HttpResponse} res The HttpResponse to log.
         * @param {Set<String>} excludeHeaders The headers to exclude from the log.
         * @return {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withResponse(HttpResponse res, Set<String> excludeHeaders) {
            return withResponse('response', res, excludeHeaders);
        }

        /**
         * @description Adds HttpResponse data to the log excluding headers using a defined field name.
         * @param {String} name The field name.
         * @param {HttpResponse} res The HttpResponse to log.
         * @param {Set<String>} excludeHeaders The headers to exclude from the log.
         * @return {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withResponse(String name, HttpResponse res, Set<String> excludeHeaders) {
            Map<String, Object> responseFields = new Map<String, Object> {
                'body' => res.getBody(),
                'status' => res.getStatus(),
                'status_code' => res.getStatusCode()
            };

            // Build up the map of headers
            Map<String, String> headers = new Map<String, String>();

            for (String header : res.getHeaderKeys()) {
                if(!excludeHeaders.contains(header)) {
                    headers.put(header, res.getHeader(header));
                }
            }

            if(!headers.isEmpty()) {
                responseFields.put('headers', headers);
            }

            this.fields.put(name, responseFields);

            return this;
        }

        /**
         * @description Adds a single instance of Database.SaveResult to the log
         * @param {Database.SaveResult} res The database result to log
         * @returns {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withResult(Database.SaveResult res) {
            return this.withResult('result', res);
        }

        /**
         * @description Adds a single instance of Database.DeleteResult to the log
         * @param {Database.DeleteResult} res The database result to log
         * @returns {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withResult(Database.DeleteResult res) {
            return this.withResult('result', res);
        }

        /**
         * @description Adds a single instance of Database.UpsertResult to the log
         * @param {Database.UpsertResult} res The database result to log
         * @returns {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withResult(Database.UpsertResult res) {
            return this.withResult('result', res);
        }

        /**
         * @description Adds a single instance of Database.DeleteResult to the log under
         * a given key
         * @param {String} key The key where the save result will be nested in the log.
         * @param {Database.DeleteResult} res The database result to log
         * @returns {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withResult(String key, Database.DeleteResult res) {
            Map<String, Object> entry = new Map<String, Object>{
                'id' => res.getId(),
                'success' => res.isSuccess(),
                'errors' => this.formatDatabaseErrors(res.getErrors()),
                'type' => 'delete'
            };

            return this.withField(key, entry);
        }

        /**
         * @description Adds a single instance of Database.SaveResult to the log under
         * a given key
         * @param {String} key The key where the save result will be nested in the log.
         * @param {Database.SaveResult} res The database result to log
         * @returns {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withResult(String key, Database.SaveResult res) {
            Map<String, Object> entry = new Map<String, Object>{
                'id' => res.getId(),
                'success' => res.isSuccess(),
                'errors' => this.formatDatabaseErrors(res.getErrors()),
                'type' => 'save'
            };

            return this.withField(key, entry);
        }

        /**
         * @description Adds a single instance of Database.UpsertResult to the log under
         * a given key
         * @param {String} key The key where the save result will be nested in the log.
         * @param {Database.UpsertResult} res The database result to log
         * @returns {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withResult(String key, Database.UpsertResult res) {
            Map<String, Object> entry = new Map<String, Object>{
                'id' => res.getId(),
                'success' => res.isSuccess(),
                'errors' => this.formatDatabaseErrors(res.getErrors()),
                'created' => res.isCreated(),
                'type' => 'upsert'
            };

            return this.withField(key, entry);
        }

        public Logger withResults(List<Database.SaveResult> results) {
            return this.withResults('results', results);
        }

        public Logger withResults(List<Database.UpsertResult> results) {
            return this.withResults('results', results);
        }

        public Logger withResults(List<Database.DeleteResult> results) {
            return this.withResults('results', results);
        }

        public Logger withResults(String key, List<Database.SaveResult> results) {
            List<Object> entry = new List<Object>();

            for (Database.SaveResult res : results) {
                entry.Add(new Map<String, Object>{
                    'id' => res.getId(),
                    'success' => res.isSuccess(),
                    'errors' => this.formatDatabaseErrors(res.getErrors()),
                    'type' => 'save'
                });           
            }

            return this.withField(key, entry);
        }

        public Logger withResults(String key, List<Database.UpsertResult> results) {
            List<Object> entry = new List<Object>();

            for (Database.UpsertResult res : results) {
                entry.Add(new Map<String, Object>{
                    'id' => res.getId(),
                    'success' => res.isSuccess(),
                    'errors' => this.formatDatabaseErrors(res.getErrors()),
                    'type' => 'upsert',
                    'created' => res.isCreated()
                });           
            }

            return this.withField(key, entry);
        }

        public Logger withResults(String key, List<Database.DeleteResult> results) {
            List<Object> entry = new List<Object>();

            for (Database.DeleteResult res : results) {
                entry.Add(new Map<String, Object>{
                    'id' => res.getId(),
                    'success' => res.isSuccess(),
                    'errors' => this.formatDatabaseErrors(res.getErrors()),
                    'type' => 'delete'
                });           
            }

            return this.withField(key, entry);
        }

        private List<Object> formatDatabaseErrors(List<Database.Error> errs) {
            List<Object> output = new List<Object>();

            for (Database.Error err : errs) {
                output.add(new Map<String, Object> {
                    'fields' => err.getFields(),
                    'message' => err.getMessage(),
                    'code' => err.getStatusCode()
                });
            }

            return output;
        }

        /**
         * @description Converts the log into an instance of
         * Map<String, Object> containing all provided fields
         * and exception details. This map is then passed to the
         * provided implementation of the flush() method.
         * @param {String} message The log message
         * @param {Level} logLevel The level for this log, should be debug, info, warning, error or panic
         * @return {void}
         */
        private void write(String message, Level logLevel) {
            // Create map containing default logging fields.
            Map<String, Object> log = new Map<String, Object> {
                'message' => message,
                'level' => logLevel.name().toLowerCase(),
                'name' => this.name,
                'timestamp' => Datetime.now()
            };

            // Add additional fields to log.
            log.putAll(this.fields);

            // Invoke log flushing implementation.
            this.flush(log);

            // Remove fields if present as these have already been logged.
            this.fields.clear();
        }
    }

    /**
     * @description The BulkLogger class is responsible for producing structured
     * logs and will execute the `bulkFlush()` method when `dispose()` is called.
     */
    public abstract class BulkLogger extends Logger {
        /**
         * @description The logs stored by the logger
         * @type {List<Map<String, Object>>}
         */
        private List<Map<String, Object>> logs;

        /**
         * @description Initializes a new instance of the BulkLogger class using
         * the provided name.
         * @param {String} name The log name. Should be a method or class name.
         * @constructor
         */
        public BulkLogger(String name) {
            super(name);
            this.logs = new List<Map<String, Object>>();
        }

        /**
         * @description Used when the logger is no longer requires, passes all
         * logs to the `bulkFlush()` method.
         * @return {void}
         */
        public void dispose() {
            this.bulkFlush(this.logs);
        }

        /**
         * @description Method executed when a log is produced, adds the log to
         * the list of all logs so far.
         * @param {Map<String, Object>} log The log data
         * @return {void}
         */
        protected override void flush(Map<String, Object> log) {
            this.logs.add(log);
        }

        /**
         * @description Default implementation of bulkFlush(). Writes the
         * JSON serialized logs to the debugger.
         * @param {List<Map<String, Object>>} logs The list of log data
         * @return {void}
         */ 
        protected virtual void bulkFlush(List<Map<String, Object>> logs) {
            for (Map<String, Object> log : logs) {
                System.debug(JSON.serialize(log));
            }
        }
    }

    /**
     * @description Gets the fields to log from an exception, recursivly traverses the cause(s)
     * @param {Exception} ex The exception to get fields from
     * @return {Map<String, Object>} The fields to log from the exception
     */
    private static Map<String, Object> getExceptionFields(Exception ex) {
        return new Map<String, Object> {
            'exception_message' => ex.getMessage(),
            'exception_stack_trace' => ex.getStackTraceString(),
            'exception_line_number' => ex.getLineNumber(),
            'exception_type' => ex.getTypeName(),
            'exception_cause' => ex.getCause() != null ? getExceptionFields(ex.getCause()) : null
        };
    }
}
