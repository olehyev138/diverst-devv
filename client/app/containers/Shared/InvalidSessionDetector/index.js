/**
 *
 * Invalid Session Detector
 *
 */

import React, { memo, useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import dig from 'object-dig';
import { logoutBegin } from 'containers/Shared/App/actions';

// Axios
const axios = require('axios');

export function InvalidSessionDetector(props) {
  // Set axios interceptor and logout a user if they have an invalid user token
  // Immediately render the children
  useEffect(() => {
    axios.interceptors.response.use(
      response => response,
      (error) => {
        if (error.response.data === 'Invalid User Token')
          return props.logoutBegin();

        return Promise.reject(error);
      }
    );
  }, []);

  return props.children;
}

InvalidSessionDetector.propTypes = {
  logoutBegin: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({});

const mapDispatchToProps = {
  logoutBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps
);

export default compose(
  withConnect,
  memo,
)(InvalidSessionDetector);
