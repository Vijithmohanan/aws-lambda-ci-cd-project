import json

def lambda_handler(event, context):
    """
    The handler function for the AWS Lambda.
    It receives the event from API Gateway and returns a structured HTTP response.
    """
    
    # 1. Extract Request Details from the Event
    # API Gateway provides the HTTP method and the body in the 'event' object.
    http_method = event.get('httpMethod', 'GET')
    
    # 2. Process the Request Body
    # The 'body' is a string (even if it contains JSON), so we must parse it.
    request_body = event.get('body')
    data = {}
    if request_body:
        try:
            data = json.loads(request_body)
        except json.JSONDecodeError:
            # Handle case where the body isn't valid JSON
            return {
                'statusCode': 400,
                'body': json.dumps({"error": "Invalid JSON format in request body"})
            }

    # 3. Business Logic (Example Implementation)
    
    if http_method == 'GET':
        # Example for a GET request: returning static data or fetching from a DB
        response_message = "You requested information (GET method)."
        status_code = 200
        
    elif http_method == 'POST':
        # Example for a POST request: simulating data insertion
        input_value = data.get('input', 'No input provided')
        response_message = f"Data successfully processed via POST. Received: {input_value}"
        status_code = 201 # 201 Created is typical for a successful POST
        
    else:
        # Handle unsupported methods
        response_message = f"HTTP Method {http_method} not supported."
        status_code = 405 # 405 Method Not Allowed

    # 4. Construct and Return the API Gateway Response
    # The return object must contain 'statusCode', 'headers', and 'body' (as a string).
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*' # Essential for CORS (Cross-Origin Resource Sharing)
        },
        'body': json.dumps({
            'success': True,
            'message': response_message
        })
    }
