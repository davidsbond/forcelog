@isTest
private class ForceLogTest {

    @isTest
    private static void itShouldProduceDebugLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'debug');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.debug('test');
    }

    @isTest
    private static void itShouldProduceInfoLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.info('test');
    }

    @isTest
    private static void itShouldProduceWarningLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'warning');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.warning('test');
    }

    @isTest
    private static void itShouldProduceErrorLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'error');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.error('test');
    }

    @isTest
    private static void itShouldProducePanicLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'panic');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.panic('test');
    }

    @isTest
    private static void itShouldAddAField() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('field', 'value');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withField('field', 'value').info('test');
    }

    @isTest
    private static void itShouldAddFields() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('fieldOne', 'value');
        logger.expect('fieldTwo', 'value');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withFields(new Map<String, Object> {
            'fieldOne' => 'value',
            'fieldTwo' => 'value'
        }).info('test');
    }

    @isTest
    private static void itShouldAddExceptionDetails() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'error');
        logger.expect('message', 'test');
        logger.expect('exception_message', 'test');
        logger.expect('exception_type', '*');
        logger.expect('exception_stack_trace', '*');
        logger.expect('exception_line_number', '*');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withException(new TestException('test')).error('test');
    }

    @isTest
    private static void itShouldAddExceptionCauses() {
        TestLogger logger = new TestLogger('test');
        logger.expect('level', 'error');
        logger.expect('message', 'test');
        logger.expect('exception_message', 'test');
        logger.expect('exception_type', '*');
        logger.expect('exception_stack_trace', '*');
        logger.expect('exception_line_number', '*');
        logger.expect('exception_cause', '*');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        TestException ex = new TestException('test');
        ex.initCause(new TestException('test'));

        logger.withException(ex).error('test');
    }

    @isTest
    private static void itShouldAddHttpRequestDetails() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'error');
        logger.expect('message', 'test');
        logger.expect('request', '*');

        logger.withRequest(new HttpRequest()).error('test');
    }

    @isTest
    private static void itShouldAddHttpRequestDetailsWithName() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'error');
        logger.expect('message', 'test');
        logger.expect('test_request', '*');

        logger.withRequest('test_request', new HttpRequest()).error('test');
    }

    @isTest
    private static void itShouldAddHttpResponseDetails() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'error');
        logger.expect('message', 'test');
        logger.expect('response', '*');

        logger.withResponse(new HttpResponse()).error('test');
    }

    @isTest
    private static void itShouldAddHttpResponseDetailsWithName() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'error');
        logger.expect('message', 'test');
        logger.expect('test_response', '*');

        logger.withResponse('test_response', new HttpResponse()).error('test');
    }

    @isTest
    private static void itShouldNotAllowReservedNames() {
        TestLogger logger = new TestLogger('test');

        List<String> names = new List<String>{
            'name',
            'level',
            'timestamp',
            'exception_message',
            'exception_type',
            'exception_stack_trace',
            'exception_line_number',
            'exception_cause',
            'request',
            'response'
        };

        for (String name : names) {
            Boolean thrown = false;

            try {
                logger.withField(name, 'value').info('test');
            } catch (ForceLog.ReservedFieldException ex) {
                thrown = true;
            }

            System.assertEquals(true, thrown);
        }
    }

    @isTest
    private static void itShouldProduceBulkLogs() {
        TestBulkLogger logger = new TestBulkLogger('test');

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.info('test');
        logger.info('test');
        logger.info('test');
        logger.info('test');

        logger.dispose();
    }

    /**
     * @description Basic exception for use in tests.
     */
    private class TestException extends Exception {}

    /**
     * @description Test implementation of ForceLog.Logger that can
     * validate output via the flush() method. To check a field is
     * populated correctly, use the expect() method.
     */
    private class TestLogger extends ForceLog.Logger {
        /**
         * @description The fields the logger is expected to output
         * @type {Map<String, Object>}
         */
        private Map<String, Object> expectedFields;

        /**
         * @description Initializes a new instance of the TestLogger class.
         * @param {String} name The name of the log
         * @constructor
         */
        public TestLogger(String name) {
            super(name);
            this.expectedFields = new Map<String, Object>();
        }

        /**
         * @description Creates an expectation that must be satisfied
         * when producing logs.
         * @param {String} key The field name
         * @param {Object} value The expected value
         * @return {void}
         */
        public void expect(String key, Object value) {
            this.expectedFields.put(key, value);
        }

        /**
         * @description Implements the flush() method, checks that values in
         * the expected map exist and match those in the log payload
         * @param {Map<String, Object>} log The log payload
         * @return {void}
         */
        public override void flush(Map<String, Object> log) {
            for (String expKey : this.expectedFields.keySet()) {
                // Get the expected and actual values and compare.
                Object actVal = log.get(expKey);
                Object expVal = this.expectedFields.get(expKey);

                // If we only care about the field existing, ensure
                // it is not null.
                if (expVal == '*') {
                    System.assertNotEquals(null, actVal);
                    return;
                }

                System.assertEquals(expVal, actVal);
            }
        }
    }

    private class TestBulkLogger extends ForceLog.BulkLogger {
        /**
         * @description The fields the logger is expected to output
         * @type {Map<String, Object>}
         */
        private Map<String, Object> expectedFields;

        /**
         * @description Initializes a new instance of the TestBulkLogger class.
         * @param {String} name The name of the log
         * @constructor
         */
        public TestBulkLogger(String name) {
            super(name);
            this.expectedFields = new Map<String, Object>();
        }

        /**
         * @description Creates an expectation that must be satisfied
         * when producing logs.
         * @param {String} key The field name
         * @param {Object} value The expected value
         * @return {void}
         */
        public void expect(String key, Object value) {
            this.expectedFields.put(key, value);
        }

        /**
         * @description Implements the bulkFlush() method, checks that values in
         * the expected map exist and match those in the log payloads
         * @param {List<Map<String, Object>>} log The log payloads
         * @return {void}
         */
        protected override void bulkFlush(List<Map<String, Object>> logs) {
            for (Map<String, Object> log : logs) {
                for (String expKey : this.expectedFields.keySet()) {
                    // Get the expected and actual values and compare.
                    Object actVal = log.get(expKey);
                    Object expVal = this.expectedFields.get(expKey);

                    // If we only care about the field existing, ensure
                    // it is not null.
                    if (expVal == '*') {
                        System.assertNotEquals(null, actVal, String.format('{0} {1}', new List<String> { expKey, JSON.serialize(log) }));
                        return;
                    }

                    System.assertEquals(expVal, actVal);
                }
            }
        }
    }
}