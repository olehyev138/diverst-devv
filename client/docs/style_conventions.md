
## Structuring

## Actions

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
