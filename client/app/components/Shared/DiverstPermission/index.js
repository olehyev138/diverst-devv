import React, { memo } from 'react';
import { compose } from 'redux';

import PropTypes from 'prop-types';

function Permission({ show, valid, children }) {
  return show || (valid && valid()) ? children : <React.Fragment />;
}

Permission.propTypes = {
  show: PropTypes.bool,
  valid: PropTypes.func,
  children: PropTypes.any,
};

export default compose(
)(Permission);
