import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

export function GroupPopulationGraph(props) {
  return (
    <React.Fragment>
    </React.Fragment>
  );
}

GroupPopulationGraph.propTypes = {
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
)(GroupPopulationGraph);
