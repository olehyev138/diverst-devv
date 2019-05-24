
## App Structuring

## Store structuring

- Generally keep the store as normalized and 'db like' as possible. 
  Try to keep db as shallow and flat as possible. Store objects with a key for fast access

        { groups:
          '1': { 
            id: 1,
            name: 'erg-01'
            ...
          },
          ...
        }
  A more complex scenario would be say, we had a news feed with posts and comments.
  An inefficient way of representing this in the store would be:
  
      {[
        news_feed: {
          id: 3,
          posts: [{
            id: 7
            content: '...'
            comments: [{
              id: 9,
              content: '...'
            },
            ... 
            ]
          },
          ...
          ] 
        },
        ...
      ]}
  This is a highly inefficient way of storing data, for one wed have to search
  through each array looking for a matching id, searching each array is a O(n)
  operation. 
  
  A more efficient way would be 1) flattening the structure and 2) using keys
  for O(1) access.
  
      state = {
        news_feed: {
          byId: {
            3: { 
              id: 3,
              posts: [1, 7, 3]
            }
          }
        }
        posts: {
          byId: {
            7: {
              id: 7,
              content: ''
            }
          }
        }
      }
      
   Now lookup is instantaneous and we dont have to dig deep into a data structure
   to find what were looking for. If we say needed to store a ordered version
   of objects, then in addition to our byId hash, we can have a 'ordered' array
   of just ids. Like: `ordered: [ 5, 6, 1, 3]`
        
## Actions

- Generally map action names to API rest/crud actions, ie: `GET_GROUP`, `CREATE_GROUP`
- Actions relating to API querying should have 3 states: `BEGIN`, `SUCCESS`, `ERROR`
  `BEGIN` should be the action a saga listens too, to begin the api querying
  `SUCCESS` and `FAIL` should be dispatched by the saga and dealt with by
  a reducer that updates the state accordingly.
  On these API actions, a store flag called something like `IS_FETCHING` can be 
  toggled to update the UI and show a spinner
  
      # example
      GET_GROUP_BEGIN
      GET_GROUP_SUCCESS
      GET_GROUP_FAIL
      

- Use ERROR over FAIL for indiciating failed api queries, to keep things consistent
  within the project.
- Action names should be defined in `./constants.js` where `./` is container directory
- Action names should be namespaced, so as to avoid possible collision with other
  actions. Format should be `app/containers/<ContainerName>/ActionName`
- Use action creators, define them in `./actions.js`

- Structure should mainly consist of a mandatory `type` and optional `payload`.
  Error related actions should have a `error` field. `payload` should be a object
  consisting of one or more fields of data related to the action. Type should
  be value imported from `constants.js` file
  
       # Example
       {
         type: HANDLE_LOGIN
         payload: {
           email: ''
           password: ''
         }
       }

## Selectors
- Name should simply be `select<Thing>`
       
       # Examples       
       selectToken();
       selectUser();
       

## Reducers

## Translation Strings
