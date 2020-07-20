## Intro

Aim of this document is to provide a an overview to the frontend
stack. The technologies being used, the conventions in place & how certain aspects are configured. There is also `style_conventions.md` that will explicitly list out conventions and styles we are using and that should be followed to keep our frontend code base clean and organized. 


## Overview - internals, deployment, serving, caching

The frontend application is built off of `react-boilerplate`, a base React application that follows best practices & standards, providing us with a base for building a production React application

In a development environment we run a node server that serves the frontend.

In production we build the app using `npm build` (command in full is in `package.json`). This provides us with a `build/` directory. We upload this build directory to S3 which will statically serve the files to the client. 

The application is bundled with `webpack`, the specific configurations can be seen in `client/app/internals/webpack`. There is a base configuration file and then one for each environment type. We make use of multiple plugins to optimally build our application. Most of which were initially provided & setup by `react-boilerplate`.

#### Caching

Caching properly with a SPA is somewhat complex issue. `react-boilerplate` provides us with `offline-plugin`. OfflinePlugin implements a _service worker_, which caches our application and makes it usable (minus API calls of course) even if there is no network connection. OfflinePlugin creates a `offline-plugin` cache in the browser. Additionally we make use of _Cloudflare_ as a DNS & CDN provider which also implements caching. 

Webpack builds our application in a series of files called _chunks_. These chunks are compressed components of the application as well as the libraries we make use of. All of the chunk files are prefixed with a hash unique to the build. Our index file (`index.html`) is a tiny file which simply references these chunk files. We can then implement long term caching by setting a high cache time to these chunk files and zero cache time to the index file. Index will always be fetched and if it references new chunk files then this will invalidate the cache causing everything to be reloaded. 

Additionally, because of `OfflinePlugin` we also have a service worker file (`sw.js`). This file should also never be cached. When a new service worker is fetched, the default configuration is to only update the app when all the tabs of the application are closed in the users browser. We modified this behavior to auto update the application. Thus when a new version is deployed, the user can do a simple refresh - a new `sw.js` file will be served, this file will take over and update the application. This is all configured inside of the production webpack file & `app.js`. 

Lastly we tell CloudFlare & the browser how to cache our files via the `Cache-Control` header. This header is set via S3 metadata which we set in the `frontend-deployment` script. 

## Tech Stack

This is generally the list of major libraries we are using. There are also smaller packages not listed. To get a full list of dependencies refer
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
