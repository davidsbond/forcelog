
/*
 * @description A structured logger for Salesforce Apex. allows for
 * the creation of JSON-encodable logs that can be handled in a way
 * of your choosing by implementing the flush() method.
 * @author David Bond <davidsbond93@gmail.com>
 */
global with sharing class ForceLog {
    /**
     * @description Exception thrown when a reserved field name is
     * provided to the withField() method.
     */
    public class ReservedFieldException extends Exception {}

    /**
     * @description Supported log levels.
     */
    public enum Level {
        DEBUG,
        INFO,
        WARNING,
        ERROR,
        PANIC
    }

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
         * @description The level for this log, should be
         * debug, info, warning, error or panic
         * @type {Level}
         */
        private Level logLevel;

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
            this.logLevel = level.DEBUG;
            this.write(message);
        }

        /**
         * @description Creates an info log containing
         * the given message.
         * @param {String} message The info message
         * @return {void}
         */
        public void info(String message) {
            this.logLevel = Level.INFO;
            this.write(message);
        }

        /**
         * @description Creates a warning log containing
         * the given message.
         * @param {String} message The warning message
         * @return {void}
         */
        public void warning(String message) {
            this.logLevel = Level.WARNING;
            this.write(message);
        }

        /**
         * @description Creates an error log containing
         * the given message.
         * @param {String} message The error message
         * @return {void}
         */
        public void error(String message) {
            this.logLevel = Level.ERROR;
            this.write(message);
        }

        /**
         * @description Creates a panic log containing
         * the given message.
         * @param {String} message The panic message
         * @return {void}
         */
        public void panic(String message) {
            this.logLevel = Level.PANIC;
            this.write(message);
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
         * @throws {InvalidParameterException} Exception is thrown when reserved field
         * names are used.
         * @return {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withField(String name, Object value) {
            // Throw a ReservedFieldException if trying to use a reserved field name.
            switch on name {
                when 'name' {
                    throw new ReservedFieldException('Field name "name" is reserved');
                }
                when 'level' {
                    throw new ReservedFieldException('Field name "level" is reserved');
                }
                when 'timestamp' {
                    throw new ReservedFieldException('Field name "timestamp" is reserved');
                }
                when 'exception_message' {
                    throw new ReservedFieldException('Field name "exception_message" is reserved, use withException() instead');
                }
                when 'exception_stack_trace' {
                    throw new ReservedFieldException('Field name "exception_stack_trace" is reserved, use withException() instead');
                }
                when 'exception_line_number' {
                    throw new ReservedFieldException('Field name "exception_line_number" is reserved, use withException() instead');
                }
                when 'exception_type' {
                    throw new ReservedFieldException('Field name "exception_type" is reserved, use withException() instead');
                }
                when 'exception_cause' {
                    throw new ReservedFieldException('Field name "exception_cause" is reserved, use withException() instead');
                }
                when else {
                    this.fields.put(name, value);
                }
            }

            return this;
        }

        /**
         * @description Adds exception data to the log
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
         * @description Converts the log into an instance of
         * Map<String, Object> containing all provided fields
         * and exception details. This map is then passed to the
         * provided implementation of the flush() method.
         * @param {String} message The log message
         * @return {void}
         */
        private void write(String message) {
            // Create map containing default logging fields.
            Map<String, Object> log = new Map<String, Object> {
                'message' => message,
                'level' => this.logLevel.name().toLowerCase(),
                'name' => this.name,
                'timestamp' => Datetime.now()
            };

            // Add additional fields to log.
            log.putAll(this.fields);

            // Invoke log flushing implementation.
            this.flush(log);

            // Remove exception fields if present as these have
            // already been logged.
            this.fields.remove('exception_message');
            this.fields.remove('exception_stack_trace');
            this.fields.remove('exception_line_number');
            this.fields.remove('exception_type');
            this.fields.remove('exception_cause');
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