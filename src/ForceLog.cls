
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
     * @description The logger class is responsible for producing structured
     * JSON logs
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
         * @returns {void}
         */
        public void debug(String message) {
            this.logLevel = level.DEBUG;
            this.write(message);
        }

        /**
         * @description Creates an info log containing
         * the given message.
         * @param {String} message The info message
         * @returns {void}
         */
        public void info(String message) {
            this.logLevel = Level.INFO;
            this.write(message);
        }

        /**
         * @description Creates a warning log containing
         * the given message.
         * @param {String} message The warning message
         * @returns {void}
         */
        public void warning(String message) {
            this.logLevel = Level.WARNING;
            this.write(message);
        }

        /**
         * @description Creates an error log containing
         * the given message.
         * @param {String} message The error message
         * @returns {void}
         */
        public void error(String message) {
            this.logLevel = Level.ERROR;
            this.write(message);
        }

        /**
         * @description Creates a panic log containing
         * the given message.
         * @param {String} message The panic message
         * @returns {void}
         */
        public void panic(String message) {
            this.logLevel = Level.PANIC;
            this.write(message);
        }

        /**
         * @description Default implementation of flush(). Writes the
         * JSON serialized logs to the debugger.
         * @param {Map<String, Object>} log The log data represented as a map.
         * @returns {void}
         */ 
        public virtual void flush(Map<String, Object> log) {
            System.debug(JSON.serialize(log));
        }

        /**
         * @description Adds multiple fields to the log
         * @param {Map<String, Object>} fields The fields to log
         * @returns {Logger} The current instance of the logger, for method chaining.
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
         * @returns {LOgger} The current instance of the logger, for method chaining.
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
         * @returns {Logger} The current instance of the logger, for method chaining.
         */
        public Logger withException(Exception ex) {
            // If the exception wraps another, use the wrapped one
            if (ex.getCause() != null) {
                return this.withException(ex.getCause());
            }

            // Add exception details to the log fields.
            this.fields.put('exception_message', ex.getMessage());
            this.fields.put('exception_stack_trace', ex.getStackTraceString());
            this.fields.put('exception_line_number', ex.getLineNumber());
            this.fields.put('exception_type', ex.getTypeName());

            return this;
        }

        /**
         * @description Converts the log into an instance of
         * Map<String, Object> containing all provided fields
         * and exception details. This map is then passed to the
         * provided implementation of the flush() method.
         * @param {String} message The log message
         * @returns {void}
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
            for (String key : this.fields.keySet()) {
                log.put(key, this.fields.get(key));
            }

            // Invoke log flushing implementation.
            this.flush(log);

            // Remove exception fields if present as these have
            // already been logged.
            this.fields.remove('exception_message');
            this.fields.remove('exception_stack_trace');
            this.fields.remove('exception_line_number');
            this.fields.remove('exception_type');
        }
    }
}