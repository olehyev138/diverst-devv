import React, { memo } from 'react';
import { compose } from 'redux';

import PropTypes from 'prop-types';

export default function WithPermission(Component) {
  const WrappedComponent = ({ show, valid, ...props }) => show || (valid && valid())
    ? <Component {...props} />
    : <React.Fragment />;

  WrappedComponent.propTypes = {
    show: PropTypes.bool,
    valid: PropTypes.func,
    predicate: PropTypes.func,
  };

  return compose(
  )(WrappedComponent);
}
