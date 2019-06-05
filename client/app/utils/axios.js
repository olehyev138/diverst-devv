const axios = require('axios');

export default function configureAxios() {
  // Add a request interceptor
  axios.interceptors.request.use(
    config =>
      // Do something before request is sent
      config,
    error =>
      // Do something with request error
      Promise.reject(error)
    ,
  );

  // Add a response interceptor
  axios.interceptors.response.use(
    response =>
      // Do something with response data
      response,
    (rejection) => {
      if (!rejection.response) {
        rejection.response = {
          data: 'Server Unavailable'
        };
      } else if (rejection.response.data && rejection.response.data.message) {
        rejection.response.data = rejection.response.data.message;
      } else if (rejection.response.status == 500) {
        rejection.response.data = 'Internal Server Error. Please contact support@diverst.com';
      } else if (rejection.response.status == 503) {
        rejection.response.data = 'Server Unavailable';
      }

      // Do something with response error
      return Promise.reject(rejection);
    },
  );
}
