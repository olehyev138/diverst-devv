import React, { memo } from 'react';

import { compose } from 'redux';
import PropTypes from 'prop-types';

export function Metrics(props) {
  const event = props?.event;

  return (
    <React.Fragment>
    </React.Fragment>
  );
}

Metrics.propTypes = {
  event: PropTypes.object,
};

export default compose(
  memo,
)(Metrics);