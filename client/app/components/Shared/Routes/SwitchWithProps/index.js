import React, { memo } from 'react';
import { Switch } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { renderChildrenWithProps } from 'utils/componentHelpers';

// Same as RouteWithProps except for a Switch
export function SwitchWithProps(props) {
  const { children, location, ...propsToPassDown } = props;

  // Route props
  const switchProps = { location };

  return <Switch {...switchProps} render={() => renderChildrenWithProps(children, { ...propsToPassDown })} />;
}

SwitchWithProps.propTypes = {
  children: PropTypes.any,
  ...Switch.propTypes,
};

export default compose(
  memo,
)(SwitchWithProps);
