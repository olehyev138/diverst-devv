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

### PUT /conversations/:id/opt_in

Opts in to a conversation (makes it permanent). Users have to opt in or out of conversations or else they get deleted after x days. It's like a trial to see if you connect well with the other person. You also rate your interaction with the other from 1 to 5.

**Request parameters**
```json
{
  "rating": 5
}
```

### PUT /conversations/:id/leave

Leave a conversation (either right after a trial or after having opted in). If it's right after the trial, you leave a rating too, but if you're just leaving the conversation, don't pass any parameter.

**Request parameters**
```json
{
  "rating": 1
}
```

## Devices

We track multiple devices per user to handle push notifications. The idea would be to add the device to the user's list of devices the first time he uses it and delete it when the user logs out (?).

### GET /devices

Get the list of the user's devices.

### POST /devices

Create a new device for the authenticated user. The accepted values for platform (I don't actually check) will be `apple`, `android` and `web`.

**Request parameters**
```json
{
  "device": {
    "token": "dsakjhdsakjhdaslksfgh ksdfh lkdsajkdfas",
    "platform": "apple"
  }
}
```

### POST /devices

Create a new device for the authenticated user. The accepted values for platform (I don't actually check) will be `apple`, `android` and `web`.

**Request parameters**
```json
{
  "device": {
    "token": "dsakjhdsakjhdaslksfgh ksdfh lkdsajkdfas",
    "platform": "apple"
  }
}
```

### DELETE /devices/:token

Deletes a device by its push token (not its id).

### POST /devices/:id/test_notif

Sends a test notification to the specified device. This is just to see if the push setup works.