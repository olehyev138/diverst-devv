# API Doc

Technical API reference documentation for Diverst

## Authentication

### Login

POST to */employees/auth/sign_in* with the following parameters:

```json
{
  "email": "john@example.com",
  "password": "s3cr3t"
}
```

You will get the logged in employee as a response. All the authentication parameters will be in the response's header. They are: `access-token`, `client` and `uid`. Include these 3 headers in your next request to authenticate it.

### Validation

Call GET */employees/auth/validate_token* with your auth headers to see if your token is valid. If it is valid, it also returns the user (useful to update it locally).

## Matches

### GET /matches

Returns a list of the top 10 potential matches for the authenticated employee.

### PUT /matches/:id/swipe

Swipes a match. Accepted is 1 and rejected is 2.

**Request parameters**
```json
{
  "swipe": {
    "choice": 1
  }
}
```

## Conversations

### GET /conversations

Returns the list of active conversations (matches that have been accepted by both users and turned into Firebase conversations).

### DELETE /conversations/:id

Archives a conversation and notifies the other user that he's been ditched.
