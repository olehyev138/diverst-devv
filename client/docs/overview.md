## Intro

Aim of this document is to provide a bit of an overview to the new frontend
stack. The technologies being used, motivations for using them, some of
the conventions in place. There is also `style_conventions.md` that will
explicitly list out conventions and styles we are using and that should be
followed to keep our frontend code base clean and organized. 

## Tech Stack

This is generally the list of major libraries we are using. There are also
many smaller packages not listed To get a full list of dependencies refer
to `package.json`

#### Core
- react-boilerplate
- react
- redux
- material-ui
- react-router (& connected-react router)
- redux-saga
- immer
- reselect
- axios
- formik
- yup

#### Unit Testing
- Jest
- react-testing-library

#### Linting
- ESLint
- Prettier
- styelint

### [React Boilerplate](https://github.com/react-boilerplate/react-boilerplate)

Provides the initial setup and scaffolding for the overall project.

### [React](https://github.com/facebook/react/)

### [Material UI](https://next.material-ui.com/getting-started/installation/)

The CSS/UI library. Has better support for apps then Bootstrap.

### [React Router](https://reacttraining.com/react-router/web/guides/quick-start)

Used in conjunction with connected-react-router, which connects it to Redux.

Handles all the client side routing.

### [Redux Saga](https://github.com/redux-saga/redux-saga)

Handles asynchronous state changes, ie api querying.

### [Immer](https://github.com/immerjs/immer)

Provides functionality to easily keep the redux state immutable.

### [Reselect](https://github.com/reduxjs/reselect)

Provides functionality to create selectors for redux.

### [Axios](https://github.com/axios/axios)

An HTTP library/client for making API requests.

### [Formik](https://jaredpalmer.com/formik/docs/overview)

React form library. Manages local form state for us.

See docs as to why this is used over something like redux-forms

### [Yup](https://github.com/jquense/yup/blob/master/package.json)

Used in conjunction with Formik to handle form validation.
