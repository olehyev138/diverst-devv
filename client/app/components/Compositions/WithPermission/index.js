import React, { memo } from 'react';
import { compose } from 'redux';

import PropTypes from 'prop-types';

// This component is intended for rendering images from a base64 string,
// likely image data encoded in base64 received from a serializer.
export default function Permission(Component) {
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
