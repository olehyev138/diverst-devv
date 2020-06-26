import React, { memo } from 'react';
import { Route } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import Fade from '@material-ui/core/Fade';
import Box from '@material-ui/core/Box';

import { renderChildrenWithProps } from 'utils/componentHelpers';

// A normal Route component won't pass props down to its children, so this wrapper component does exactly that
// Intended for when a parent component (such as a layout) passes their props to its children, like a page, that's wrapped in a Route
// Note: also provides a Fade transition by default
export function RouteWithProps(props) {
  const {
    children,
    fade,
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
      {/* We provide a key because otherwise React simply updates the furthest nested changed components instead of running the transition again with the new Route */}
      <Fade in appear={fade} mountOnEnter unmountOnExit key={path.toString()}>
        <Box>
          {renderChildrenWithProps(children, { ...propsToPassDown })}
        </Box>
      </Fade>
    </Route>
  );
}

RouteWithProps.defaultProps = {
  fade: true,
};

RouteWithProps.propTypes = {
  children: PropTypes.any,
  fade: PropTypes.bool,
  ...Route.propTypes,
};

export default compose(
  memo,
)(RouteWithProps);
