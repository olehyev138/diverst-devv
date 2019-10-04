import React from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { Tabs } from '@material-ui/core';
import withWidth, { isWidthUp, isWidthDown } from '@material-ui/core/withWidth';

export function ResponsiveTabs(props) {
  const { width, ...rest } = props;

  let variant = 'standard';
  let centered = true;

  if (isWidthDown('sm', width)) {
    variant = 'scrollable';
    centered = false;
  }

  return (
    <Tabs
      centered={centered}
      variant={variant}
      scrollButtons='auto'
      {...props}
    >
      {props.children}
    </Tabs>
  );
}

ResponsiveTabs.propTypes = {
  width: PropTypes.string,
  children: PropTypes.any,
};

export default compose(
  withWidth()
)(ResponsiveTabs);
