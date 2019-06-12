
# App Conventions

- [Directory structure](#directory-structure)
- [Store structure](#store-structure)
- [Components](#components)
- [Actions](#actions)
- [Selectors](#selectors)
- [Reducers](#reducers)
- [Sagas](#sagas)
- [Translations](#translations)

## Directory structure
We follow the [**React Boilerplate** structure](https://github.com/react-boilerplate/react-boilerplate/blob/master/docs/general/introduction.md#project-structure) in general, but it is not very opinionated beyond some base conventions, so we have our own specifics:

### `app/`
- `api/`
- #### `components/`
  - This is where we store **presentational** components that focus on how things _look_. [(?)](#componentRef)
  - <a id="componentFolderStructureRef"></a>Folder structure is based on logical module separation. Ex:
    - `Shared/` for components that are shared across the entire app [(?)](#sharedStructureRef)
    - `Session/` for session components (`LoginForm`, etc.)
    - `User/` for user components
    - `Admin/` for admin components
      - `Shared/` for admin specific components [(?)](#sharedStructureRef)
      - `Analytics/` for admin analytics specific components
      - `...`
    - `...`
- #### `containers/`
  - This is where we store **container** components that focus on how things _work_. [(?)](#componentRef)
  - Folder structure for containers follows the [same structure as presentational components](#componentFolderStructureRef).
- `images/`
  - Pretty self explanatory: contains media assets.
  - Folder structure is less important here, but we should try to follow the [same structure as presentational components](#componentFolderStructureRef).
- `tests/`
  - Since component and util tests are located within their respective directories, this folder is for general tests that have an app-wide scope. (Ex. i18n translation tests, Redux store tests)
- `translations/`
  - Contains translation files for each language which define the IDs and texts.
- `utils/`
  - Contains non-component helpers and utilities.

---
<a id="sharedStructureRef"></a>**Note:** Use the furthest nested `Shared/` folder that makes sense for your component.

Ex:
- If your component is only used in `Admin/Analytics/`, then place it directly in that folder.
- If your component is used in multiple modules within `Admin/`, then place it in `Admin/Shared/`.
- If your component is used globally across the app, then place it in the root `Shared/`.

---
<a id="componentRef"></a>For more information on containers vs. components:
- [Breakdown](https://stackoverflow.com/a/41636115)
- [In-depth article](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)

## Store structure
- Generally keep the store as normalized and 'database like' as possible. Try to keep it shallow and flat. Store objects with a key for fast access.

  ```javascript
  state = {
    groups: {
      '1': { 
        id: 1,
        name: 'erg-01',
      },
    },
  }
  ```

- A more complex scenario would be say, we had a news feed with posts and comments. An inefficient way of representing this in the store would be:

  ```javascript
  state = {
    newsFeed: {
      id: 3,
      posts: [
        {
          id: 7,
          content: '...',
          comments: [
            {
              id: 9,
              content: '...',
            },
          ],
        },
      ],
    },
  }
  ```

  This is a highly inefficient way of storing data, for one we would have to search through each array looking for a matching id, searching each array is an O(n) operation. 
  
- A more efficient way would be:
  - flattening the structure
  - using keys for O(1) access
  
  ```javascript
  state = {
    newsFeed: {
      byId: {
        '3': { 
          id: 3,
          posts: [1, 7, 3],
        },
      },
    },
    posts: {
      byId: {
        '7': {
          id: 7,
          content: '',
        },
      },
    },
  }
  ```

  Now lookup is instantaneous and we dont have to dig deep into a data structure to find what were looking for. If we say needed to store a ordered version of objects, then in addition to our byId hash, we can have a 'ordered' array of just ids. Like: `ordered: [5, 6, 1, 3]`
  
## Components
  
## Actions
- Generally map action names to API rest/crud actions, ie: `GET_GROUP`, `CREATE_GROUP`
- Actions relating to API querying should have **3 states**: `BEGIN`, `SUCCESS`, `ERROR` / `FAIL`

  `BEGIN` should be the action a saga listens to, to begin the API querying
  
  `SUCCESS` and `ERROR` should be dispatched by the saga and dealt with by a reducer that updates the state accordingly. On these API actions, a store flag called something like `IS_FETCHING` can be toggled to update the UI and show a spinner
  
  ```javascript
  // Example
  GET_GROUP_BEGIN
  GET_GROUP_SUCCESS
  GET_GROUP_ERROR
  ```

- Use `ERROR` over `FAIL` for indiciating failed API queries, to keep things consistent within the project.
- Action names should be defined in `./constants.js` where `./` is container directory
- Action names should be namespaced, so as to avoid possible collision with other actions. Format should be `app/containers/<ContainerName>/ActionName`
- Use action creators, define them in `./actions.js`

- Structure should mainly consist of a mandatory `type` and optional `payload`. Error related actions should have a `error` field. `payload` should be a object consisting of one or more fields of data related to the action. Type should be value imported from `constants.js` file

  ```javascript
  // Example
  const hello = {
    type: HANDLE_LOGIN,
    payload: {
      email: '',
      password: '',
    },
  }
  ```
  
## Selectors
- Name should simply be `select<Thing>`

  ```javascript
  // Examples       
  selectToken();
  selectUser();
  ```
  
- Should always have a selector for the scope within the store and then compose your specific selectors using it
  
  ```javascript
  // Example
  import { createSelector } from 'reselect';
  
  const selectLoginPage = state => state.loginPage;
  
  const selectFormErrors = () => createSelector(
    selectLoginPage,
    loginPageState => loginPageState.formErrors,
  );
  
  export { selectFormErrors };
  ```

## Reducers

## Sagas

## Translations
