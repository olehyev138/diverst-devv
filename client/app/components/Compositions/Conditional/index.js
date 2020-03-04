import React from 'react';
import { compose } from 'redux';
import dig from 'object-dig';
import NotAuthorizedPage from 'containers/Shared/NotAuthorizedPage';

import PropTypes from 'prop-types';

function conditionalCheck(props, condition) {
  const parts = condition.split('.');
  return dig(...[props, ...parts]);
}

function conditionsMapper(props, conditions) {
  return conditions.map(cond => conditionalCheck(props, cond));
}

function valid(props, conditions, reducer) {
  return reducer(conditionsMapper(props, conditions));
}

// This component is intended for rendering images from a base64 string,
// likely image data encoded in base64 received from a serializer.
export default function Conditional(Component, conditions, reducer = a => a.reduce((sum, v) => sum || v, false)) {
  const WrappedComponent = props => valid(props, conditions, reducer)
    ? <Component {...props} />
    : <NotAuthorizedPage />;

  WrappedComponent.propTypes = {
    show: PropTypes.bool,
    valid: PropTypes.func,
    predicate: PropTypes.func,
  };

  return compose(
  )(WrappedComponent);
}
