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
    private static void itShouldProduceFormattedDebugLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'debug');
        logger.expect('message', 'testtest');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.debug('test{0}', new List<String> { 'test' });
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
    private static void itShouldProduceFormattedInfoLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'info');
        logger.expect('message', 'testtest');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.info('test{0}', new List<String> { 'test' });
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
    private static void itShouldProduceFormattedWarningLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'warning');
        logger.expect('message', 'testtest');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.warning('test{0}', new List<String> { 'test' });
    }

    @isTest
    private static void itShouldProduceErrorLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.error('test');
    }

    @isTest
    private static void itShouldProduceFormattedErrorLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
        logger.expect('message', 'testtest');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.error('test{0}', new List<String> { 'test' });
    }

    @isTest
    private static void itShouldProduceEmergencyLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'emerg');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.emergency('test');
    }

    @isTest
    private static void itShouldProduceFormattedEmergencyLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'emerg');
        logger.expect('message', 'testtest');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.emergency('test{0}', new List<String> { 'test' });
    }

    @isTest
    private static void itShouldProduceAlertLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'alert');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.alert('test');
    }

    @isTest
    private static void itShouldProduceFormattedAlertLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'alert');
        logger.expect('message', 'testtest');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.alert('test{0}', new List<String> { 'test' });
    }

    @isTest
    private static void itShouldProduceCriticalLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'crit');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.critical('test');
    }

    @isTest
    private static void itShouldProduceFormattedCriticalLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'crit');
        logger.expect('message', 'testtest');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.critical('test{0}', new List<String> { 'test' });
    }

    @isTest
    private static void itShouldProduceNoticeLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'notice');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.notice('test');
    }

    @isTest
    private static void itShouldProduceFormattedNoticeLogs() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'notice');
        logger.expect('message', 'testtest');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.notice('test{0}', new List<String> { 'test' });
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
    private static void itShouldAddAnArrayOfSObjects() {
        TestLogger logger = new TestLogger('test');
        
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

        logger.expect('sobjects', objs);
        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withSObjects('sobjects', objs).info('test');
    }

    @isTest
    private static void itShouldExcludeFieldsForAnArrayOfSObjects() {
        TestLogger logger = new TestLogger('test');
        
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

        logger.expect('sobjects', new List<Object> {
            new Map<String, Object> {
                'Email' => 'unit@test.com'
            },
            new Map<String, Object> {
                'Email' => 'unit@test.com'
            }
        });

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withSObjects('sobjects', objs, new Set<String> { 
            'FirstName', 
            'LastName' 
        }).info('test');
    }

    @isTest
    private static void itShouldAddSObjectDetails() {
        TestLogger logger = new TestLogger('test');
        Contact c = new Contact(
            FirstName = 'tester',
            LastName = 'mctest',
            Email = 'unit@test.com'
        );

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('sobject', c);
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withSObject('sobject', c).info('test');
    }

    @isTest
    private static void itShouldExcludeSObjectDetails() {
        TestLogger logger = new TestLogger('test');
        Contact c = new Contact(
            FirstName = 'tester',
            LastName = 'mctest',
            Email = 'unit@test.com'
        );

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('sobject', new Map<String, Object> {
            'FirstName' => 'tester',
            'LastName' => 'mctest'
        });
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withSObject('sobject', c, new Set<String> { 'Email' }).info('test');
    }

    @isTest
    private static void itShouldAddExceptionDetails() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
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
        logger.expect('level', 'err');
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
    private static void itShouldAddUpsertResult() {
        TestLogger logger = new TestLogger('test');

        Contact c = new Contact(
            FirstName = 'tester',
            LastName = 'mctest',
            Email = 'unit@test.com'
        );

        Database.UpsertResult result = Database.upsert(c);

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('result', new Map<String, Object> {
            'id' => result.getId(),
            'success' => result.isSuccess(),
            'errors' => new List<Object>(),
            'created' => result.isCreated(),
            'type' => 'upsert'
        });
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withResult(result).info('test');        
    }

    @isTest
    private static void itShouldAddUpsertResults() {
        TestLogger logger = new TestLogger('test');

        List<Contact> contacts = new List<Contact> {
            new Contact(
                FirstName = 'tester',
                LastName = 'mctest',
                Email = 'unit@test.com'
            )
        };

        List<Database.UpsertResult> results = Database.upsert(contacts);

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('results', new List<Object>{
            new Map<String, Object> {
                'id' => results.get(0).getId(),
                'success' => results.get(0).isSuccess(),
                'errors' => new List<Object>(),
                'created' => results.get(0).isCreated(),
                'type' => 'upsert'
            }
        });
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withResults(results).info('test');        
    }

    @isTest
    private static void itShouldAddDeleteResult() {
        TestLogger logger = new TestLogger('test');

        Contact c = new Contact(
            FirstName = 'tester',
            LastName = 'mctest',
            Email = 'unit@test.com'
        );

        insert c;

        Database.DeleteResult result = Database.delete(c);

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('result', new Map<String, Object> {
            'id' => result.getId(),
            'success' => result.isSuccess(),
            'errors' => new List<Object>(),
            'type' => 'delete'
        });
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withResult(result).info('test');        
    }

    @isTest
    private static void itShouldAddDeleteResults() {
        TestLogger logger = new TestLogger('test');

        List<Contact> contacts = new List<Contact> {
            new Contact(
                FirstName = 'tester',
                LastName = 'mctest',
                Email = 'unit@test.com'
            )
        };

        insert contacts;

        List<Database.DeleteResult> results = Database.delete(contacts);

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('results', new List<Object>{
            new Map<String, Object> {
                'id' => results.get(0).getId(),
                'success' => results.get(0).isSuccess(),
                'errors' => new List<Object>(),
                'type' => 'delete'
            }
        });
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withResults(results).info('test');        
    }

    @isTest
    private static void itShouldAddDatabaseErrors() {
        TestLogger logger = new TestLogger('test');

        Contact c = new Contact();

        Database.SaveResult result = Database.insert(c, false);

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('result', new Map<String, Object> {
            'id' => result.getId(),
            'success' => result.isSuccess(),
            'errors' => new List<Object>{
                new Map<String, Object> {
                    'fields' => result.getErrors().get(0).getFields(),
                    'message' => result.getErrors().get(0).getMessage(),
                    'code' => result.getErrors().get(0).getStatusCode()
                }
            },
            'type' => 'save'
        });
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withResult(result).info('test');        
    }

    @isTest
    private static void itShouldAddSaveResults() {
        TestLogger logger = new TestLogger('test');

        List<Contact> contacts = new List<Contact> {
            new Contact(
                FirstName = 'tester',
                LastName = 'mctest',
                Email = 'unit@test.com'
            )
        };

        List<Database.SaveResult> results = Database.insert(contacts);

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('results', new List<Object>{
            new Map<String, Object> {
                'id' => results.get(0).getId(),
                'success' => results.get(0).isSuccess(),
                'errors' => new List<Object>(),
                'type' => 'save'
            }
        });
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withResults(results).info('test');        
    }

    @isTest
    private static void itShouldAddSaveResult() {
        TestLogger logger = new TestLogger('test');

        Contact c = new Contact(
            FirstName = 'tester',
            LastName = 'mctest',
            Email = 'unit@test.com'
        );

        Database.SaveResult result = Database.insert(c);

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('result', new Map<String, Object> {
            'id' => result.getId(),
            'success' => result.isSuccess(),
            'errors' => new List<Object>(),
            'type' => 'save'
        });
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withResult(result).info('test');        
    }

    @isTest
    private static void itShouldAddSendEmailResult() {
        TestLogger logger = new TestLogger('test');

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'abc1@example.com', 'abc2@example.com' };
        message.subject = 'Subject Test Message';
        message.plainTextBody = 'This is the message body.';

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { message });
        Messaging.SendEmailResult result = results[0];

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('result', new Map<String, Object> {
            'success' => result.isSuccess(),
            'errors' => new List<Object>(),
            'type' => 'send_email'
        });
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withResult(result).info('test');        
    }

    @isTest
    private static void itShouldAddSendEmailResults() {
        TestLogger logger = new TestLogger('test');

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'abc1@example.com', 'abc2@example.com' };
        message.subject = 'Subject Test Message';
        message.plainTextBody = 'This is the message body.';

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { message });

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('results', new List<Object> {
            new Map<String, Object> {
                'success' => results.get(0).isSuccess(),
                'errors' => new List<Object>(),
                'type' => 'send_email'
            }
        });
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.withResults(results).info('test');        
    }

    @isTest
    private static void itShouldAddHttpRequestDetails() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
        logger.expect('message', 'test');
        logger.expect('request', new Map<String, Object> {
            'body' => '',
            'compressed' => false,
            'endpoint' => 'test_endpoint',
            'method' => 'GET'
        });

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('test_endpoint');

        logger.withRequest(req).error('test');
    }

    @isTest
    private static void itShouldAddHttpRequestDetailsWithName() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
        logger.expect('message', 'test');
        logger.expect('test_request', new Map<String, Object> {
            'body' => '',
            'compressed' => false,
            'endpoint' => 'test_endpoint',
            'method' => 'GET'
        });

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('test_endpoint');
        
        logger.withRequest('test_request', req).error('test');
    }

    @isTest
    private static void itShouldAddHttpResponseDetails() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
        logger.expect('message', 'test');
        logger.expect('response', new Map<String, Object> {
            'body' => '',
            'status' => 'OK',
            'status_code' => 200
        });

        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);

        logger.withResponse(res).error('test');
    }

    @isTest
    private static void itShouldIncludeHttpRequestHeaders() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
        logger.expect('message', 'test');
        logger.expect('test_request', new Map<String, Object> {
            'body' => '',
            'compressed' => false,
            'endpoint' => 'test_endpoint',
            'headers' => new Map<String, String> {
                'X-Header-2' => 'test_header_2'
            },
            'method' => 'GET'
        });

        HttpRequest req = new HttpRequest();
        req.setHeader('X-Header-1', 'test_header_1');
        req.setHeader('X-Header-2', 'test_header_2');
        req.setMethod('GET');
        req.setEndpoint('test_endpoint');
        
        logger.withRequest('test_request', req, new Set<String> { 'X-Header-2' }).error('test');
    }

    @isTest
    private static void itShouldAddHttpResponseDetailsWithName() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
        logger.expect('message', 'test');
        logger.expect('test_response', new Map<String, Object> {
            'body' => '',
            'status' => 'OK',
            'status_code' => 200
        });

        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);

        logger.withResponse('test_response', res).error('test');
    }

    @isTest
    private static void itShouldExcludeHttpResponseHeaders() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
        logger.expect('message', 'test');
        logger.expect('test_response', new Map<String, Object> {
            'body' => '',
            'headers' => new Map<String, String> {
                'X-Header-2' => 'test_header_2'
            },
            'status' => 'OK',
            'status_code' => 200
        });

        HttpResponse res = new HttpResponse();
        res.setHeader('X-Header-1', 'test_header_1');
        res.setHeader('X-Header-2', 'test_header_2');
        res.setStatus('OK');
        res.setStatusCode(200);

        logger.withResponse('test_response', res, new Set<String> { 'X-Header-1' }).error('test');
    }

    @isTest
    private static void itShouldAddRestRequestDetails() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
        logger.expect('message', 'test');
        logger.expect('request', new Map<String, Object> {
            'body' => '{}',
            'headers' => new Map<String, String> { 'X-Header' => 'test_header' },
            'method' => 'POST',
            'params' => new Map<String, String> { 'param' => 'test' },
            'path' => '/path',
            'remote_address' => '127.0.0.1',
            'uri' => '/uri'
        });

        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf('{}');
        req.headers.put('X-Header', 'test_header');
        req.httpMethod = 'POST';
        req.params.put('param', 'test');
        req.resourcePath = '/path';
        req.remoteAddress = '127.0.0.1';
        req.requestURI = '/uri';
        
        logger.withRequest(req).error('test');
    }

    @isTest
    private static void itShouldAddRestRequestDetailsWithAName() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
        logger.expect('message', 'test');
        logger.expect('test_request', new Map<String, Object> {
            'body' => '{}',
            'headers' => new Map<String, String> { 'X-Header' => 'test_header' },
            'method' => 'POST',
            'params' => new Map<String, String> { 'param' => 'test' },
            'path' => '/path',
            'remote_address' => '127.0.0.1',
            'uri' => '/uri'
        });

        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf('{}');
        req.headers.put('X-Header', 'test_header');
        req.httpMethod = 'POST';
        req.params.put('param', 'test');
        req.resourcePath = '/path';
        req.remoteAddress = '127.0.0.1';
        req.requestURI = '/uri';
        
        logger.withRequest('test_request', req).error('test');
    }

    @isTest
    private static void itShouldAddRestResponseDetails() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
        logger.expect('message', 'test');
        logger.expect('response', new Map<String, Object> {
            'body' => '{}',
            'headers' => new Map<String, String> { 'X-Header' => 'test_header' },
            'status_code' => 200
        });

        RestResponse res = new RestResponse();
        res.responseBody = Blob.valueOf('{}');
        res.headers.put('X-Header', 'test_header');
        res.statusCode = 200;
        
        logger.withResponse(res).error('test');
    }

    @isTest
    private static void itShouldAddRestRequestReponseWithAName() {
        TestLogger logger = new TestLogger('test');

        logger.expect('level', 'err');
        logger.expect('message', 'test');
        logger.expect('test_response', new Map<String, Object> {
            'body' => '{}',
            'headers' => new Map<String, String> { 'X-Header' => 'test_header' },
            'status_code' => 200
        });

        RestResponse res = new RestResponse();
        res.responseBody = Blob.valueOf('{}');
        res.headers.put('X-Header', 'test_header');
        res.statusCode = 200;
        
        logger.withResponse('test_response', res).error('test');
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

    @isTest
    private static void itShouldAddMergeResults() {
        TestLogger logger = new TestLogger('test');
        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');
        
        // Create two accounts to act as a duplicate
        List<Account> accounts = new List<Account> {
            new Account(Name='Test Account 1'),
            new Account(Name='Test Account 2')
        };

        insert accounts;

        // Create a contact to be related to a single account
        Contact con = new Contact(FirstName='Test', LastName='McTest', AccountId=accounts.get(0).Id);
        insert con;

        Database.MergeResult result = Database.merge(accounts.get(0), accounts.get(1));

        logger.expect('results', new List<Map<String, Object>> {
            new Map<String, Object> {
                'id' => result.getId(),
                'errors' => new List<Object>(),
                'success' => result.isSuccess(),
                'merged_record_ids' => result.getMergedRecordIds(),
                'updated_related_ids' => result.getUpdatedRelatedIds(),
                'type' => 'merge'
            }
        });

        logger.withResults(new List<Database.MergeResult> { result }).info('test');         
    }

    @isTest
    private static void itShouldAddAMergeResult() {
        TestLogger logger = new TestLogger('test');
        
        // Create two accounts to act as a duplicate
        List<Account> accounts = new List<Account> {
            new Account(Name='Test Account 1'),
            new Account(Name='Test Account 2')
        };

        insert accounts;

        // Create a contact to be related to a single account
        Contact con = new Contact(FirstName='Test', LastName='McTest', AccountId=accounts.get(0).Id);
        insert con;

        Database.MergeResult result = Database.merge(accounts.get(0), accounts.get(1));

        logger.expect('result', new Map<String, Object> {
            'id' => result.getId(),
            'errors' => new List<Object>(),
            'success' => result.isSuccess(),
            'merged_record_ids' => result.getMergedRecordIds(),
            'updated_related_ids' => result.getUpdatedRelatedIds(),
            'type' => 'merge'
        });

        logger.withResult(result).info('test');   
    }

    private static void itShouldAddSOQLQueries() {
        TestLogger logger = new TestLogger('test');
        Database.QueryLocator ql = Database.getQueryLocator([
            SELECT ID
            FROM Contact
            LIMIT 1
        ]);

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');

        logger.expect('query', ql.getQuery());

        logger.withQuery(ql).info('test');        
    }

    @isTest
    private static void itShouldRegisterAndUseHooks() {
        TestLogger logger = new TestLogger('test');
        logger.addHook(new TestHook());

        logger.expect('level', 'info');
        logger.expect('message', 'test');
        logger.expect('timestamp', '*');
        logger.expect('name', 'test');
        logger.expect('hook_field', '123');
        logger.info('test');
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

    private class TestHook implements ForceLog.Hook {
        public void fire(Map<String, Object> log) {
            log.put('hook_field', '123');
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