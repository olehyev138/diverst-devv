import React, { memo } from 'react';
import { Route } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { renderChildrenWithProps } from 'utils/componentHelpers';

// A normal Route component won't pass props down to its children, so this wrapper component does exactly that
// Intended for when a parent component (such as a layout) passes their props to its children, like a page, that's wrapped in a Route
export function RouteWithProps(props) {
  const {
    children,
    path,
    exact,
    strict,
    location,
    sensitive,
    ...propsToPassDown
  } = props;

  // Route props
  const routeProps = { path, exact, strict, location, sensitive };

  return (
    <Route {...routeProps}>
      {renderChildrenWithProps(children, { ...propsToPassDown })}
    </Route>
  );
}

RouteWithProps.propTypes = {
  children: PropTypes.any,
  ...Route.propTypes,
};

export default compose(
  memo,
)(RouteWithProps);
